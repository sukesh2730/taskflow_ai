# 🚀 Quick Start - Testing TaskFlow Mobile App

## One-Command Setup

### Step 1: Start Backend (Terminal 1)
```bash
cd taskflow_ai
docker-compose up
```

Wait for: `Application startup complete`

### Step 2: Start Mobile App (Terminal 2)
```bash
cd taskflow_mobile
flutter run
```

Wait for: App launches on emulator/device

---

## 🎯 Quick Test (2 Minutes)

### Test 1: Create Project (30 seconds)
1. Tap **Projects** tab (folder icon)
2. Tap **+** button
3. Type "Office Work"
4. Tap **Create**
5. ✅ Project appears in list

### Test 2: Create Task with Due Date (45 seconds)
1. Tap **Today** tab (calendar icon)
2. Tap **+** button
3. Type "Submit Report"
4. Tap **Set Due Date**
5. Select tomorrow
6. Move slider to **5** (Urgent)
7. Tap **Create Task**
8. ✅ Task appears with red icon and due date

### Test 3: Unlock Badge (30 seconds)
1. **Swipe task to the right**
2. ✅ Golden notification: "🏆 Unlocked: The Starter!"

### Test 4: View Profile (15 seconds)
1. Tap **Profile** tab (trophy icon)
2. ✅ See "The Starter" badge in color
3. ✅ Other badges are grey (locked)

---

## ✅ Success Criteria

If all 4 tests pass:
- ✅ **Backend Integration**: Working
- ✅ **Projects Feature**: Working
- ✅ **Due Dates Feature**: Working
- ✅ **Gamification**: Working
- ✅ **Navigation**: Working

**Result**: 🎉 **APP IS READY!**

---

## 🐛 Troubleshooting

### Backend Not Starting?
```bash
cd taskflow_ai
docker-compose down
docker-compose up --build
```

### Mobile App Not Connecting?
Check `taskflow_mobile/lib/services/api_service.dart`:
```dart
const String baseUrl = 'http://10.0.2.2:8000/api/v1';  // Android Emulator
// OR
const String baseUrl = 'http://localhost:8000/api/v1';  // iOS Simulator
```

### App Not Launching?
```bash
cd taskflow_mobile
flutter clean
flutter pub get
flutter run
```

---

## 📚 Full Documentation

- **Complete Test Guide**: `FINAL_TEST_GUIDE.md`
- **Feature Details**: `MOBILE_UPGRADE_COMPLETE.md`
- **Project Status**: `PROJECT_STATUS_FINAL.md`
- **Requirements**: `.kiro/specs/mobile-app-upgrade/requirements.md`
- **Design**: `.kiro/specs/mobile-app-upgrade/design.md`
- **Tasks**: `.kiro/specs/mobile-app-upgrade/tasks.md`

---

## 🎬 Ready to Test?

**Run these two commands in separate terminals:**

```bash
# Terminal 1
cd taskflow_ai && docker-compose up

# Terminal 2  
cd taskflow_mobile && flutter run
```

**Then follow the 2-minute quick test above!** 🚀
