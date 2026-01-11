# 🔧 GitHub Actions Troubleshooting Guide

## Common Issues & Solutions

### Issue 1: Workflow Not Appearing in Actions Tab

**Symptoms:**
- Can't see "Build Android APK" in Actions tab
- No workflows listed

**Solutions:**
1. Make sure `.github/workflows/build-apk.yml` is committed and pushed
2. Check if Actions are enabled in repository settings
3. Go to: `https://github.com/sukesh2730/taskflow_ai/settings/actions`
4. Enable "Allow all actions and reusable workflows"

### Issue 2: Workflow Fails to Run

**Symptoms:**
- Workflow appears but won't trigger
- "Run workflow" button doesn't work

**Solutions:**
1. Check repository permissions
2. Make sure you're logged into GitHub
3. Try triggering via push instead of manual trigger

### Issue 3: Build Fails

**Symptoms:**
- Workflow runs but fails during build
- Red X on workflow run

**Solutions:**
1. Check the logs in GitHub Actions tab
2. Look for specific error messages
3. Common errors:
   - Dependency issues → Update pubspec.yaml
   - Permission issues → Check repository settings
   - Timeout → Increase timeout in workflow

---

## 🚀 Quick Fix: Manual Trigger Test

### Step 1: Check Actions are Enabled
```
1. Go to: https://github.com/sukesh2730/taskflow_ai/settings/actions
2. Select "Allow all actions and reusable workflows"
3. Click "Save"
```

### Step 2: Trigger Workflow Manually
```
1. Go to: https://github.com/sukesh2730/taskflow_ai/actions
2. Click "Build Android APK" in left sidebar
3. Click "Run workflow" button (top right)
4. Select branch: main
5. Click green "Run workflow" button
```

### Step 3: Monitor Progress
```
1. Refresh the page
2. Click on the running workflow
3. Watch the build steps
4. Wait 5-10 minutes
```

### Step 4: Download APK
```
1. Once complete, scroll to bottom
2. Find "Artifacts" section
3. Click "taskflow-v1.1.0-release"
4. Download and extract ZIP
5. Install APK on phone
```

---

## 🔍 Diagnostic Commands

Run these to check your setup:

```bash
# Check if workflow file exists
git ls-files .github/workflows/

# Check if it's committed
git log --oneline --all -- .github/workflows/build-apk.yml

# Check remote repository
git remote -v

# Push any pending changes
git push origin main
```

---

## 🆘 Alternative: Simplified Workflow

If the current workflow isn't working, try this minimal version:
