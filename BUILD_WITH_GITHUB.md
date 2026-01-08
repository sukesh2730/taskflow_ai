# Build APK Using GitHub Actions (Cloud Build)

Since local Android SDK setup is complex, I've created a GitHub Actions workflow that will build your APK in the cloud for free!

## Steps:

### 1. Push to GitHub

If you haven't already, push your code to GitHub:

```bash
git init
git add .
git commit -m "Initial commit"
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO.git
git push -u origin main
```

### 2. Enable GitHub Actions

1. Go to your repository on GitHub
2. Click on the "Actions" tab
3. GitHub will automatically detect the workflow file

### 3. Trigger the Build

**Option A: Automatic (on push)**
- Just push any changes to the `taskflow_mobile` folder
- The build will start automatically

**Option B: Manual**
1. Go to Actions tab
2. Click "Build Android APK" workflow
3. Click "Run workflow" button
4. Click the green "Run workflow" button

### 4. Download Your APK

1. Wait 5-10 minutes for the build to complete
2. Click on the completed workflow run
3. Scroll down to "Artifacts"
4. Download "taskflow-release-apk"
5. Extract the ZIP file to get your APK

## Benefits:

- ✅ No local Android SDK installation needed
- ✅ Builds in 5-10 minutes
- ✅ Free for public repositories
- ✅ Always uses latest build tools
- ✅ Can build from any computer

## Alternative: Local Build

If you still want to build locally, you'll need to:
1. Install Android Studio (full version)
2. Install Android SDK through Android Studio
3. Accept all licenses
4. Then run `flutter build apk --release` in the taskflow_mobile folder

The GitHub Actions approach is much simpler!
