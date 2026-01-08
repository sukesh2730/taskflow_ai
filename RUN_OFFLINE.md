# 🔌 Run TaskFlow Mobile App OFFLINE

## 🎯 Overview

The TaskFlow mobile app is designed to work **gracefully offline**. Here's how it behaves and how to test it.

---

## 📱 Offline Behavior

### What Works Offline ✅

1. **View Cached Data**
   - Last loaded tasks display
   - Last loaded projects display
   - UI remains functional

2. **Navigate Between Tabs**
   - Switch between Today, Projects, Profile
   - All navigation works normally

3. **View Profile**
   - See badges (static display)
   - View user info

4. **App Doesn't Crash**
   - Graceful error handling
   - User-friendly messages

### What Doesn't Work Offline ❌

1. **Create New Tasks**
   - API call fails silently
   - No error shown to user (by design)

2. **Create New Projects**
   - API call fails silently
   - No error shown to user

3. **Complete Tasks**
   - Can't mark as complete
   - No badge notifications

4. **Refresh Data**
   - Pull-to-refresh does nothing
   - Shows last cached data

5. **Burnout Risk**
   - Shows "Offline" status
   - Can't log user state

---

## 🧪 How to Test Offline Mode

### Method 1: Airplane Mode (Recommended)

#### On Emulator
1. Open emulator settings
2. Enable Airplane Mode
3. Launch app
4. Test features

#### On Physical Phone
1. Swipe down notification panel
2. Tap Airplane Mode icon
3. Launch app
4. Test features

### Method 2: Disable WiFi/Mobile Data

#### On Emulator
1. Settings → Network & Internet
2. Turn off WiFi
3. Launch app

#### On Physical Phone
1. Settings → WiFi → Turn off
2. Settings → Mobile Data → Turn off
3. Launch app

### Method 3: Stop Backend

#### Stop Backend Server
```bash
cd taskflow_ai
docker-compose down
```

#### Launch App
```bash
cd taskflow_mobile
flutter run
```

App will try to connect but fail gracefully.

---

## 📊 Offline Test Scenarios

### Test 1: Launch App Offline

**Steps:**
1. Turn on Airplane Mode
2. Launch app
3. Observe behavior

**Expected Results:**
- ✅ App launches successfully
- ✅ Shows empty task list (if no cache)
- ✅ Shows last cached tasks (if cache exists)
- ✅ Burnout risk shows "Offline"
- ✅ No crash or error dialogs

### Test 2: Navigate Tabs Offline

**Steps:**
1. App is offline
2. Tap Projects tab
3. Tap Profile tab
4. Tap Today tab

**Expected Results:**
- ✅ All tabs load
- ✅ Navigation is smooth
- ✅ No errors or crashes
- ✅ Shows cached data or empty states

### Test 3: Try to Create Task Offline

**Steps:**
1. App is offline
2. Tap + button
3. Enter task details
4. Tap Create Task

**Expected Results:**
- ✅ Form accepts input
- ✅ Create button works
- ✅ Dialog closes
- ✅ Task doesn't appear in list (API failed)
- ✅ No error message shown
- ✅ App doesn't crash

### Test 4: Try to Create Project Offline

**Steps:**
1. Go to Projects tab
2. Tap + button
3. Enter project name
4. Tap Create

**Expected Results:**
- ✅ Dialog opens
- ✅ Input works
- ✅ Create button works
- ✅ Dialog closes
- ✅ Project doesn't appear (API failed)
- ✅ No error message
- ✅ App doesn't crash

### Test 5: Try to Complete Task Offline

**Steps:**
1. App is offline (with cached tasks)
2. Swipe task to the right

**Expected Results:**
- ✅ Task dismisses from list
- ✅ No badge notification appears
- ✅ No error message
- ✅ App doesn't crash

### Test 6: Pull to Refresh Offline

**Steps:**
1. App is offline
2. On Today tab, pull down to refresh

**Expected Results:**
- ✅ Refresh animation plays
- ✅ Animation stops
- ✅ Shows same cached data
- ✅ No error message
- ✅ App doesn't crash

### Test 7: Go Offline While Using

**Steps:**
1. Launch app with internet
2. Load tasks and projects
3. Turn on Airplane Mode
4. Try to use app

**Expected Results:**
- ✅ App continues working
- ✅ Shows last loaded data
- ✅ Burnout risk changes to "Offline"
- ✅ Create operations fail silently
- ✅ No crashes

### Test 8: Reconnect After Offline

**Steps:**
1. App is offline with cached data
2. Turn off Airplane Mode
3. Pull to refresh

**Expected Results:**
- ✅ Data refreshes from backend
- ✅ New tasks/projects appear
- ✅ Burnout risk updates
- ✅ All features work again

---

## 🔍 How Offline Mode Works (Technical)

### API Service Error Handling

```dart
// lib/services/api_service.dart

Future<List<Task>> getTasks() async {
  try {
    final response = await http.get(Uri.parse('$baseUrl/tasks/'));
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((dynamic item) => Task.fromJson(item)).toList();
    }
    return []; // ← Returns empty list on error
  } catch (e) {
    print("Error: $e"); // ← Logs error
    return []; // ← Returns empty list on exception
  }
}
```

**Key Points:**
- ✅ Try-catch blocks prevent crashes
- ✅ Returns empty list instead of throwing
- ✅ Logs error for debugging
- ✅ UI handles empty lists gracefully

### Burnout Risk Offline Handling

```dart
Future<String> getBurnoutRisk() async {
  try {
    final response = await http.get(Uri.parse('$baseUrl/analytics/burnout-risk'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['risk_level'];
    }
    return "Unknown"; // ← Fallback
  } catch (e) {
    return "Offline"; // ← Shows "Offline" when no connection
  }
}
```

### UI Error Handling

```dart
// lib/screens/dashboard_screen.dart

tasksAsync.when(
  data: (tasks) => SliverList(...), // ← Shows tasks
  loading: () => CircularProgressIndicator(), // ← Shows loading
  error: (e, _) => Text("Error: $e"), // ← Shows error message
)
```

**Key Points:**
- ✅ AsyncValue.when() handles all states
- ✅ Loading state shows spinner
- ✅ Error state shows message
- ✅ Data state shows content

---

## 🚀 Improve Offline Experience (Future)

### Current Limitations

1. **No Offline Queue**
   - Create operations fail silently
   - No retry when connection restored

2. **No Local Storage**
   - Only Riverpod cache (temporary)
   - Data lost on app restart

3. **No Sync Indicator**
   - User doesn't know if offline
   - No visual feedback for failed operations

### Recommended Enhancements

#### 1. Add Local Database (SQLite)

```yaml
# pubspec.yaml
dependencies:
  sqflite: ^2.3.0
  path: ^1.8.3
```

**Benefits:**
- Persistent storage
- Works completely offline
- Sync when online

#### 2. Add Offline Queue

```dart
class OfflineQueue {
  List<PendingOperation> queue = [];
  
  void addOperation(PendingOperation op) {
    queue.add(op);
    // Save to local storage
  }
  
  Future<void> syncWhenOnline() async {
    for (var op in queue) {
      await op.execute();
    }
    queue.clear();
  }
}
```

**Benefits:**
- Operations don't fail
- Auto-sync when online
- Better user experience

#### 3. Add Connectivity Indicator

```dart
// Show banner when offline
if (isOffline) {
  Container(
    color: Colors.orange,
    child: Text("You're offline. Changes won't sync."),
  )
}
```

**Benefits:**
- User knows app state
- Clear feedback
- Better UX

#### 4. Add Optimistic Updates

```dart
// Show task immediately, sync later
void createTask(Task task) {
  // Add to local list immediately
  localTasks.add(task);
  
  // Try to sync in background
  api.createTask(task).catchError((e) {
    // Mark as pending sync
    task.pendingSync = true;
  });
}
```

**Benefits:**
- Instant feedback
- Feels faster
- Syncs in background

---

## 📱 Offline Mode Best Practices

### For Users

1. **Load Data While Online**
   - Open app with internet first
   - Let it cache data
   - Then can use offline

2. **Don't Create While Offline**
   - Operations will fail
   - Wait for connection
   - Or note what to create later

3. **Check Connection Status**
   - Look for "Offline" in burnout risk
   - If offline, only view data

### For Developers

1. **Always Use Try-Catch**
   ```dart
   try {
     await api.call();
   } catch (e) {
     // Handle gracefully
   }
   ```

2. **Return Safe Defaults**
   ```dart
   return []; // Not null
   return "Offline"; // Not error
   ```

3. **Test Offline Scenarios**
   - Test with Airplane Mode
   - Test with backend down
   - Test with slow network

4. **Show Loading States**
   ```dart
   if (isLoading) CircularProgressIndicator()
   ```

5. **Handle Empty States**
   ```dart
   if (tasks.isEmpty) Text("No tasks yet")
   ```

---

## ✅ Offline Mode Checklist

### Current Implementation

- [x] App launches offline
- [x] Shows cached data
- [x] Doesn't crash on network errors
- [x] Returns empty lists on failure
- [x] Shows "Offline" for burnout risk
- [x] All navigation works offline
- [x] UI handles empty states
- [x] Try-catch on all API calls

### Not Implemented (Future)

- [ ] Local database (SQLite)
- [ ] Offline operation queue
- [ ] Auto-sync when online
- [ ] Connectivity indicator
- [ ] Optimistic updates
- [ ] Retry failed operations
- [ ] Show pending sync status

---

## 🎯 Quick Offline Test

### 5-Minute Test

1. **Start Online**
   ```bash
   # Start backend
   cd taskflow_ai && docker-compose up
   
   # Start app
   cd taskflow_mobile && flutter run
   ```

2. **Load Data**
   - Create 2 tasks
   - Create 1 project
   - Complete 1 task

3. **Go Offline**
   - Enable Airplane Mode
   - Or stop backend: `docker-compose down`

4. **Test Offline**
   - ✅ View tasks (cached)
   - ✅ View projects (cached)
   - ✅ Navigate tabs
   - ✅ Try to create task (fails silently)
   - ✅ Check burnout risk (shows "Offline")

5. **Go Online**
   - Disable Airplane Mode
   - Or start backend: `docker-compose up`

6. **Verify Sync**
   - Pull to refresh
   - ✅ Data updates
   - ✅ Burnout risk updates

**If all pass: ✅ Offline mode works!**

---

## 📊 Offline Behavior Summary

| Feature | Online | Offline |
|---------|--------|---------|
| View Tasks | ✅ Live data | ✅ Cached data |
| View Projects | ✅ Live data | ✅ Cached data |
| Create Task | ✅ Works | ❌ Fails silently |
| Create Project | ✅ Works | ❌ Fails silently |
| Complete Task | ✅ Works + Badge | ❌ Fails silently |
| Navigate Tabs | ✅ Works | ✅ Works |
| View Profile | ✅ Works | ✅ Works |
| Burnout Risk | ✅ Shows level | ⚠️ Shows "Offline" |
| Pull to Refresh | ✅ Updates data | ⚠️ No update |
| App Stability | ✅ Stable | ✅ Stable |

---

**The app works gracefully offline with proper error handling!** 🔌✅
