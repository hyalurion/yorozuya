import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:universal_launcher/providers/theme_provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lunar/lunar.dart';

const Color _lightTextPrimary = Color(0xFF333333);
const Color _lightTextSecondary = Color(0xFF555555);
const Color _darkTextPrimary = Color(0xFFe2e8f0);
const Color _darkTextSecondary = Color(0xFFa0aec0);

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, dynamic>? _weatherData;
  bool _isLoadingWeather = false;
  String? _weatherError;
  bool _isInitialized = false;
  DateTime _currentTime = DateTime.now();
  Timer? _timer;
  DateTime? _lastWeatherFetchTime;
  static const Duration _cacheDuration = Duration(minutes: 30);

  @override
  void initState() {
    super.initState();
    _isInitialized = true;
    _fetchWeather();
    _startTimeUpdate();
  }

  void _startTimeUpdate() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _currentTime = DateTime.now();
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<Position?> _getCurrentPosition() async {
    try {
      bool serviceEnabled;
      LocationPermission permission;

      serviceEnabled = await Geolocator.isLocationServiceEnabled().timeout(
        const Duration(seconds: 3),
        onTimeout: () {
          throw TimeoutException('Location service check timeout');
        },
      );
      if (!serviceEnabled) {
        return null;
      }

      permission = await Geolocator.checkPermission().timeout(
        const Duration(seconds: 3),
        onTimeout: () {
          throw TimeoutException('Permission check timeout');
        },
      );
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission().timeout(
          const Duration(seconds: 5),
          onTimeout: () {
            throw TimeoutException('Permission request timeout');
          },
        );
        if (permission == LocationPermission.denied) {
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return null;
      }

      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      ).timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          throw TimeoutException('Get position timeout');
        },
      );
    } catch (e) {
      return null;
    }
  }

  Future<void> _fetchWeather() async {
    if (_lastWeatherFetchTime != null && 
        DateTime.now().difference(_lastWeatherFetchTime!) < _cacheDuration) {
      return;
    }

    setState(() {
      _isLoadingWeather = true;
      _weatherError = null;
    });

    try {
      final position = await _getCurrentPosition();
      final latitude = position?.latitude ?? 39.9042;
      final longitude = position?.longitude ?? 116.4074;

      final response = await http.get(
        Uri.parse('https://api.open-meteo.com/v1/forecast?latitude=$latitude&longitude=$longitude&current=temperature_2m,weather_code,wind_speed_10m,relative_humidity_2m,apparent_temperature,pressure_msl,is_day&daily=weather_code,temperature_2m_max,temperature_2m_min,sunrise,sunset,uv_index_max,precipitation_sum,wind_speed_10m_max&timezone=auto'),
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw TimeoutException('Weather request timeout');
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          _weatherData = json.decode(response.body);
          _isLoadingWeather = false;
          _lastWeatherFetchTime = DateTime.now();
        });
      } else {
        setState(() {
          _weatherError = 'Failed to load weather (Status: ${response.statusCode})';
          _isLoadingWeather = false;
        });
      }
    } on TimeoutException catch (e) {
      setState(() {
        _weatherError = 'Request timeout: ${e.message ?? 'Please check your connection'}';
        _isLoadingWeather = false;
      });
    } catch (e) {
      setState(() {
        _weatherError = 'Error: ${e.toString()}';
        _isLoadingWeather = false;
      });
    }
  }

  String _getWeatherDescription(dynamic code) {
    final Map<int, String> weatherCodes = {
      0: '晴朗',
      1: '多云',
      2: '多云',
      3: '阴天',
      45: '雾',
      48: '雾凇',
      51: '毛毛雨',
      53: '毛毛雨',
      55: '毛毛雨',
      61: '小雨',
      63: '中雨',
      65: '大雨',
      71: '小雪',
      73: '中雪',
      75: '大雪',
      80: '阵雨',
      81: '阵雨',
      82: '暴雨',
      95: '雷雨',
      96: '雷雨伴有冰雹',
      99: '雷雨伴有冰雹',
    };
    final int codeInt = code is int ? code : (code is double ? code.toInt() : 0);
    return weatherCodes[codeInt] ?? '未知';
  }

  IconData _getWeatherIcon(dynamic code) {
    final int codeInt = code is int ? code : (code is double ? code.toInt() : 0);
    if (codeInt == 0) return Icons.wb_sunny;
    if (codeInt <= 3) return Icons.cloud;
    if (codeInt <= 48) return Icons.foggy;
    if (codeInt <= 67) return Icons.water_drop;
    if (codeInt <= 77) return Icons.ac_unit;
    if (codeInt <= 82) return Icons.grain;
    return Icons.thunderstorm;
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final bool isDarkMode = themeProvider.isDarkMode;
    final Color textPrimary = isDarkMode ? _darkTextPrimary : _lightTextPrimary;
    final Color textSecondary = isDarkMode ? _darkTextSecondary : _lightTextSecondary;

    if (!_isInitialized) {
      return SafeArea(
        child: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(textSecondary),
          ),
        ),
      );
    }

    final now = DateTime.now();
    final date = '${now.year}年${now.month.toString().padLeft(2, '0')}月${now.day.toString().padLeft(2, '0')}日';
    final weekdays = ['一', '二', '三', '四', '五', '六', '日'];
    final weekday = weekdays[now.weekday - 1];
    
    final lunarDate = Lunar.fromDate(now);
    final lunarMonth = '${lunarDate.getMonthInChinese()}月';
    final lunarDay = lunarDate.getDayInChinese();
    final lunarGanZhiYear = lunarDate.getYearInGanZhi();
    final lunarFullString = '$lunarGanZhiYear年$lunarMonth$lunarDay';

    return SafeArea(
      child: SizedBox(
        height: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: _buildSmartSuggestionCard(
            date: date,
            weekday: weekday,
            lunarDate: lunarFullString,
            textPrimary: textPrimary,
            textSecondary: textSecondary,
            isDarkMode: isDarkMode,
          ),
        ),
      ),
    );
  }

  Widget _buildSmartSuggestionCard({
    required String date,
    required String weekday,
    required String lunarDate,
    required Color textPrimary,
    required Color textSecondary,
    required bool isDarkMode,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeScreen = screenWidth > 768;
    final time = _currentTime;
    final timeStr = '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:${time.second.toString().padLeft(2, '0')}';
    final smartSuggestion = _generateSmartSuggestion();

    return Container(
      padding: isLargeScreen ? const EdgeInsets.all(32.0) : const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: isDarkMode 
            ? Colors.black.withValues(alpha: 0.3)
            : Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: isDarkMode 
              ? Colors.white.withValues(alpha: 0.1)
              : Colors.grey.withValues(alpha: 0.3),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: isDarkMode 
                ? Colors.black.withValues(alpha: 0.3)
                : Colors.black.withValues(alpha: 0.1),
            blurRadius: 32.0,
            spreadRadius: 8.0,
          ),
        ],
      ),
      child: isLargeScreen
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '智能建议',
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          color: textPrimary,
                        ),
                      ),
                      const SizedBox(height: 24.0),
                      Text(
                        date,
                        style: TextStyle(
                          fontSize: 32.0,
                          fontWeight: FontWeight.bold,
                          color: textPrimary,
                        ),
                      ),
                      const SizedBox(height: 12.0),
                      Text(
                        '星期$weekday',
                        style: TextStyle(
                          fontSize: 20.0,
                          color: textSecondary,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        lunarDate,
                        style: TextStyle(
                          fontSize: 18.0,
                          color: textSecondary,
                        ),
                      ),
                      const SizedBox(height: 24.0),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 28.0,
                            color: textPrimary,
                          ),
                          const SizedBox(width: 12.0),
                          Text(
                            timeStr,
                            style: TextStyle(
                              fontSize: 36.0,
                              fontWeight: FontWeight.bold,
                              color: textPrimary,
                              fontFamily: 'Courier New',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 32.0),
                const VerticalDivider(width: 1.0),
                const SizedBox(width: 32.0),
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _isLoadingWeather
                          ? Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(textSecondary),
                              ),
                            )
                          : _buildSmartSuggestionContent(smartSuggestion, textPrimary, textSecondary),
                    ],
                  ),
                ),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '智能建议',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: textPrimary,
                  ),
                ),
                const SizedBox(height: 16.0),
                Text(
                  date,
                  style: TextStyle(
                    fontSize: 28.0,
                    fontWeight: FontWeight.bold,
                    color: textPrimary,
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  '星期$weekday  $lunarDate',
                  style: TextStyle(
                    fontSize: 18.0,
                    color: textSecondary,
                  ),
                ),
                const SizedBox(height: 16.0),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 24.0,
                      color: textPrimary,
                    ),
                    const SizedBox(width: 8.0),
                    Text(
                      timeStr,
                      style: TextStyle(
                        fontSize: 32.0,
                        fontWeight: FontWeight.bold,
                        color: textPrimary,
                        fontFamily: 'Courier New',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                Divider(color: textSecondary.withOpacity(0.3)),
                const SizedBox(height: 16.0),
                _isLoadingWeather
                    ? Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(textSecondary),
                        ),
                      )
                    : _buildSmartSuggestionContent(smartSuggestion, textPrimary, textSecondary),
              ],
            ),
    );
  }

  Widget _buildSmartSuggestionContent(String suggestion, Color textPrimary, Color textSecondary) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.lightbulb,
              size: 20.0,
              color: Colors.amber,
            ),
            const SizedBox(width: 8.0),
            Text(
              '今日建议',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12.0),
        Text(
          suggestion,
          style: TextStyle(
            fontSize: 16.0,
            color: textSecondary,
            height: 1.6,
          ),
        ),
      ],
    );
  }

  String _generateSmartSuggestion() {
    if (_weatherError != null) {
      return '天气信息获取失败，请检查网络连接。今天也要保持好心情哦~';
    }

    if (_weatherData == null) {
      return '正在获取天气信息...';
    }

    final current = _weatherData!['current'];
    final daily = _weatherData!['daily'];
    final code = current['weather_code'];
    final temp = double.tryParse(current['temperature_2m'].toString()) ?? 0.0;
    final windSpeed = double.tryParse(current['wind_speed_10m'].toString()) ?? 0.0;
    final humidity = double.tryParse(current['relative_humidity_2m'].toString()) ?? 0;
    
    final uvIndexList = daily['uv_index_max'] as List?;
    final precipitationList = daily['precipitation_sum'] as List?;
    
    final uvIndex = uvIndexList != null && uvIndexList.isNotEmpty ? double.tryParse(uvIndexList[0].toString()) ?? 0.0 : 0.0;
    final precipitation = precipitationList != null && precipitationList.isNotEmpty ? double.tryParse(precipitationList[0].toString()) ?? 0.0 : 0.0;

    final weatherDesc = _getWeatherDescription(code);
    List<String> suggestions = [];

    if (precipitation > 0.5) {
      suggestions.add('今天有${precipitation > 10 ? '大雨' : '小雨'}，记得带伞哦~');
    } else if (weatherDesc == '晴朗') {
      suggestions.add('今天天气晴朗，适合出门活动~');
    } else if (weatherDesc == '阴天') {
      suggestions.add('今天阴天，天气比较舒适~');
    } else if (weatherDesc == '雾') {
      suggestions.add('今天有雾，出行请注意安全~');
    }

    if (uvIndex >= 6) {
      suggestions.add('紫外线${uvIndex >= 8 ? '很强' : '较强'}，记得涂防晒霜~');
    }

    if (windSpeed >= 20) {
      suggestions.add('今天风力较大，请注意防范高空坠物风险~');
    }

    if (temp >= 35) {
      suggestions.add('今天气温很高，避免长时间户外活动~');
    } else if (temp <= 10) {
      suggestions.add('今天气温较低，记得多穿点衣服~');
    }

    if (humidity >= 80) {
      suggestions.add('今天空气湿度较高，感觉会比较闷热~');
    }

    if (suggestions.isEmpty) {
      suggestions.add('今天天气不错，适合安排户外活动~');
    }

    return '今天$weatherDesc，${temp.toStringAsFixed(1)}°C。${suggestions.join(' ')}';
  }
}
