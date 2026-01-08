# Implementation Plan

- [x] 1. Update data models to support new backend features

  - Create Project model class with JSON parsing
  - Update Task model to include projectId and dueDate fields
  - Ensure proper null handling for optional fields
  - _Requirements: 1.1, 3.4, 8.1, 8.2, 8.3, 8.4_

- [x] 2. Enhance API service layer with new endpoints

  - [ ] 2.1 Implement getProjects() method to fetch project list from backend
    - Add GET request to /api/v1/projects/ endpoint
    - Parse JSON response into Project model list
    - Implement error handling with empty list fallback
    - _Requirements: 1.1, 9.1, 10.1_


  - [ ] 2.2 Implement createProject() method for project creation
    - Add POST request to /api/v1/projects/ endpoint
    - Send project name in JSON payload
    - Handle network errors gracefully

    - _Requirements: 1.3, 10.1_

  - [ ] 2.3 Update completeTask() to return unlocked badges
    - Modify PUT request to /api/v1/tasks/{id}/complete
    - Parse badges_unlocked array from response body
    - Return List<String> of badge names

    - Handle cases where badges_unlocked is null or empty
    - _Requirements: 2.5, 6.1, 6.2_

  - [ ] 2.4 Update createTask() to support due dates and project assignment
    - Modify POST payload to include due_date field

    - Modify POST payload to include project_id field
    - Serialize DateTime to ISO8601 string format
    - _Requirements: 3.4, 4.3, 8.5_

- [ ] 3. Update Riverpod providers for new data sources
  - Add projectListProvider using FutureProvider

  - Ensure providers use apiServiceProvider dependency
  - Verify taskListProvider fetches all tasks (not just recommended)
  - _Requirements: 1.1, 9.2, 9.3_

- [ ] 4. Create Projects screen with CRUD functionality
  - [ ] 4.1 Build ProjectsScreen widget with list view
    - Create ConsumerWidget structure

    - Implement ListView.builder for project list
    - Add Card widgets with folder icon and project name
    - Display loading indicator while fetching data
    - Display error message on fetch failure
    - _Requirements: 1.1, 1.4, 9.4_

  - [ ] 4.2 Implement project creation dialog
    - Add FloatingActionButton to trigger dialog
    - Create AlertDialog with TextField for project name

    - Implement Cancel and Create buttons
    - Call createProject() on submission
    - Refresh projectListProvider after creation
    - Close dialog on successful creation
    - _Requirements: 1.2, 1.3, 9.2_


- [ ] 5. Create Profile screen with gamification display
  - [ ] 5.1 Build ProfileScreen with user info section
    - Create StatelessWidget structure
    - Add CircleAvatar for user profile placeholder
    - Display user title/name
    - Add section header for badges
    - _Requirements: 2.1_


  - [ ] 5.2 Implement badge grid display
    - Create GridView with 3 columns
    - Build _Badge widget component
    - Implement locked state styling (grey background, grey icon)
    - Implement unlocked state styling (amber background, full color)
    - Display badge icon and name
    - _Requirements: 2.2, 2.3, 2.4_


- [ ] 6. Enhance Dashboard screen with navigation and badge notifications
  - [ ] 6.1 Implement bottom navigation bar
    - Convert DashboardScreen to ConsumerStatefulWidget
    - Add NavigationBar widget with 3 destinations
    - Create destinations for Today, Projects, Profile
    - Implement onDestinationSelected callback
    - Manage selectedIndex state
    - Switch between page widgets based on selection

    - _Requirements: 5.1, 5.2, 5.3, 5.4, 5.5_

  - [ ] 6.2 Update task card to display due dates and priority
    - Modify subtitle to show due date when available
    - Format due date using DateTime.toString()
    - Display "No Deadline" when dueDate is null
    - Add priority high icon for priority >= 4
    - Style priority icon in red color
    - Display priority number in CircleAvatar
    - _Requirements: 3.5, 7.1, 7.2_


  - [ ] 6.3 Implement badge unlock notification on task completion
    - Update Dismissible onDismissed callback
    - Call completeTask() and await badge list
    - Check if badges list is not empty
    - Verify context.mounted before showing SnackBar
    - Display SnackBar with badge names joined by comma
    - Style SnackBar with amber background and trophy emoji
    - Use floating behavior for SnackBar

    - _Requirements: 2.5, 6.1, 6.2, 6.3, 6.4, 6.5_

- [ ] 7. Enhance Add Task screen with due date picker
  - [ ] 7.1 Add due date selection UI
    - Add selectedDate state variable
    - Create ListTile for date picker trigger
    - Display "Set Due Date" when no date selected
    - Display formatted date when date is selected

    - Use intl package DateFormat for formatting
    - Add calendar icon to ListTile
    - Style ListTile with surfaceVariant color
    - _Requirements: 3.1, 3.2, 3.3_

  - [x] 7.2 Implement date picker dialog

    - Add onTap callback to ListTile
    - Call showDatePicker with proper parameters
    - Set initialDate to DateTime.now()
    - Set firstDate to DateTime.now()
    - Set lastDate to DateTime(2030)
    - Update selectedDate state on date selection
    - _Requirements: 3.2, 3.3_


  - [ ] 7.3 Update priority slider with visual feedback
    - Modify slider to show "Urgent" label at priority 5
    - Change slider color to red when priority is 5
    - Keep blue color for priority < 5
    - Ensure slider updates priority state
    - _Requirements: 7.3, 7.4_


  - [ ] 7.4 Update form submission to include new fields
    - Add due_date to taskData map
    - Convert selectedDate to ISO8601 string
    - Include project_id field (null for now)

    - Ensure energy_req and estimated_minutes have defaults
    - Call createTask() with updated payload
    - _Requirements: 3.4, 7.5, 8.5_

- [x] 8. Implement data refresh mechanisms


  - Add RefreshIndicator to task list (already exists, verify)
  - Implement refresh on project creation
  - Implement refresh on task creation return
  - Verify providers refresh correctly
  - _Requirements: 9.1, 9.2, 9.3_

- [ ] 9. Add error handling and validation
  - [ ] 9.1 Implement form validation in Add Task screen
    - Add validator to title TextFormField
    - Check for empty string and return error message
    - Validate form before submission
    - _Requirements: 10.5_

  - [ ] 9.2 Add error displays in UI
    - Verify AsyncValue.when() error cases display messages
    - Ensure error messages are user-friendly
    - Add console logging for debugging
    - _Requirements: 9.5, 10.2, 10.3_

  - [ ] 9.3 Implement offline handling
    - Verify API service returns empty lists on network errors
    - Ensure burnout risk shows "Offline" on failure
    - Test app behavior with no network connection
    - _Requirements: 10.1, 10.4_

- [ ]* 10. Write integration tests for new features
  - [ ]* 10.1 Test project creation flow
    - Mock API service responses
    - Test dialog opens and closes correctly
    - Verify project list updates after creation
    - Test error handling for failed creation
    - _Requirements: 1.1, 1.2, 1.3_

  - [ ]* 10.2 Test badge notification flow
    - Mock completeTask response with badges
    - Verify SnackBar appears with correct content
    - Test case with no badges unlocked
    - Verify context.mounted check prevents errors
    - _Requirements: 2.5, 6.1, 6.2, 6.3_

  - [ ]* 10.3 Test due date selection and display
    - Test date picker opens and closes
    - Verify selected date updates UI
    - Test task creation with due date
    - Verify due date displays in task list
    - _Requirements: 3.1, 3.2, 3.3, 3.4, 3.5_

  - [ ]* 10.4 Test navigation between tabs
    - Verify all three tabs are accessible
    - Test state persistence when switching tabs
    - Verify correct screen displays for each tab
    - _Requirements: 5.1, 5.2, 5.3, 5.4, 5.5_

- [ ]* 11. Perform manual testing and bug fixes
  - [ ]* 11.1 Test complete user flows
    - Create project and verify persistence
    - Create task with due date and project
    - Complete task and verify badge unlock
    - Navigate through all tabs
    - Test offline behavior
    - _Requirements: All_

  - [ ]* 11.2 Fix any discovered issues
    - Address UI rendering bugs
    - Fix API integration issues
    - Resolve state management problems
    - Improve error messages
    - _Requirements: All_
