// Currency exchange data powered by currency_sdk (160+ currencies, offline-first)
import 'package:currency_sdk/currency_sdk.dart';

// Singleton CurrencyService to manage currency_sdk client
class CurrencyService {
  static final CurrencyClient _client = CurrencyClient();
  static bool _initialized = false;
  static bool _sdkFailed = false;
  static List<String> _supportedCurrencies = [];
  static Map<String, double> _cachedRates = {};
  static const String _baseCurrency = 'USD';

  CurrencyService._internal();

  static Future<void> initialize() async {
    if (_initialized) return;
    try {
      await _client.initialize();
      await _refreshData();
    } catch (e) {
      // SDK failed to initialize, use fallback data
      _sdkFailed = true;
      _cachedRates = Map<String, double>.from(_initialRates);
    }
    _initialized = true;
  }

  static Future<void> _refreshData() async {
    try {
      _supportedCurrencies = await _client.getSupportedCurrencies();
      final rates = await _client.getRates(_baseCurrency);
      _cachedRates = Map<String, double>.from(rates.conversionRates);
    } catch (e) {
      _sdkFailed = true;
      _cachedRates = Map<String, double>.from(_initialRates);
    }
  }

  static List<String> get supportedCurrencies =>
      _supportedCurrencies.isEmpty ? _initialRates.keys.toList() : _supportedCurrencies;
  static Map<String, double> get cachedRates =>
      _cachedRates.isEmpty ? _initialRates : _cachedRates;
  static double? getRate(String currency) => cachedRates[currency];
  static bool get isOnline => _client.isOnline;

  static Future<void> syncCurrencies(List<String> currencies) async {
    await _client.syncCurrencies(currencies);
    await _refreshData();
  }

  static Future<double> convert({
    required double amount,
    required String from,
    required String to,
  }) async {
    if (_sdkFailed) {
      // Use fallback rates for conversion
      final fromRate = _initialRates[from] ?? 1.0;
      final toRate = _initialRates[to] ?? 1.0;
      return amount * (toRate / fromRate);
    }
    try {
      return await _client.convert(amount: amount, from: from, to: to);
    } catch (e) {
      // Fallback to manual calculation
      final fromRate = cachedRates[from] ?? 1.0;
      final toRate = cachedRates[to] ?? 1.0;
      return amount * (toRate / fromRate);
    }
  }

  static Future<void> clearCache() async {
    await _client.clearCache();
    _cachedRates.clear();
    _supportedCurrencies.clear();
  }

  static void dispose() {
    _client.dispose();
    _initialized = false;
  }
}

// Initial fallback rates (replaced by currency_sdk data when initialized)
const Map<String, double> _initialRates = {
  'USD': 1.0,
  'CNY': 6.8282,
  'EUR': 0.8532,
  'GBP': 0.736621,
  'JPY': 157.06,
  'KRW': 1471.32,
  'HKD': 7.8344,
  'SGD': 1.2736,
  'AUD': 1.3878,
  'CAD': 1.3589,
  'CHF': 0.9012,
  'INR': 83.12,
  'MXN': 17.15,
  'BRL': 4.97,
  'THB': 35.67,
  'RUB': 91.23,
  'TRY': 32.15,
  'AED': 3.6725,
  'MYR': 4.7215,
  'PHP': 55.89,
  'VND': 24585.0,
  'IDR': 15645.0,
  'TWD': 31.52,
  'NZD': 1.6234,
  'SEK': 10.4567,
  'NOK': 10.8234,
  'DKK': 6.8723,
  'PLN': 3.9876,
  'ZAR': 18.67,
  'ILS': 3.6725,
  'CLP': 878.45,
  'COP': 3945.67,
  'PEN': 3.7234,
  'ARS': 870.12,
  'EGP': 30.89,
  'PKR': 278.45,
  'BDT': 109.78,
  'LKR': 323.56,
  'NPR': 133.12,
};

// Currency names mapping (Chinese)
final Map<String, String> currencyNames = {
  'USD': '美元',
  'CNY': '人民币',
  'EUR': '欧元',
  'GBP': '英镑',
  'JPY': '日元',
  'KRW': '韩元',
  'HKD': '港币',
  'SGD': '新加坡元',
  'AUD': '澳元',
  'CAD': '加元',
  'CHF': '瑞士法郎',
  'SEK': '瑞典克朗',
  'NZD': '新西兰元',
  'MXN': '墨西哥比索',
  'NOK': '挪威克朗',
  'TRY': '土耳其里拉',
  'INR': '印度卢比',
  'BRL': '巴西雷亚尔',
  'ZAR': '南非兰特',
  'DKK': '丹麦克朗',
  'PLN': '波兰兹罗提',
  'THB': '泰铢',
  'IDR': '印尼盾',
  'HUF': '匈牙利福林',
  'CZK': '捷克克朗',
  'ILS': '以色列谢克尔',
  'CLP': '智利比索',
  'PHP': '菲律宾比索',
  'AED': '阿联酋迪拉姆',
  'COP': '哥伦比亚比索',
  'SAR': '沙特里亚尔',
  'MYR': '马来西亚林吉特',
  'RON': '罗马尼亚列伊',
  'TWD': '新台币',
  'ARS': '阿根廷比索',
  'EGP': '埃及镑',
  'PKR': '巴基斯坦卢比',
  'VND': '越南盾',
  'BDT': '孟加拉塔卡',
  'UAH': '乌克兰格里夫纳',
  'NGN': '尼日利亚奈拉',
  'QAR': '卡塔尔里亚尔',
  'KWD': '科威特第纳尔',
  'BHD': '巴林第纳尔',
  'OMR': '阿曼里亚尔',
  'JOD': '约旦第纳尔',
  'LKR': '斯里兰卡卢比',
  'NPR': '尼泊尔卢比',
  'KES': '肯尼亚先令',
  'GHS': '加纳塞地',
  'TZS': '坦桑尼亚先令',
  'UGX': '乌干达先令',
  'RWF': '卢旺达法郎',
  'MAD': '摩洛哥迪拉姆',
  'DZD': '阿尔及利亚第纳尔',
  'TND': '突尼斯第纳尔',
  'LBP': '黎巴嫩镑',
  'MMK': '缅元',
  'KHR': '瑞尔',
  'LAK': '老挝基普',
  'MNT': '蒙古图格里克',
  'BND': '文莱元',
  'KZT': '哈萨克斯坦坚戈',
  'UZS': '乌兹别克斯坦索姆',
  'GEL': '拉脱维亚拉特',
  'AMD': '亚美尼亚德拉姆',
  'AZN': '阿塞拜疆马纳特',
  'BYN': '白俄罗斯卢布',
  'MDL': '摩尔多瓦列伊',
  'RUB': '俄罗斯卢布',
};

// Backward compatibility - returns cached rates as Map
Map<String, double> get currencyRates =>
    CurrencyService.cachedRates.isEmpty ? _initialRates : CurrencyService.cachedRates;

// Backward compatibility - returns currency codes list
List<String> get currencyCodes => CurrencyService.supportedCurrencies;

// Async conversion using currency_sdk
Future<double> convertToBaseCurrency(
  double price,
  String currency,
  String baseCurrency,
) async {
  if (currency == baseCurrency) return price;
  return await CurrencyService.convert(
    amount: price,
    from: currency,
    to: baseCurrency,
  );
}

// Sync conversion using cached rates
double convertToBaseCurrencySync(
  double price,
  String currency,
  String baseCurrency,
) {
  if (currency == baseCurrency) return price;
  final fromRate = CurrencyService.getRate(currency) ?? 1.0;
  final toRate = CurrencyService.getRate(baseCurrency) ?? 1.0;
  return price * (toRate / fromRate);
}
