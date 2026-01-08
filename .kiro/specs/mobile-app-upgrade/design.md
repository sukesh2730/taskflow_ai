# Design Document

## Overview

The TaskFlow Mobile App upgrade integrates three major backend features: Projects, Gamification, and Due Dates. The design follows Flutter's Material Design 3 principles and uses Riverpod for state management. The architecture maintains separation of concerns with distinct layers for models, services, providers, and UI screens.

The upgrade adds two new screens (Projects and Profile), enhances the existing task creation flow, and implements real-time badge notifications. All features communicate with the existing FastAPI backend through RESTful endpoints.

## Architecture

### High-Level Architecture

```
┌─────────────────────────────────────────────────────────┐
│                     Presentation Layer                   │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐  │
│  │   Today      │  │   Projects   │  │   Profile    │  │
│  │   Screen     │  │   Screen     │  │   Screen     │  │
│  └──────────────┘  └──────────────┘  └──────────────┘  │
│           │                 │                 │          │
└───────────┼─────────────────┼─────────────────┼──────────┘
            │                 │                 │
┌───────────┼─────────────────┼─────────────────┼──────────┐
│           ▼                 ▼                 ▼          │
│                    Provider Layer (Riverpod)             │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐  │
│  │ taskList     │  │ projectList  │  │ burnoutRisk  │  │
│  │ Provider     │  │ Provider     │  │ Provider     │  │
│  └──────────────┘  └──────────────┘  └──────────────┘  │
│           │                 │                 │          │
└───────────┼─────────────────┼─────────────────┼──────────┘
            │                 │                 │
┌───────────┼─────────────────┼─────────────────┼──────────┐
│           ▼                 ▼                 ▼          │
│                      Service Layer                       │
│                   ┌──────────────┐                       │
│                   │ ApiService   │                       │
│                   └──────────────┘                       │
│                          │                               │
└──────────────────────────┼───────────────────────────────┘
                           │
┌──────────────────────────┼───────────────────────────────┐
│                          ▼                               │
│                  FastAPI Backend                         │
│  /api/v1/tasks/  │  /api/v1/projects/  │  /analytics/   │
└─────────────────────────────────────────────────────────┘
```

### Navigation Structure

The app uses a bottom NavigationBar with three destinations:
- **Today Tab**: Displays all tasks with burnout risk indicator
- **Projects Tab**: Lists all projects with creation capability
- **Profile Tab**: Shows achievements and badges

## Components and Interfaces

### 1. Data Models

#### Project Model (`lib/models/project.dart`)

```dart
class Project {
  final int id;
  final String name;
  final String? description;
  
  Project({
    required this.id,
    required this.name,
    this.description
  });
  
  factory Project.fromJson(Map<String, dynamic> json);
}
```

**Design Rationale**: Simple immutable model matching backend schema. Description is optional to support minimal project creation flow.

#### Enhanced Task Model (`lib/models/task.dart`)

```dart
class Task {
  final int id;
  final String title;
  final String category;
  final int priority;
  final int energyReq;
  final int estimatedMinutes;
  final bool isCompleted;
  final int? projectId;        // NEW
  final DateTime? dueDate;     // NEW
  
  factory Task.fromJson(Map<String, dynamic> json);
}
```

**Design Rationale**: Added nullable `projectId` and `dueDate` fields to support new backend capabilities while maintaining backward compatibility with existing tasks.

### 2. API Service Layer

#### Enhanced ApiService (`lib/services/api_service.dart`)

**New Methods**:

```dart
// Projects
Future<List<Project>> getProjects()
Future<void> createProject(String name)

// Enhanced Task Completion
Future<List<String>> completeTask(int id)  // Returns badges
```

**Design Rationale**: 
- `completeTask` now returns `List<String>` of unlocked badge names from backend response
- Project methods follow same pattern as task methods for consistency
- All methods use try-catch with empty list fallback for offline resilience

**Error Handling Strategy**:
- Network errors return empty lists rather than throwing exceptions
- UI layer handles empty states gracefully
- Console logging for debugging without exposing errors to users

### 3. State Management (Riverpod Providers)

#### Provider Architecture (`lib/providers/app_providers.dart`)

```dart
final apiServiceProvider = Provider((ref) => ApiService());

final taskListProvider = FutureProvider<List<Task>>((ref) async {
  final api = ref.watch(apiServiceProvider);
  return api.getTasks();
});

final projectListProvider = FutureProvider<List<Project>>((ref) async {
  final api = ref.watch(apiServiceProvider);
  return api.getProjects();
});

final burnoutRiskProvider = FutureProvider<String>((ref) async {
  final api = ref.watch(apiServiceProvider);
  return api.getBurnoutRisk();
});
```

**Design Rationale**:
- FutureProvider for async data fetching with built-in loading/error states
- Providers are refreshable via `ref.refresh()` for manual updates
- Single ApiService instance shared across all providers

### 4. UI Screens

#### Projects Screen (`lib/screens/projects_screen.dart`)

**Features**:
- ListView of all projects with folder icons
- FloatingActionButton for project creation
- Dialog-based project creation flow
- Automatic refresh after creation

**UI Components**:
- Card-based list items with leading folder icon
- Trailing arrow icon for future navigation to project tasks
- AlertDialog for project name input

**Design Rationale**: Simple CRUD interface following Material Design patterns. Future enhancement will add tap navigation to filtered task view.

#### Profile Screen (`lib/screens/profile_screen.dart`)

**Features**:
- User avatar placeholder
- Badge grid display (3 columns)
- Visual distinction between locked/unlocked badges

**Badge Display Logic**:
```dart
class _Badge extends StatelessWidget {
  final String icon;
  final String name;
  final bool locked;
  
  // Locked badges: grey background, grey icon
  // Unlocked badges: amber background, full color icon
}
```

**Design Rationale**: 
- Static badge display for MVP (future: fetch from backend)
- Grid layout maximizes screen space
- Clear visual feedback for achievement status

#### Enhanced Dashboard Screen (`lib/screens/dashboard_screen.dart`)

**New Features**:
- Bottom NavigationBar with 3 destinations
- StatefulWidget to manage selected index
- Page switching without rebuilding entire tree

**Task Card Enhancements**:
- Dismissible gesture for task completion
- Badge unlock SnackBar notification
- Due date display in subtitle
- Priority indicator (red icon for priority ≥ 4)

**Badge Notification Flow**:
```dart
onDismissed: (_) async {
  final badges = await ref.read(apiServiceProvider).completeTask(task.id);
  if (badges.isNotEmpty && context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("🏆 Unlocked: ${badges.join(', ')}!"),
        backgroundColor: Colors.amber,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
```

**Design Rationale**: 
- Immediate visual feedback for gamification
- Context.mounted check prevents memory leaks
- Floating SnackBar doesn't block UI interaction

#### Enhanced Add Task Screen (`lib/screens/add_task_screen.dart`)

**New Features**:
- Date picker for due date selection
- Project selector dropdown (future enhancement)
- Visual date display with formatting

**Form Structure**:
```dart
- TextFormField (task title)
- ListTile (date picker trigger)
- Slider (priority 1-5)
- FilledButton (submit)
```

**Date Picker Integration**:
```dart
final date = await showDatePicker(
  context: context,
  initialDate: DateTime.now(),
  firstDate: DateTime.now(),
  lastDate: DateTime(2030),
);
```

**Design Rationale**:
- ListTile provides clear tap target for date selection
- Date formatting uses `intl` package for localization
- Priority slider shows "Urgent" label at level 5 with red color
- Form validation ensures required fields are filled

## Data Models

### Task Data Flow

**Creation Flow**:
```
User Input → Form Validation → JSON Payload → POST /api/v1/tasks/ → Refresh Provider
```

**Completion Flow**:
```
Swipe Gesture → PUT /api/v1/tasks/{id}/complete → Parse badges_unlocked → Show SnackBar
```

**JSON Payload Structure**:
```json
{
  "title": "Submit Report",
  "priority": 5,
  "due_date": "2026-01-05T00:00:00.000Z",
  "energy_req": 3,
  "estimated_minutes": 30,
  "project_id": null
}
```

### Project Data Flow

**Creation Flow**:
```
Dialog Input → Validation → POST /api/v1/projects/ → Refresh projectListProvider
```

**JSON Payload Structure**:
```json
{
  "name": "Office Work"
}
```

## Error Handling

### Network Error Strategy

**API Service Level**:
- All HTTP requests wrapped in try-catch blocks
- Return empty lists/default values on failure
- Console logging for debugging

**UI Level**:
- AsyncValue.when() handles loading/error/data states
- Error state displays user-friendly message
- Empty states show appropriate placeholders

**Example Error Handling**:
```dart
tasksAsync.when(
  data: (tasks) => ListView(...),
  loading: () => CircularProgressIndicator(),
  error: (err, _) => Text("Error: $err"),
)
```

### Offline Mode Behavior

- **Tasks**: Display last cached data (Riverpod auto-caching)
- **Burnout Risk**: Display "Offline" status
- **Project Creation**: Fails silently (future: queue for sync)
- **Task Completion**: No badge notification if offline

## Testing Strategy

### Unit Testing

**Models**:
- Test JSON parsing with valid data
- Test JSON parsing with missing optional fields
- Test null handling for projectId and dueDate

**API Service**:
- Mock HTTP responses for success cases
- Mock network errors for failure cases
- Verify correct endpoint URLs
- Verify request payload structure

### Widget Testing

**Projects Screen**:
- Verify project list renders correctly
- Test add button opens dialog
- Test dialog submission creates project
- Verify refresh after creation

**Profile Screen**:
- Verify badge grid layout
- Test locked/unlocked badge styling
- Verify badge count and positioning

**Dashboard Screen**:
- Test navigation bar switching
- Verify task card rendering
- Test swipe-to-complete gesture
- Verify SnackBar appears with badges
- Test due date display formatting

**Add Task Screen**:
- Test form validation
- Verify date picker opens
- Test date selection updates UI
- Verify priority slider behavior
- Test form submission with all fields

### Integration Testing

**End-to-End Flows**:
1. Create project → Verify in project list
2. Create task with due date → Verify in task list
3. Complete task → Verify badge notification
4. Navigate between tabs → Verify state persistence

**Backend Integration**:
- Test with real backend running
- Verify API contract matches expectations
- Test error responses from backend
- Verify badge unlock logic

### Manual Testing Checklist

**Projects Feature**:
- [ ] Create project with valid name
- [ ] Create project with empty name (should fail validation)
- [ ] View project list after creation
- [ ] Verify project persists after app restart

**Gamification Feature**:
- [ ] Complete first task → Verify "The Starter" badge
- [ ] Complete 10 tasks → Verify "Productivity Master" badge
- [ ] Verify badge notification appears
- [ ] Check Profile tab shows unlocked badges

**Due Dates Feature**:
- [ ] Create task without due date
- [ ] Create task with due date
- [ ] Verify due date displays in task list
- [ ] Verify date picker shows correct date range

**Navigation**:
- [ ] Switch between all three tabs
- [ ] Verify selected tab highlights correctly
- [ ] Verify each tab loads correct content

**Offline Behavior**:
- [ ] Disconnect network
- [ ] Verify app doesn't crash
- [ ] Verify "Offline" status shows
- [ ] Reconnect and verify data loads

## Performance Considerations

### Optimization Strategies

**Provider Caching**:
- Riverpod automatically caches FutureProvider results
- Manual refresh only when data changes
- Prevents unnecessary API calls

**List Rendering**:
- ListView.builder for efficient rendering
- SliverList for scroll performance
- Card widgets kept lightweight

**Image Assets**:
- No heavy images in badge display
- Emoji icons for zero network overhead

### Memory Management

**Context Safety**:
- Always check `context.mounted` before showing dialogs/snackbars
- Dispose controllers in StatefulWidget cleanup
- Avoid memory leaks in async callbacks

**State Management**:
- Providers automatically disposed when no longer watched
- No manual subscription management needed
- Riverpod handles lifecycle automatically

## Security Considerations

**API Communication**:
- All requests use HTTPS in production (currently HTTP for local dev)
- No sensitive data stored locally
- No authentication tokens in MVP (future enhancement)

**Input Validation**:
- Form validation prevents empty submissions
- Date picker restricts to valid date range
- Backend performs additional validation

## Future Enhancements

**Phase 2 Features**:
1. Project-filtered task view (tap project to see tasks)
2. Real-time badge data from backend API
3. Productivity score calculation and display
4. Task assignment to projects during creation
5. Edit/delete project functionality
6. Task search and filtering
7. Offline queue for failed requests
8. Push notifications for due dates
9. Dark mode theme refinement
10. Accessibility improvements (screen reader support)

**Technical Debt**:
- Add proper error handling with retry logic
- Implement proper authentication
- Add integration tests
- Set up CI/CD pipeline
- Add analytics tracking
- Implement proper logging framework
