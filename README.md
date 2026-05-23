# 万事屋（Yorozuya）Flutter 版本

## 📋 项目简介

本仓库包含一个基于 Flutter 的工具型应用“万事屋”，主要覆盖日常信息展示、生活工具和出行助手。

应用目标：
- 将日常时间、天气、农历信息聚合到首页
- 提供便捷的价格比较和应急语言表达
- 支持随机餐食建议与主题设置

## ✨ 主要功能

- ✅ 首页仪表盘：当前时间、日期、农历、天气概览和智能建议
- ✅ 工具箱：价格比较器与生活用语急救箱
- ✅ 今日吃什么：随机食物转盘
- ✅ 主题设置：亮色 / 暗色 / 跟随系统，并保存用户选择

## 📁 当前目录结构

```
flutter_app/
├── lib/
│   ├── components/        # 复用 UI 组件
│   ├── data/              # 数据层、API、短语库、汇率等
│   ├── models/            # 数据模型定义
│   ├── pages/             # 页面视图
│   ├── providers/         # Provider 状态管理
│   ├── utils/             # 工具类与辅助函数
│   └── main.dart          # 应用入口
├── assets/                # 应用资源文件
├── android/               # Android 原生配置
├── ios/                   # iOS 原生配置
├── macos/                 # macOS 原生配置
├── web/                   # Web 配置
├── windows/               # Windows 原生配置
└── pubspec.yaml           # 依赖与版本配置
```

## 🔧 技术栈

- Flutter
- Dart
- Provider
- SharedPreferences
- HTTP
- Geolocator
- Lunar
- package_info_plus

## 🚀 快速上手

### 环境要求

- Flutter SDK 3.5.0 及以上
- Dart SDK 3.9 及以上
- Android Studio / VS Code
- JDK 17+

### 安装与运行

```bash
cd d:/chronie-app/universal-lancher/flutter_app
flutter pub get
flutter run -d chrome
```

运行到 Android 设备：

```bash
flutter run -d <device-id>
```

### 常用调试命令

```bash
flutter clean
flutter pub get
flutter analyze
flutter test
```

## 📱 核心页面

- `lib/main.dart`：应用入口，初始化 Provider 和主题
- `lib/pages/main_page.dart`：主导航页面（首页、工具箱、今日吃什么、设置）
- `lib/pages/home_page.dart`：首页内容，包含天气、时间、农历与建议
- `lib/pages/calculator_selection_page.dart`：工具箱入口
- `lib/pages/price_comparison_page.dart`：价格比较器
- `lib/pages/emergency_language_page.dart`：生活用语急救箱
- `lib/pages/food_page.dart`：今日吃什么转盘
- `lib/pages/settings_page.dart`：主题与应用设置

## 🧠 说明

- 首页天气数据使用 `open-meteo.com`，定位不可用时会使用默认坐标。
- 主题设置通过 `SharedPreferences` 保存，切换后会在下次启动时继续保留。
- 项目核心结构已与当前代码一致，旧版服务管理说明已移除。

## 📦 构建发布

### Android APK

```bash
flutter build apk --release
```

### Web

```bash
flutter build web --release
```

## 💡 备注

如果遇到依赖问题，可先执行：

```bash
flutter clean
flutter pub get
```