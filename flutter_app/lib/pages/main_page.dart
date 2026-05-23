import 'package:flutter/material.dart';
import 'home_page.dart';
import 'calculator_selection_page.dart';
import 'food_page.dart';
import 'settings_page.dart';
import 'liquid_nav_bar.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;
  Widget? _calculatorPage;
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const HomePage(),
      CalculatorSelectionPage(onCalculatorSelected: _setCalculatorPage),
      const FoodPage(),
      const SettingsPage(),
    ];
  }

  void _setCalculatorPage(Widget? page) {
    setState(() {
      _calculatorPage = page;
    });
  }

  Widget _getCurrentPage() {
    if (_currentIndex == 1) {
      return _calculatorPage ?? _pages[1];
    }
    return _pages[_currentIndex];
  }

  final List<String> _titles = [
    '首页',
    '工具箱',
    '今天吃什么',
    '设置',
  ];
  
  final List<IconData> _icons = [
    Icons.home_outlined,
    Icons.calculate_outlined,
    Icons.restaurant_outlined,
    Icons.settings_outlined,
  ];
  
  final List<IconData> _activeIcons = [
    Icons.home,
    Icons.calculate,
    Icons.restaurant,
    Icons.settings,
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeScreen = screenWidth > 768;
    final brightness = Theme.of(context).brightness;
    final isDarkMode = brightness == Brightness.dark;

    return Scaffold(
      body: isLargeScreen
          ? Column(
              children: [
                // 顶部导航栏 - 大屏幕使用文字模式，带顶部留白
                Padding(
                  padding: const EdgeInsets.only(top: 32),
                  child: LiquidNavBar(
                    currentIndex: _currentIndex,
                    onIndexChanged: (index) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                    titles: _titles,
                    icons: _icons,
                    activeIcons: _activeIcons,
                    mode: NavBarMode.textOnly,
                    isDarkMode: isDarkMode,
                  ),
                ),
                // 主内容区域
                Expanded(
                  child: SafeArea(
                    child: Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        constraints: const BoxConstraints(maxWidth: 1200),
                        child: _getCurrentPage(),
                      ),
                    ),
                  ),
                ),
              ],
            )
          : Stack(
              children: [
                // 使用SafeArea确保内容在状态栏下方显示
                SafeArea(
                  child: _getCurrentPage(),
                ),
                // 底部液态导航滑块 - 小屏幕使用图标模式
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: LiquidNavBar(
                    currentIndex: _currentIndex,
                    onIndexChanged: (index) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                    titles: _titles,
                    icons: _icons,
                    activeIcons: _activeIcons,
                    mode: NavBarMode.iconsOnly,
                    isDarkMode: isDarkMode,
                  ),
                ),
              ],
            ),
    );
  }
}