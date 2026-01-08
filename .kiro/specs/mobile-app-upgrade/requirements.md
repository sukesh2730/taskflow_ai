# Requirements Document

## Introduction

This specification defines the requirements for upgrading the TaskFlow Mobile App to integrate with the enhanced backend features including Projects, Gamification, and Due Dates. The mobile app currently provides basic task management functionality but lacks integration with the new backend capabilities that enable project organization, achievement tracking, and deadline management.

## Glossary

- **Mobile App**: The Flutter-based TaskFlow mobile application
- **Backend API**: The FastAPI-based TaskFlow backend service
- **Project**: A collection of related tasks that can be organized together
- **Badge**: A gamification achievement unlocked when users complete specific milestones
- **Productivity Score**: A calculated metric representing user task completion performance
- **Due Date**: A deadline timestamp associated with a task
- **API Service**: The Dart service layer that communicates with the Backend API
- **Provider**: A Riverpod state management component that manages data flow
- **Navigation Bar**: The bottom navigation component for switching between app sections

## Requirements

### Requirement 1

**User Story:** As a mobile app user, I want to create and view projects, so that I can organize my tasks into logical groups

#### Acceptance Criteria

1. WHEN the user navigates to the Projects tab, THE Mobile App SHALL display a list of all projects retrieved from the Backend API
2. WHEN the user taps the add button on the Projects screen, THE Mobile App SHALL display a dialog for creating a new project
3. WHEN the user submits a valid project name, THE Mobile App SHALL send a POST request to the Backend API and refresh the project list
4. WHERE a project exists, THE Mobile App SHALL display the project name with a folder icon in the list

### Requirement 2

**User Story:** As a mobile app user, I want to view my productivity score and unlocked badges, so that I can track my achievements and stay motivated

#### Acceptance Criteria

1. WHEN the user navigates to the Profile tab, THE Mobile App SHALL display the user's profile information and achievement section
2. THE Mobile App SHALL display all available badges in a grid layout with locked and unlocked states
3. WHERE a badge is unlocked, THE Mobile App SHALL display the badge with full color and icon
4. WHERE a badge is locked, THE Mobile App SHALL display the badge in grayscale with reduced opacity
5. WHEN the user completes a task that unlocks a badge, THE Mobile App SHALL display a celebration notification with the badge name

### Requirement 3

**User Story:** As a mobile app user, I want to set due dates when creating tasks, so that I can manage deadlines effectively

#### Acceptance Criteria

1. WHEN the user opens the task creation screen, THE Mobile App SHALL display a due date selector option
2. WHEN the user taps the due date selector, THE Mobile App SHALL display a date picker dialog
3. WHEN the user selects a date, THE Mobile App SHALL display the selected date in the task creation form
4. WHEN the user submits the task, THE Mobile App SHALL include the due date in the API request payload
5. WHERE a task has a due date, THE Mobile App SHALL display the due date in the task list item subtitle

### Requirement 4

**User Story:** As a mobile app user, I want to assign tasks to projects when creating them, so that I can organize my work effectively

#### Acceptance Criteria

1. WHEN the user opens the task creation screen, THE Mobile App SHALL display a project selector option
2. WHEN the user taps the project selector, THE Mobile App SHALL display a list of available projects from the Backend API
3. WHEN the user selects a project, THE Mobile App SHALL include the project ID in the task creation payload
4. WHERE a task is assigned to a project, THE Mobile App SHALL display the project name in the task details

### Requirement 5

**User Story:** As a mobile app user, I want to navigate between different sections of the app, so that I can access all features efficiently

#### Acceptance Criteria

1. THE Mobile App SHALL display a Navigation Bar at the bottom of the screen with three destinations
2. THE Mobile App SHALL provide navigation destinations for Today, Projects, and Profile sections
3. WHEN the user taps a navigation destination, THE Mobile App SHALL switch to the corresponding screen
4. THE Mobile App SHALL highlight the currently active navigation destination
5. THE Mobile App SHALL maintain the navigation state when switching between screens

### Requirement 6

**User Story:** As a mobile app user, I want the app to handle badge unlocking notifications, so that I receive immediate feedback on my achievements

#### Acceptance Criteria

1. WHEN the user completes a task by swiping, THE Mobile App SHALL send a PUT request to the Backend API complete endpoint
2. WHEN the Backend API returns unlocked badges in the response, THE Mobile App SHALL parse the badges_unlocked array
3. WHERE badges are unlocked, THE Mobile App SHALL display a SnackBar notification with the badge names
4. THE Mobile App SHALL display the badge notification with an amber background and trophy emoji
5. THE Mobile App SHALL use floating behavior for the SnackBar notification

### Requirement 7

**User Story:** As a mobile app user, I want the app to display task priority visually, so that I can quickly identify urgent tasks

#### Acceptance Criteria

1. WHERE a task has priority level 4 or higher, THE Mobile App SHALL display a priority high icon in red color
2. THE Mobile App SHALL display the priority number in a circular avatar on each task card
3. WHEN creating a task, THE Mobile App SHALL provide a slider for selecting priority from 1 to 5
4. WHERE priority is set to 5, THE Mobile App SHALL display the label as "Urgent" with red color
5. THE Mobile App SHALL persist the priority value when submitting the task to the Backend API

### Requirement 8

**User Story:** As a mobile app user, I want the app to work with the updated task model, so that I can access all new task properties

#### Acceptance Criteria

1. THE Mobile App SHALL define a Task model with fields for id, title, category, priority, energyReq, estimatedMinutes, isCompleted, projectId, and dueDate
2. THE Mobile App SHALL parse the project_id field from the Backend API JSON response
3. THE Mobile App SHALL parse the due_date field from the Backend API JSON response as a DateTime object
4. WHERE due_date is null in the API response, THE Mobile App SHALL set the dueDate field to null
5. THE Mobile App SHALL serialize task data to JSON format when sending POST requests to the Backend API

### Requirement 9

**User Story:** As a mobile app user, I want the app to refresh data from the backend, so that I always see the latest information

#### Acceptance Criteria

1. WHEN the user pulls down on the task list, THE Mobile App SHALL trigger a refresh of the task data
2. WHEN the user creates a new project, THE Mobile App SHALL refresh the project list provider
3. WHEN the user returns from the task creation screen, THE Mobile App SHALL refresh the task list provider
4. THE Mobile App SHALL display a loading indicator while fetching data from the Backend API
5. WHERE the Backend API request fails, THE Mobile App SHALL display an error message to the user

### Requirement 10

**User Story:** As a mobile app user, I want the app to have proper error handling, so that I can understand when something goes wrong

#### Acceptance Criteria

1. WHERE an API request fails, THE Mobile App SHALL catch the exception and return an empty list or default value
2. THE Mobile App SHALL display error messages in the UI when data fetching fails
3. THE Mobile App SHALL log errors to the console for debugging purposes
4. WHERE the Backend API is offline, THE Mobile App SHALL display "Offline" status for burnout risk
5. THE Mobile App SHALL validate form inputs before submitting to the Backend API
