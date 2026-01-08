# 📱 Install TaskFlow on Your Phone - Simple Guide

## 🎯 Two Methods

### Method 1: Direct Install via USB (Easiest)
### Method 2: Build APK and Transfer

---

## 📱 Method 1: Direct Install via USB (RECOMMENDED)

### Step 1: Enable Developer Mode on Phone

**Android Phone:**
1. Open **Settings**
2. Go to **About Phone**
3. Find **Build Number**
4. **Tap it 7 times** rapidly
5. You'll see: "You are now a developer!"

### Step 2: Enable USB Debugging

1. Go back to **Settings**
2. Find **Developer Options** (usually in System or Advanced)
3. Turn on **USB Debugging**
4. Turn on **Install via USB** (if available)

### Step 3: Connect Phone to Computer

1. Connect phone to computer with USB cable
2. On phone, you'll see popup: **"Allow USB Debugging?"**
3. Tap **Allow**
4. Check **"Always allow from this computer"**

### Step 4: Verify Connection

Open terminal/command prompt:

```bash
flutter devices
```

You should see your phone listed:
```
SM-G991B (mobile) • R5CR1234ABC • android-arm64 • Android 13 (API 33)
```

### Step 5: Install App on Phone

```bash
cd taskflow_mobile
flutter run
```

**That's it!** The app will install and launch on your phone! 🎉

---

## 📦 Method 2: Build APK and Transfer

### Step 1: Build APK

Open terminal/command prompt:

```bash
cd taskflow_mobile
flutter build apk --release
```

Wait for build to complete (2-5 minutes).

### Step 2: Find APK File

APK location:
```
taskflow_mobile/build/app/outputs/flutter-apk/app-release.apk
```

### Step 3: Transfer APK to Phone

**Option A: USB Cable**
1. Connect phone to computer
2. Copy `app-release.apk` to phone's Downloads folder

**Option B: Email**
1. Email the APK to yourself
2. Open email on phone
3. Download attachment

**Option C: Cloud Storage**
1. Upload APK to Google Drive/Dropbox
2. Download on phone

**Option D: Bluetooth**
1. Send APK via Bluetooth to phone

### Step 4: Install APK on Phone

1. Open **File Manager** on phone
2. Go to **Downloads** folder
3. Tap **app-release.apk**
4. If prompted, tap **"Install from unknown sources"** → Allow
5. Tap **Install**
6. Tap **Open**

**Done!** App is installed! 🎉

---

## 🚀 Quick Commands

### For Direct Install (Method 1)
```bash
cd taskflow_mobile
flutter run
```

### For APK Build (Method 2)
```bash
cd taskflow_mobile
flutter build apk --release
```

APK location: `build/app/outputs/flutter-apk/app-release.apk`

---

## ✅ Verify Installation

After installation:

1. **Find App**: Look for "TaskFlow AI" icon on home screen
2. **Launch App**: Tap icon
3. **Test Features**:
   - Create a project
   - Create a task
   - Complete a task
   - See badge notification

**All work? ✅ Success!**

---

## 🐛 Troubleshooting

### Phone Not Detected (Method 1)

**Problem**: `flutter devices` doesn't show phone

**Solutions**:
1. Check USB cable is data cable (not just charging)
2. Try different USB port
3. On phone: Turn USB debugging OFF then ON
4. Restart phone
5. Restart computer
6. Try: `adb devices` (should show device)

### Can't Install APK (Method 2)

**Problem**: "Install blocked" or "Can't install"

**Solutions**:
1. Go to **Settings** → **Security**
2. Enable **"Install from unknown sources"**
3. Or enable for specific app (Chrome, File Manager, etc.)
4. Try again

### App Crashes on Launch

**Solutions**:
```bash
# Rebuild clean
cd taskflow_mobile
flutter clean
flutter pub get
flutter build apk --release
```

### "App not installed" Error

**Solutions**:
1. Uninstall any previous version
2. Restart phone
3. Try installing again

---

## 📊 What You Get

After installation:

✅ **Standalone App** - No server needed  
✅ **Works Offline** - No internet required  
✅ **All Features** - Tasks, Projects, Badges  
✅ **Fast** - Instant responses  
✅ **Private** - Data stays on your phone  

---

## 🎯 Quick Test After Install

1. **Open App** - Tap TaskFlow icon
2. **Create Project** - Projects tab → + → "My Project"
3. **Create Task** - Today tab → + → "My Task" → Set date
4. **Complete Task** - Swipe right
5. **See Badge** - "🏆 Unlocked: The Starter!"
6. **Check Profile** - Profile tab → See badge in color

**All work? ✅ Perfect!**

---

## 📱 Recommended: Method 1 (Direct Install)

**Why?**
- ✅ Faster (no APK transfer)
- ✅ Easier (one command)
- ✅ Can hot reload during development
- ✅ See logs in real-time

**When to use Method 2?**
- ❌ Flutter not installed
- ❌ Want to share with others
- ❌ Installing on multiple phones
- ❌ No USB cable available

---

## 🎉 You're Done!

Your TaskFlow app is now on your phone!

**Enjoy your standalone task manager!** 📱✅

---

## 📞 Need Help?

### Common Issues

**"Device not found"**
- Enable USB debugging
- Allow USB debugging popup
- Try different USB cable

**"Build failed"**
- Run: `flutter doctor`
- Fix any issues shown
- Try: `flutter clean && flutter pub get`

**"Can't install APK"**
- Enable "Install from unknown sources"
- Uninstall old version first
- Restart phone

---

**Ready to install? Choose your method above!** 🚀
