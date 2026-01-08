# 📱 Install TaskFlow on Phone - Step by Step

## 🎯 No Developer Mode Needed!

---

## 📋 What You Need

- ✅ Computer with Flutter installed
- ✅ Android phone
- ✅ USB cable OR email/cloud storage

---

## 🚀 Step-by-Step Instructions

### STEP 1: Build the App File (APK)

**On your computer:**

1. Open **Terminal** (Mac/Linux) or **Command Prompt** (Windows)

2. Type this command and press Enter:
   ```bash
   cd taskflow_mobile
   ```

3. Type this command and press Enter:
   ```bash
   flutter build apk --release
   ```

4. **Wait 2-5 minutes**. You'll see lots of text scrolling.

5. When done, you'll see:
   ```
   ✓ Built build/app/outputs/flutter-apk/app-release.apk
   ```

✅ **APK file is ready!**

---

### STEP 2: Find the APK File

**On your computer:**

1. Open **File Explorer** (Windows) or **Finder** (Mac)

2. Navigate to:
   ```
   taskflow_mobile/build/app/outputs/flutter-apk/
   ```

3. You'll see a file named: **app-release.apk**

4. This is your app! Now we need to get it to your phone.

---

### STEP 3: Transfer APK to Phone

**Choose the easiest method for you:**

#### 🔌 Method A: USB Cable

1. Connect your phone to computer with USB cable
2. On phone: Swipe down and tap USB notification
3. Select **"File Transfer"** or **"Transfer files"**
4. On computer: Open **File Explorer** (Windows) or **Android File Transfer** (Mac)
5. Find your phone (usually shows phone name)
6. Open **Download** or **Downloads** folder on phone
7. **Copy** `app-release.apk` from computer to phone's Downloads folder

#### 📧 Method B: Email (Easiest!)

1. Open your email on computer
2. Compose new email to yourself
3. Attach `app-release.apk` file
4. Send email
5. On phone: Open email app
6. Open the email you sent
7. Download the attachment

#### ☁️ Method C: Google Drive

1. Go to drive.google.com on computer
2. Click **"New"** → **"File upload"**
3. Select `app-release.apk`
4. Wait for upload
5. On phone: Open Google Drive app
6. Find the APK file
7. Tap to download

---

### STEP 4: Install on Phone

**On your phone:**

1. Open **File Manager** app (or "My Files" or "Files")
   - Can't find it? Look in app drawer or search "Files"

2. Tap **"Downloads"** folder

3. Find **app-release.apk** file

4. **Tap on it**

5. You might see a warning popup:

   **If you see "Install blocked" or "Can't install":**
   
   a. Tap **"Settings"** button in the popup
   
   b. You'll see a toggle switch
   
   c. Turn it **ON** (enable "Allow from this source")
   
   d. Press **Back** button
   
   e. Tap the APK file again

6. Now you'll see **"Install"** button

7. Tap **"Install"**

8. Wait 5-10 seconds

9. You'll see **"App installed"**

10. Tap **"Open"**

✅ **App is installed and running!**

---

### STEP 5: Test the App

**On your phone:**

1. You should see the TaskFlow app open

2. **Create a project:**
   - Tap **"Projects"** tab at bottom
   - Tap **+** button
   - Type "My First Project"
   - Tap **"Create"**
   - ✅ Project appears!

3. **Create a task:**
   - Tap **"Today"** tab at bottom
   - Tap **+** button
   - Type "My First Task"
   - Tap **"Create Task"**
   - ✅ Task appears!

4. **Complete the task:**
   - **Swipe the task to the right**
   - ✅ You'll see: "🏆 Unlocked: The Starter!"

5. **Check your badge:**
   - Tap **"Profile"** tab at bottom
   - ✅ You'll see "The Starter" badge in color!

**Everything works? 🎉 SUCCESS!**

---

## 🎯 Quick Reference

### Build Command:
```bash
cd taskflow_mobile
flutter build apk --release
```

### APK Location:
```
taskflow_mobile/build/app/outputs/flutter-apk/app-release.apk
```

### Transfer Methods:
1. USB cable → Copy to Downloads
2. Email → Send to yourself
3. Google Drive → Upload and download

### Install:
1. File Manager → Downloads
2. Tap APK
3. Enable "Allow from this source" if needed
4. Tap Install

---

## 🐛 Common Problems & Solutions

### Problem: "Can't find File Manager"

**Solution:**
- Look for apps named: "Files", "My Files", "File Manager"
- Or download "Files by Google" from Play Store

### Problem: "Install blocked"

**Solution:**
1. Tap "Settings" in the popup
2. Enable the toggle switch
3. Go back and try again

**OR:**

1. Go to phone **Settings**
2. Search for "Install unknown apps"
3. Find your File Manager app
4. Enable "Allow from this source"

### Problem: "App not installed"

**Solution:**
1. Uninstall any old version of TaskFlow
2. Restart your phone
3. Try installing again

### Problem: Build failed on computer

**Solution:**
```bash
flutter clean
flutter pub get
flutter build apk --release
```

### Problem: Can't transfer APK

**Solution:**
- Use email method (easiest)
- Or upload to Google Drive

---

## 📞 Need More Help?

### Can't build APK?
- Make sure Flutter is installed: `flutter doctor`
- Make sure you're in correct folder: `cd taskflow_mobile`

### Can't find APK file?
- Look in: `taskflow_mobile/build/app/outputs/flutter-apk/`
- File is named: `app-release.apk`

### Can't install on phone?
- Enable "Install unknown apps" in Settings
- Make sure you downloaded the full file (not just opened it)

---

## ✅ Success Checklist

- [ ] Built APK on computer
- [ ] Found APK file
- [ ] Transferred to phone
- [ ] Installed on phone
- [ ] App opens
- [ ] Created a project
- [ ] Created a task
- [ ] Completed a task
- [ ] Saw badge notification
- [ ] Checked profile

**All checked? 🎉 You're done!**

---

## 🎉 Congratulations!

Your TaskFlow app is now installed and working!

**Features:**
- ✅ Works 100% offline
- ✅ No server needed
- ✅ No internet needed
- ✅ All data on your phone
- ✅ Fast and private

**Enjoy your task manager!** 📱✅

---

**Start with STEP 1 above and follow each step!** 🚀
