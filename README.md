# ⚡ QuickPanel — 万能快捷面板

<p align="center">
  <img src="assets/icon.svg" width="128" height="128" alt="QuickPanel">
</p>

<p align="center">
  <strong>把常用操作浓缩为一键触发的跨平台快捷面板</strong>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.0+-02569B?style=flat&logo=flutter" alt="Flutter">
  <img src="https://img.shields.io/badge/Android-6.0+-3DDC84?style=flat&logo=android" alt="Android">
  <img src="https://img.shields.io/badge/macOS-10.14+-007AFF?style=flat&logo=apple" alt="macOS">
  <img src="https://img.shields.io/badge/iOS-13.0+-007AFF?style=flat&logo=apple" alt="iOS">
  <img src="https://img.shields.io/badge/License-MIT-green?style=flat" alt="License">
</p>

---

## 📖 简介

QuickPanel 是一款轻量级跨平台快捷操作面板，将高频操作从多步简化为一键触发。支持网址、应用、文本片段、系统命令四种类型，配合自定义图标和颜色，打造个性化效率工具。

## ✨ 功能

| 功能 | 说明 |
|------|------|
| ⚡ 快捷面板 | 网格布局展示所有操作 |
| 🌐 网址快捷 | 一键打开常用网站 |
| 📱 应用快捷 | 快速启动应用 |
| 📝 文本片段 | 一键输入常用文本 |
| 💻 系统命令 | 执行常用命令 |
| 🎨 自定义 | 20种图标 + 12种颜色 |
| 🏷️ 分类筛选 | 按类型快速筛选 |
| 💾 持久化 | 数据本地自动保存 |
| 🌙 深色模式 | 跟随系统主题 |

## 🏗️ 技术栈

- **框架**: Flutter 3.0+ / Dart 3.0+
- **存储**: path_provider 本地文件存储
- **设计**: Material Design 3

## 📁 项目结构

```
QuickPanel/
├── lib/main.dart          # 主程序（UI + 逻辑 + 数据）
├── assets/icon.svg        # 应用图标
├── android/               # Android 工程
├── ios/                   # iOS 工程
├── macos/                 # macOS 工程
├── pubspec.yaml           # 依赖配置
└── README.md              # 本文档
```

## 🚀 构建运行

```bash
# 环境要求
# Flutter SDK >= 3.0.0
# Dart SDK >= 3.0.0
# Android Studio / Xcode

# 安装依赖
flutter pub get

# 运行
flutter run -d android    # Android
flutter run -d macos      # macOS
flutter run -d ios        # iOS

# 构建发布版
flutter build apk --release      # Android APK
flutter build macos --release    # macOS
flutter build ios --release      # iOS
```

## 📋 使用指南

1. 点击 **+** 添加快捷操作
2. 填写名称、选择类型、输入值
3. 选择图标和颜色
4. 单击执行，长按编辑/删除

## 📝 更新日志

### v1.0.0
- 首次发布
- 四种快捷操作类型
- 自定义图标和颜色
- 分类筛选
- 深色模式

## 📄 许可证

MIT License
