# NoteApp - Flutter Note Taking Application

A modern Flutter note-taking application built with clean architecture, GetX state management, and Go_Router navigation.

## Features

✅ **Splash Screen** - Beautiful animated splash screen shown only on first app launch  
✅ **Authentication** - Login and registration with email and password  
✅ **Note Management** - Create, read, update, and delete notes  
✅ **Responsive UI** - Modern, clean, and intuitive user interface  
✅ **State Management** - GetX for efficient state management  
✅ **Local Storage** - SharedPreferences for local data persistence  
✅ **Online Database** - Simple mock API service (can be replaced with real API)  
✅ **Navigation** - Go_Router for type-safe routing  

## Project Structure

```
lib/
├── config/
│   └── routes.dart              # Go_Router configuration and routes
├── controllers/
│   ├── splash_controller.dart   # Splash screen logic
│   ├── auth_controller.dart     # Authentication logic (GetX)
│   └── note_controller.dart     # Note management logic (GetX)
├── data/
│   ├── models/
│   │   ├── user_model.dart      # User data model
│   │   └── note_model.dart      # Note data model
│   └── services/
│       ├── api_service.dart     # API calls (mock backend)
│       └── local_storage_service.dart  # SharedPreferences
├── presentation/
│   ├── pages/
│   │   ├── splash_screen.dart
│   │   ├── login_screen.dart
│   │   ├── register_screen.dart
│   │   ├── home_screen.dart
│   │   ├── add_note_screen.dart
│   │   ├── note_detail_screen.dart
│   │   └── edit_note_screen.dart
│   └── widgets/
├── utils/
│   ├── app_theme.dart           # Theme, colors, spacing
│   └── app_constants.dart       # Constants and validations
└── main.dart
```

## Clean Architecture

The project follows clean architecture principles:

- **Presentation Layer**: UI screens and widgets
- **Domain Layer**: Models and entities
- **Data Layer**: API service and local storage
- **Controllers**: Business logic using GetX

## Tech Stack

- **Framework**: Flutter 3.11.1+
- **State Management**: GetX 4.6.6
- **Navigation**: Go_Router 14.0.0
- **Local Storage**: SharedPreferences 2.2.2
- **HTTP Requests**: http 1.1.0
- **Date Formatting**: intl 0.19.0

## Getting Started

### Prerequisites
- Flutter SDK 3.11.1 or higher
- Dart SDK included with Flutter

### Installation

1. Clone the repository
2. Navigate to the project directory:
   ```bash
   cd note_app
   ```

3. Get dependencies:
   ```bash
   flutter pub get
   ```

4. Run the app:
   ```bash
   flutter run
   ```

## Features Explained

### 1. Splash Screen
- Shows only on first app launch
- Beautiful animations using `AnimationController`
- Auto-navigates to login/home after 3 seconds
- Uses `SharedPreferences` to track if app has been launched before

### 2. Authentication
- **Login**: Sign in with existing credentials
- **Registration**: Create new account with name, email, and password
- Passwords are validated for minimum 6 characters
- Email validation using regex pattern
- Error handling with user-friendly messages

### 3. Home Screen
- Displays all user notes in a list
- Shows note title, description preview, and creation date
- Tap on a note to view full details
- Floating action button to create new note
- Logout button in app bar
- Empty state message when no notes exist

### 4. Add Note
- Simple form with title and description fields
- Form validation
- Loading state during save
- Auto-navigate back after successful save

### 5. Note Details
- Full note view with complete description
- Edit and delete options
- Formatted date display
- Confirmation dialog before delete

### 6. Edit Note
- Pre-filled form with current note data
- Same validation as add note
- Updates note with new data

## API Service

The app uses a mock API service that stores data in memory. To connect to a real backend:

1. Replace the `ApiService` class methods with actual HTTP calls
2. Update the base URL:
   ```dart
   static const String baseUrl = 'https://your-api.com';
   ```

3. Implement HTTP methods using the `http` package

Example for connecting to a real API:
```dart
static Future<UserModel?> login({
  required String email,
  required String password,
}) async {
  final response = await http.post(
    Uri.parse('$baseUrl/api/auth/login'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'email': email,
      'password': password,
    }),
  );
  
  if (response.statusCode == 200) {
    return UserModel.fromJson(jsonDecode(response.body));
  }
  throw Exception('Login failed');
}
```

## State Management with GetX

### Controllers

**AuthController**
- Manages user authentication state
- Handles login, registration, and logout
- Tracks loading and error states

**NoteController**
- Manages notes list and operations
- Handles create, read, update, delete operations
- Observes notes list for reactive updates

**SplashController**
- Manages splash screen state
- Tracks if app has been launched before

### Usage Example
```dart
final noteController = Get.find<NoteController>();

// Fetch notes
noteController.fetchNotes(userId);

// Add note
await noteController.addNote(
  userId: userId,
  title: 'My Note',
  description: 'Note description',
);

// Watch for changes
Obx(() => Text(noteController.isLoading.value ? 'Loading...' : 'Ready'))
```

## Navigation

Using Go_Router for type-safe routing:

```dart
// Navigate to home
Get.toNamed('/home');

// Navigate with arguments
Get.toNamed('/note-detail', arguments: note);

// Replace route
Get.offAllNamed('/login');
```

## Customization

### Theme Colors
Edit `lib/utils/app_theme.dart`:
```dart
class AppColors {
  static const Color primary = Color(0xFF5E35B1);    // Purple
  static const Color secondary = Color(0xFF00BCD4);  // Cyan
  static const Color accent = Color(0xFFFFB300);     // Orange
}
```

### Spacing
```dart
class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
}
```

## Error Handling

The app includes comprehensive error handling:
- Input validation on all forms
- Network error handling
- User-friendly error messages via snackbars
- Loading states to prevent duplicate submissions

## Performance Optimization

- Lazy loading of controllers
- Obx for reactive updates only when needed
- Efficient list building with ListView.builder
- Proper disposal of resources (TextEditingController, AnimationController)

## Contributing

Feel free to fork and contribute to this project!

## License

This project is open source and available under the MIT License.

---

**Created with ❤️ using Flutter and GetX**
