# 万事屋

## 📋 项目简介


## ✨ 主要功能

- ✅ **服务管理** - 添加、编辑、删除服务链接
- ✅ **WebView 浏览** - 在应用内直接打开服务网页
- ✅ **本地存储** - 自动保存服务列表，离线可用
- ✅ **美观界面** - Material Design 3 设计风格
- ✅ **自定义配置** - 自由选择图标、颜色、名称
- ✅ **默认服务** - 预设记账、金流、库存等服务

## 🎨 预设服务

- 📊 **记账** - http://192.168.0.197:3010
- 🌍 **记账（国际版）** - http://192.168.0.197:3000
- 💰 **金流** - http://192.168.0.197:3100
- 📦 **库存** - http://192.168.0.197:5000

## 🛠️ 技术栈

- **Flutter 3.35.4** - 跨平台 UI 框架
- **Dart 3.9.2** - 编程语言
- **Provider 6.1.5+1** - 状态管理
- **SharedPreferences 2.5.3** - 本地键值存储
- **WebView Flutter 4.13.0** - WebView 组件
- **URL Launcher** - URL 启动工具

## 📁 项目结构

```
flutter_app/
├── lib/
│   ├── models/
│   │   └── service_item.dart          # 服务项数据模型
│   ├── providers/
│   │   └── service_provider.dart      # 服务管理 Provider
│   ├── pages/
│   │   ├── home_page.dart             # 主页面（服务网格）
│   │   ├── webview_page.dart          # WebView 浏览页面
│   │   └── edit_service_page.dart     # 编辑/添加服务页面
│   └── main.dart                       # 应用入口
├── assets/
│   └── icons/
│       └── app_icon.png                # 应用图标（来自原项目）
├── android/                            # Android 配置
├── web/                                # Web 配置
├── pubspec.yaml                        # 依赖配置
└── README.md                           # 项目说明
```

## 🚀 快速开始

### 环境要求

- Flutter SDK 3.35.4+
- Dart SDK 3.9.2+
- Android Studio / VS Code
- JDK 17+（用于 Android 构建）

### 安装步骤

1. **克隆或解压项目**
   ```bash
   # 如果从 tar.gz 解压
   tar -xzf yorozuya-flutter.tar.gz
   cd flutter_app
   ```

2. **安装依赖**
   ```bash
   flutter pub get
   ```

3. **运行应用**
   
   **Web 预览（推荐用于快速测试）：**
   ```bash
   flutter run -d chrome --release
   ```
   
   **Android 设备：**
   ```bash
   flutter run -d <device-id> --release
   ```
   
   **构建 APK：**
   ```bash
   flutter build apk --release
   ```
   
   构建完成后，APK 文件位于：
   `build/app/outputs/flutter-apk/app-release.apk`

## 📱 使用说明

### 1. 主页面

- 显示所有已添加的服务卡片
- 点击卡片即可在 WebView 中打开服务
- 长按卡片可编辑或删除服务
- 点击右下角「+」按钮添加新服务

### 2. 添加服务

1. 点击主页面右下角的「添加服务」按钮
2. 填写服务名称和 URL
3. 选择喜欢的图标和颜色
4. 可选填写服务描述
5. 点击「添加服务」保存

### 3. 编辑服务

1. 在主页面长按服务卡片
2. 选择「编辑服务」
3. 修改相关信息
4. 点击「保存修改」

### 4. 删除服务

1. 在主页面长按服务卡片
2. 选择「删除服务」
3. 确认删除

## 🔧 配置说明

### 修改默认服务

编辑 `lib/providers/service_provider.dart` 文件中的 `_getDefaultServices()` 方法：

```dart
List<ServiceItem> _getDefaultServices() {
  return [
    ServiceItem(
      id: 'your_service_id',
      name: '服务名称',
      url: 'http://your-service-url',
      icon: Icons.your_icon,
      color: const Color(0xFFyourcolor),
      description: '服务描述',
    ),
    // 添加更多服务...
  ];
}
```

### 修改应用图标

替换以下文件：
- `assets/icons/app_icon.png` - Flutter 资源图标
- `android/app/src/main/res/mipmap-*/ic_launcher.png` - Android 启动图标

### 修改应用名称

编辑 `android/app/src/main/AndroidManifest.xml`：

```xml
<application
    android:label="万事屋"
    ...>
```

## 📦 构建发布版本

### Android APK

```bash
# 构建 Release APK
flutter build apk --release

# APK 输出位置
# build/app/outputs/flutter-apk/app-release.apk
```

### Android App Bundle (AAB)

```bash
# 构建 Release AAB（用于 Google Play）
flutter build appbundle --release

# AAB 输出位置
# build/app/outputs/bundle/release/app-release.aab
```

### Web 版本

```bash
# 构建 Web Release
flutter build web --release

# 输出位置
# build/web/
```

## 🐛 常见问题

### 1. WebView 加载失败

- 检查服务 URL 是否正确
- 确保设备可以访问目标服务器
- 检查网络连接

### 2. 图标不显示

- 尝试使用 `--no-tree-shake-icons` 参数构建
- 清除构建缓存：`flutter clean && flutter pub get`

### 3. 服务列表不保存

- 检查应用是否有存储权限
- 确保 SharedPreferences 初始化成功

## 📄 开源协议

本项目遵循原项目的开源协议。

## 🙏 致谢

- 感谢原项目 [yorozuya](https://github.com/hyalurion-shizutoki/yorozuya) 的创建者
- 感谢 Flutter 和 Dart 团队提供优秀的开发框架

## 📞 联系方式

如有问题或建议，请通过以下方式联系：

- 原项目 Issues: https://github.com/hyalurion-shizutoki/yorozuya/issues

---

**享受使用万事屋 Flutter 版本！** 🎉
