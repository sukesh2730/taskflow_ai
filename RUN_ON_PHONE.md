# 📱 Run TaskFlow Mobile App on Physical Phone

## 🎯 Quick Guide

### For Android Phone

#### Step 1: Enable Developer Mode
1. Go to **Settings** → **About Phone**
2. Tap **Build Number** 7 times
3. You'll see "You are now a developer!"

#### Step 2: Enable USB Debugging
1. Go to **Settings** → **Developer Options**
2. Enable **USB Debugging**
3. Enable **Install via USB** (if available)

#### Step 3: Connect Phone to Computer
1. Connect phone via USB cable
2. On phone, tap **Allow USB Debugging** when prompted
3. Check "Always allow from this computer"

#### Step 4: Verify Connection
```bash
# Check if device is detected
flutter devices
```

You should see your phone listed:
```
Android SDK built for x86 (mobile) • emulator-5554 • android-x86 • Android 11 (API 30)
SM-G991B (mobile) • R5CR1234ABC • android-arm64 • Android 13 (API 33)  ← Your phone
```

#### Step 5: Run App on Phone
```bash
cd taskflow_mobile
flutter run
```

Flutter will automatically detect your phone and install the app!

---

### For iPhone

#### Step 1: Install Xcode (Mac Only)
```bash
# Install from App Store
# Open Xcode and accept license
sudo xcodebuild -license accept
```

#### Step 2: Trust Computer
1. Connect iPhone via USB
2. On iPhone, tap **Trust This Computer**
3. Enter iPhone passcode

#### Step 3: Configure Signing
1. Open `taskflow_mobile/ios/Runner.xcworkspace` in Xcode
2. Select **Runner** in left panel
3. Go to **Signing & Capabilities**
4. Select your **Team** (Apple ID)
5. Xcode will auto-generate provisioning profile

#### Step 4: Run App
```bash
cd taskflow_mobile
flutter run
```

---

## 🌐 Configure Backend URL for Phone

### Problem
Your phone can't access `localhost` or `10.0.2.2` (emulator addresses)

### Solution: Use Your Computer's IP Address

#### Step 1: Find Your Computer's IP

**Windows:**
```bash
ipconfig
```
Look for: `IPv4 Address: 192.168.1.XXX`

**Mac/Linux:**
```bash
ifconfig | grep "inet "
```
Look for: `inet 192.168.1.XXX`

#### Step 2: Update API Service

Edit `taskflow_mobile/lib/services/api_service.dart`:

```dart
// BEFORE (for emulator)
const String baseUrl = 'http://10.0.2.2:8000/api/v1';

// AFTER (for physical phone)
const String baseUrl = 'http://192.168.1.XXX:8000/api/v1';
//                              ↑↑↑↑↑↑↑↑↑↑↑↑
//                              Your computer's IP
```

#### Step 3: Ensure Backend Allows External Connections

Edit `taskflow_ai/app/main.py`:

```python
if __name__ == "__main__":
    import uvicorn
    uvicorn.run(
        "app.main:app",
        host="0.0.0.0",  # ← Allow external connections
        port=8000,
        reload=True
    )
```

Or update `docker-compose.yml`:

```yaml
services:
  api:
    ports:
      - "0.0.0.0:8000:8000"  # ← Bind to all interfaces
```

#### Step 4: Allow Firewall Access

**Windows:**
```bash
# Allow port 8000 through firewall
netsh advfirewall firewall add rule name="TaskFlow API" dir=in action=allow protocol=TCP localport=8000
```

**Mac:**
```bash
# System Preferences → Security & Privacy → Firewall → Firewall Options
# Add Python/Docker and allow incoming connections
```

---

## 🚀 Complete Setup for Phone Testing

### Terminal 1: Start Backend (Allow External Access)
```bash
cd taskflow_ai
docker-compose up
```

### Terminal 2: Update API URL and Run App
```bash
cd taskflow_mobile

# Edit api_service.dart with your IP
# Then run:
flutter run
```

### Verify Connection
1. App launches on phone
2. Check "Today" tab
3. If you see tasks or "Offline" → Backend connection issue
4. If you see loading → Backend is working!

---

## 🧪 Test Offline Mode on Phone

### Scenario 1: Start Offline
1. Turn off WiFi on phone
2. Launch app
3. Should show cached data or empty states
4. Burnout risk shows "Offline"
5. Create operations fail gracefully

### Scenario 2: Go Offline While Using
1. Launch app with WiFi on
2. Load some tasks/projects
3. Turn off WiFi
4. App should show last cached data
5. Try to create task → Fails silently
6. Turn WiFi back on → Data refreshes

---

## 📱 Build APK for Distribution (Android)

### Debug APK (Quick Testing)
```bash
cd taskflow_mobile
flutter build apk --debug
```

APK location: `build/app/outputs/flutter-apk/app-debug.apk`

### Release APK (Production)
```bash
flutter build apk --release
```

APK location: `build/app/outputs/flutter-apk/app-release.apk`

### Install APK Manually
1. Copy APK to phone
2. Open file manager on phone
3. Tap APK file
4. Tap "Install"
5. Allow "Install from unknown sources" if prompted

---

## 🍎 Build IPA for Distribution (iOS)

### Debug Build
```bash
cd taskflow_mobile
flutter build ios --debug
```

### Release Build (Requires Apple Developer Account)
```bash
flutter build ios --release
```

### Install via Xcode
1. Open `ios/Runner.xcworkspace` in Xcode
2. Select your iPhone as target
3. Click ▶️ Run button
4. App installs and launches on phone

---

## 🐛 Troubleshooting

### Phone Not Detected

**Android:**
```bash
# Check ADB devices
adb devices

# If empty, try:
adb kill-server
adb start-server
adb devices
```

**iOS:**
```bash
# Check devices
flutter devices

# If not showing, try:
# Unplug and replug iPhone
# Restart Xcode
# Restart computer
```

### Connection Refused Error

**Problem:** App can't reach backend

**Solutions:**
1. ✅ Check computer IP is correct
2. ✅ Ensure phone and computer on same WiFi network
3. ✅ Check firewall allows port 8000
4. ✅ Verify backend is running: `curl http://YOUR_IP:8000/docs`
5. ✅ Try from phone browser: `http://YOUR_IP:8000/docs`

### App Crashes on Launch

**Solutions:**
```bash
# Clear build cache
flutter clean
flutter pub get

# Rebuild
flutter run
```

### Hot Reload Not Working on Phone

**Solution:**
- Hot reload works on physical devices
- If not working, try full restart: Press `R` in terminal

---

## 📊 Performance on Physical Phone

### Expected Performance
- **App Launch**: < 3 seconds
- **Tab Switching**: Instant
- **List Scrolling**: 60 FPS
- **API Calls**: < 1 second (local network)

### If Slow
1. Check WiFi signal strength
2. Ensure backend is on same network
3. Try release build instead of debug
4. Check phone isn't in power saving mode

---

## 🎯 Quick Test on Phone

### 1. Launch App
- ✅ App opens without crash
- ✅ Shows Today tab

### 2. Test Offline
- Turn off WiFi
- ✅ App doesn't crash
- ✅ Shows "Offline" status

### 3. Test Online
- Turn on WiFi
- ✅ Data loads
- ✅ Can create tasks/projects

### 4. Test Features
- ✅ Create project
- ✅ Create task with due date
- ✅ Complete task → Badge notification
- ✅ Navigate between tabs

---

## 📝 Configuration Checklist

Before running on phone:

- [ ] Developer mode enabled on phone
- [ ] USB debugging enabled
- [ ] Phone connected and authorized
- [ ] `flutter devices` shows phone
- [ ] Computer IP address found
- [ ] `api_service.dart` updated with IP
- [ ] Backend allows external connections
- [ ] Firewall allows port 8000
- [ ] Phone and computer on same WiFi
- [ ] Backend is running

---

## 🚀 Quick Commands

### Android
```bash
# 1. Find your IP
ipconfig

# 2. Update api_service.dart with IP

# 3. Run on phone
cd taskflow_mobile
flutter run

# 4. Build APK
flutter build apk --release
```

### iOS
```bash
# 1. Find your IP
ifconfig | grep "inet "

# 2. Update api_service.dart with IP

# 3. Run on phone
cd taskflow_mobile
flutter run

# 4. Build for App Store
flutter build ios --release
```

---

## ✅ Success Criteria

App is working on phone when:

✅ App launches without crash  
✅ UI is responsive and smooth  
✅ Can connect to backend (if online)  
✅ Shows "Offline" gracefully (if offline)  
✅ All features work as expected  
✅ No lag or stuttering  
✅ Battery usage is reasonable  

---

**Ready to test on your phone? Follow the steps above!** 📱🚀
