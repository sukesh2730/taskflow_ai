# 🚀 TaskFlow AI - Ultimate Edition

> **AI-Powered Task Manager with Voice Input, Focus Timer, Dark Mode & Data Export**

![Version](https://img.shields.io/badge/version-1.1.0-blue)
![Flutter](https://img.shields.io/badge/Flutter-3.24.5-02569B?logo=flutter)
![Status](https://img.shields.io/badge/status-production%20ready-success)

---

## ✨ Features

### 🎙️ Voice Input with AI
- **Speak naturally** to create tasks
- **AI automatically detects**:
  - Due dates (today, tomorrow, next week)
  - Priority levels (urgent, important)
  - Energy requirements
- **Hands-free** task creation

### 🍅 Focus Timer (Pomodoro)
- **25-minute focus sessions**
- Beautiful circular progress indicator
- Play/Pause/Reset controls
- Completion notifications
- Boost your productivity!

### 🌙 Dark Mode
- **Toggle light/dark themes** instantly
- Material 3 design system
- Battery-friendly for OLED screens
- Consistent across all screens

### 💾 Data Backup & Export
- **Export to JSON** format
- **Share via any app** (WhatsApp, Email, Drive)
- Timestamped backups
- Includes tasks, projects, achievements

### 🤖 AI-Powered Features
- **Smart task sorting** based on your energy level
- **Burnout risk detection** (offline mode)
- **Achievement system** with unlockable badges
- **Energy-based recommendations**

### 📱 Core Features
- ✅ Offline-first (works without internet)
- ✅ Project organization
- ✅ Task prioritization
- ✅ Energy level tracking
- ✅ Gamification system
- ✅ Beautiful Material 3 UI

---

## 🎮 How to Use

### Creating Tasks with Voice

1. Tap the **+** button
2. Enable "Smart AI Input" toggle
3. Tap the **microphone icon**
4. Say your task naturally:
   - "Buy groceries tomorrow"
   - "Meeting with team urgent"
   - "Call mom next week"
5. AI automatically fills in:
   - Task title
   - Due date
   - Priority level
   - Energy requirement
6. Tap "Create Task"

### Using the Focus Timer

1. Tap the **Timer** tab (bottom navigation)
2. See the 25:00 countdown
3. Tap **Play** to start your focus session
4. Work without distractions
5. Tap **Pause** if you need a break
6. Tap **Reset** to start over
7. Get notified when session completes!

### Switching Themes

1. Tap the **Profile** tab
2. Toggle the **Dark Mode** switch
3. Watch the entire app change instantly!
4. Your preference is saved automatically

### Backing Up Your Data

1. Tap the **Profile** tab
2. Tap **Backup Data**
3. A JSON file is created with all your data
4. Share dialog opens automatically
5. Choose where to save:
   - Google Drive
   - WhatsApp
   - Email
   - Any other app
6. Your data is safely backed up!

---

## 🛠️ Installation

### Option 1: Download Pre-built APK (Easiest)

1. Go to [Releases](../../releases)
2. Download `taskflow-v1.1.0-release.apk`
3. Transfer to your Android device
4. Enable "Install from Unknown Sources"
5. Tap the APK to install
6. Open TaskFlow AI and enjoy!

### Option 2: Build from Source

#### Prerequisites
- Flutter SDK 3.24.5 or higher
- Android SDK
- Java 17

#### Build Steps

```bash
# Clone the repository
git clone <your-repo-url>
cd taskflow

# Navigate to mobile app
cd taskflow_mobile

# Get dependencies
flutter pub get

# Build release APK
flutter build apk --release

# Find your APK at:
# build/app/outputs/flutter-apk/app-release.apk
```

### Option 3: GitHub Actions (No Local Setup)

1. Fork this repository
2. Go to **Actions** tab
3. Click **Build Android APK**
4. Click **Run workflow**
5. Wait 5-10 minutes
6. Download APK from **Artifacts**

---

## 📱 Screenshots

### Light Mode
- Dashboard with AI-sorted tasks
- Voice input with smart parsing
- Focus timer in action
- Profile with achievements

### Dark Mode
- Beautiful dark theme
- Easy on the eyes
- Battery-friendly
- Consistent design

---

## 🏗️ Architecture

### Tech Stack
- **Framework**: Flutter 3.24.5
- **State Management**: Riverpod
- **Database**: SQLite (sqflite)
- **Voice**: speech_to_text
- **UI**: Material 3 Design
- **Fonts**: Google Fonts (Inter)

### Project Structure
```
taskflow_mobile/
├── lib/
│   ├── main.dart                 # App entry point
│   ├── models/                   # Data models
│   │   ├── task.dart
│   │   ├── project.dart
│   │   └── log.dart
│   ├── screens/                  # UI screens
│   │   ├── dashboard_screen.dart
│   │   ├── add_task_screen.dart  # Voice input
│   │   ├── focus_screen.dart     # Pomodoro timer
│   │   ├── profile_screen.dart   # Dark mode + Backup
│   │   └── projects_screen.dart
│   ├── services/                 # Business logic
│   │   ├── repository.dart       # Data + Export
│   │   ├── smart_parser.dart     # AI parsing
│   │   └── local_database.dart
│   └── providers/                # State management
│       ├── app_providers.dart
│       └── theme_provider.dart   # Dark mode state
└── android/                      # Android config
```

### Dependencies
```yaml
flutter_riverpod: ^2.4.9      # State management
sqflite: ^2.3.0                # Local database
speech_to_text: ^6.6.0         # Voice recognition
permission_handler: ^11.3.0    # Permissions
share_plus: ^9.0.0             # File sharing
percent_indicator: ^4.2.3      # Timer UI
google_fonts: ^6.1.0           # Typography
intl: ^0.19.0                  # Date formatting
```

---

## 🎯 Roadmap

### Completed ✅
- [x] Voice input with AI parsing
- [x] Focus timer (Pomodoro)
- [x] Dark mode support
- [x] Data backup & export
- [x] Offline-first architecture
- [x] Achievement system
- [x] Energy-based sorting

### Future Enhancements 🚀
- [ ] Cloud sync (optional)
- [ ] Widgets for home screen
- [ ] Calendar integration
- [ ] Recurring tasks
- [ ] Task templates
- [ ] Statistics dashboard
- [ ] Custom themes
- [ ] Import from JSON

---

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

### Development Setup

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

---

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Material Design team for the design system
- Open source community for the packages

---

## 📞 Support

- **Issues**: [GitHub Issues](../../issues)
- **Discussions**: [GitHub Discussions](../../discussions)
- **Email**: your-email@example.com

---

## 🎉 Version History

### v1.1.0 (Current) - Ultimate Upgrade
- ✨ Added voice input with AI parsing
- ✨ Added focus timer (Pomodoro)
- ✨ Added dark mode support
- ✨ Added data backup & export
- 🐛 Bug fixes and improvements

### v1.0.0 - Initial Release
- ✅ Basic task management
- ✅ Project organization
- ✅ Achievement system
- ✅ Offline support

---

## 📊 Stats

- **Lines of Code**: ~3,000+
- **Features**: 9 major features
- **Screens**: 6 main screens
- **Build Time**: ~5-10 minutes
- **APK Size**: ~20-30 MB
- **Min Android**: 5.0 (API 21)
- **Target Android**: 14 (API 34)

---

**Made with ❤️ using Flutter**

**Ready to boost your productivity? Download TaskFlow AI now!** 🚀
