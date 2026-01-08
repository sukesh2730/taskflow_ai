# TaskFlow Mobile App - Final Testing Guide

## 🎯 Pre-Test Setup

### 1. Start Backend Services
```bash
cd taskflow_ai
docker-compose up -d
```

Verify backend is running:
```bash
curl http://localhost:8000/docs
```

### 2. Start Mobile App
```bash
cd taskflow_mobile
flutter run
```

Or for hot reload:
```bash
flutter run --hot
```

## 🧪 Complete Test Scenarios

### Test 1: Projects Management ✅

**Objective**: Verify project creation and display

**Steps**:
1. Launch app
2. Tap "Projects" tab (folder icon)
3. Tap the "+" FloatingActionButton
4. Enter project name: "Office Work"
5. Tap "Create"
6. Verify project appears in list with folder icon

**Expected Results**:
- ✅ Dialog opens with text field
- ✅ Project appears in list immediately
- ✅ Project persists after app restart
- ✅ Empty name shows validation error

**Test Variations**:
- Try empty name → Should prevent creation
- Create multiple projects → All should display
- Test with special characters → Should work

---

### Test 2: Task Creation with Due Date ✅

**Objective**: Verify enhanced task creation with due dates

**Steps**:
1. Go to "Today" tab
2. Tap "+" FloatingActionButton
3. Enter task: "Submit Report"
4. Tap "Set Due Date"
5. Select tomorrow's date
6. Set priority to 5 (Urgent)
7. Tap "Create Task"

**Expected Results**:
- ✅ Date picker opens with calendar
- ✅ Selected date displays as "Due: Jan 05, 2026"
- ✅ Priority slider shows "Urgent" in red
- ✅ Task appears in list with due date
- ✅ Red priority icon shows (priority ≥ 4)

**Test Variations**:
- Create task without due date → Shows "No Deadline"
- Try to select past date → Should be disabled
- Set priority to 3 → No red icon
- Set priority to 5 → Red icon appears

---

### Test 3: Badge Unlock Notification 🏆

**Objective**: Verify gamification system works

**Steps**:
1. Go to "Today" tab
2. Create a new task (any title)
3. Swipe the task to the right
4. Watch for notification

**Expected Results**:
- ✅ Task dismisses from list
- ✅ Golden SnackBar appears at bottom
- ✅ Message: "🏆 Unlocked: The Starter!"
- ✅ SnackBar has amber background
- ✅ SnackBar floats above bottom nav

**Test Variations**:
- Complete 1st task → "The Starter" badge
- Complete 10th task → "Productivity Master" badge
- Complete task offline → No notification (graceful)

---

### Test 4: Profile & Achievements 🎖️

**Objective**: Verify badge display in profile

**Steps**:
1. Complete at least 1 task (see Test 3)
2. Tap "Profile" tab (trophy icon)
3. Scroll to "🏆 Badges Unlocked" section
4. Observe badge grid

**Expected Results**:
- ✅ User avatar displays at top
- ✅ "Productivity Master" title shows
- ✅ Badge grid shows 4 badges in 3 columns
- ✅ "The Starter" (🌱) - colored/unlocked
- ✅ "Productivity Master" (🚀) - colored if 10+ tasks
- ✅ "Streak Keeper" (🔥) - grey/locked
- ✅ "Zen Master" (🧘) - grey/locked

**Visual Verification**:
- Unlocked badges: Amber background, full color emoji
- Locked badges: Grey background, grey emoji

---

### Test 5: Navigation Flow 🧭

**Objective**: Verify bottom navigation works correctly

**Steps**:
1. Launch app (starts on "Today" tab)
2. Tap "Projects" tab
3. Tap "Profile" tab
4. Tap "Today" tab again

**Expected Results**:
- ✅ Each tab loads correct screen
- ✅ Active tab highlights in navigation bar
- ✅ No lag or flickering
- ✅ State persists when switching back
- ✅ FAB appears on Today and Projects tabs only

**Test Variations**:
- Rapidly switch tabs → Should be smooth
- Create task, switch tabs, return → Task still there

---

### Test 6: Priority System 🚨

**Objective**: Verify priority indicators work

**Steps**:
1. Create 3 tasks with different priorities:
   - Task A: Priority 2
   - Task B: Priority 4
   - Task C: Priority 5
2. Observe task list

**Expected Results**:
- ✅ All tasks show priority number in CircleAvatar
- ✅ Task A (priority 2): No red icon
- ✅ Task B (priority 4): Red priority icon
- ✅ Task C (priority 5): Red priority icon
- ✅ During creation, slider shows "Urgent" at 5
- ✅ Slider color changes to red at priority 5

---

### Test 7: Burnout Risk Indicator 🏥

**Objective**: Verify analytics integration

**Steps**:
1. Go to "Today" tab
2. Observe card at top of screen
3. Tap brain icon (🧠) in app bar
4. Adjust energy level and mood
5. Tap "Update AI Model"

**Expected Results**:
- ✅ Burnout risk card displays at top
- ✅ Shows risk level from backend
- ✅ Bottom sheet opens with sliders
- ✅ Energy slider: 1-10
- ✅ Mood chips: Neutral, Focused, Stressed, Creative, Tired
- ✅ Data sends to backend successfully

**Test Variations**:
- Backend offline → Shows "Offline" status
- Backend online → Shows actual risk level

---

### Test 8: Error Handling & Edge Cases 🛡️

**Objective**: Verify app handles errors gracefully

**Test 8.1: Offline Mode**
1. Turn off WiFi/mobile data
2. Launch app
3. Try to create project
4. Try to create task
5. Try to complete task

**Expected Results**:
- ✅ App doesn't crash
- ✅ Shows last cached data
- ✅ Burnout risk shows "Offline"
- ✅ Create operations fail silently
- ✅ No badge notification when offline

**Test 8.2: Empty States**
1. Fresh install (no data)
2. Check each tab

**Expected Results**:
- ✅ Today tab: Empty list (no crash)
- ✅ Projects tab: Empty list (no crash)
- ✅ Profile tab: All badges locked

**Test 8.3: Form Validation**
1. Try to create task with empty title
2. Try to create project with empty name

**Expected Results**:
- ✅ Shows "Required" error message
- ✅ Prevents submission
- ✅ Red error text appears

---

### Test 9: Data Persistence 💾

**Objective**: Verify data persists correctly

**Steps**:
1. Create 2 projects
2. Create 3 tasks with due dates
3. Complete 1 task
4. Close app completely
5. Reopen app

**Expected Results**:
- ✅ Projects still visible
- ✅ Tasks still visible with due dates
- ✅ Completed task is gone (or marked complete)
- ✅ Badge status persists

---

### Test 10: UI/UX Polish 🎨

**Objective**: Verify visual quality and responsiveness

**Checklist**:
- ✅ Material Design 3 components used
- ✅ Consistent color scheme (purple primary)
- ✅ Google Fonts (Inter) applied
- ✅ Smooth animations and transitions
- ✅ No UI jank or stuttering
- ✅ Proper spacing and padding
- ✅ Icons are clear and meaningful
- ✅ Text is readable
- ✅ Touch targets are adequate (44x44 minimum)
- ✅ Dark mode works (if system is in dark mode)

**Visual Inspection**:
- Cards have proper elevation
- Colors are consistent
- Icons align properly
- Text doesn't overflow
- Loading indicators appear when needed

---

## 🐛 Known Issues & Limitations

### By Design (MVP)
1. **Static Badges**: Profile shows hardcoded badges (not from API)
2. **No Project Filtering**: Can't filter tasks by project
3. **No Edit/Delete**: Can't modify existing items
4. **No Authentication**: Single user assumed
5. **No Offline Queue**: Failed operations don't retry

### Future Enhancements
- Add project-filtered task view
- Implement edit/delete functionality
- Add search and filtering
- Implement offline sync queue
- Add push notifications for due dates
- Add task assignment to projects during creation

---

## 🚀 Performance Testing

### Load Testing
1. Create 50+ tasks
2. Create 20+ projects
3. Scroll through lists
4. Switch between tabs

**Expected**:
- ✅ Smooth scrolling (60 FPS)
- ✅ No lag when switching tabs
- ✅ Lists render efficiently
- ✅ No memory leaks

### Memory Testing
1. Use for 10+ minutes
2. Switch tabs frequently
3. Create/complete many tasks

**Expected**:
- ✅ Memory usage stays stable
- ✅ No crashes
- ✅ No slowdown over time

---

## 📊 Test Results Template

```
Date: ___________
Tester: ___________
Device: ___________
OS Version: ___________

Test 1: Projects Management          [ ] PASS [ ] FAIL
Test 2: Task Creation with Due Date  [ ] PASS [ ] FAIL
Test 3: Badge Unlock Notification    [ ] PASS [ ] FAIL
Test 4: Profile & Achievements       [ ] PASS [ ] FAIL
Test 5: Navigation Flow              [ ] PASS [ ] FAIL
Test 6: Priority System              [ ] PASS [ ] FAIL
Test 7: Burnout Risk Indicator       [ ] PASS [ ] FAIL
Test 8: Error Handling               [ ] PASS [ ] FAIL
Test 9: Data Persistence             [ ] PASS [ ] FAIL
Test 10: UI/UX Polish                [ ] PASS [ ] FAIL

Overall Status: [ ] APPROVED [ ] NEEDS WORK

Notes:
_________________________________
_________________________________
_________________________________
```

---

## 🎬 Quick Demo Script

**For stakeholder demo (5 minutes)**:

1. **Show Today Tab** (30s)
   - "Here's our task list with burnout risk indicator"
   - Point out priority indicators and due dates

2. **Create Task** (45s)
   - Tap +, enter "Prepare Presentation"
   - Select due date for next week
   - Set priority to 5 (Urgent)
   - Show red indicator appears

3. **Complete Task** (30s)
   - Swipe task to complete
   - Show badge unlock notification
   - "This is our gamification system"

4. **Show Projects** (45s)
   - Switch to Projects tab
   - Create "Marketing Campaign" project
   - Show it appears instantly

5. **Show Profile** (45s)
   - Switch to Profile tab
   - Show unlocked badges
   - Explain locked badges

6. **Show AI Integration** (45s)
   - Tap brain icon
   - Adjust energy and mood
   - "This feeds our AI recommendation engine"

**Total**: ~5 minutes

---

## ✅ Final Checklist

Before declaring PRODUCTION READY:

### Code Quality
- [x] No compilation errors
- [x] No linting warnings
- [x] All imports resolved
- [x] Null safety enabled
- [x] No deprecated APIs used

### Features
- [x] All 10 requirements implemented
- [x] All UI screens complete
- [x] All API integrations working
- [x] Error handling in place
- [x] Form validation working

### Testing
- [ ] Manual testing completed
- [ ] All test scenarios passed
- [ ] Edge cases verified
- [ ] Performance acceptable
- [ ] No critical bugs found

### Documentation
- [x] Requirements documented
- [x] Design documented
- [x] Implementation plan complete
- [x] Test guide created
- [x] Known limitations documented

### Deployment
- [ ] Backend URL configured
- [ ] API endpoints verified
- [ ] Dependencies up to date
- [ ] App icons added
- [ ] Splash screen configured

---

## 🎉 Success Criteria

The app is READY TO SHIP when:

✅ All 10 test scenarios pass  
✅ No crashes during 10-minute usage  
✅ All features work as specified  
✅ UI is polished and responsive  
✅ Backend integration verified  
✅ Error handling is graceful  
✅ Performance is acceptable  

**Current Status**: ✅ READY FOR TESTING

---

## 📞 Support

If you encounter issues:

1. Check backend is running: `docker-compose ps`
2. Check backend logs: `docker-compose logs -f`
3. Check Flutter logs: Look at console output
4. Verify API URL in `api_service.dart` matches your setup
5. Try `flutter clean && flutter pub get`

**Common Issues**:
- "Connection refused" → Backend not running
- "Offline" status → Check baseUrl in api_service.dart
- Blank screens → Check console for errors
- Hot reload issues → Try full restart

---

**Ready to test? Start with Test 1 and work through all scenarios! 🚀**
