# NoteApp - Quick Start Guide

## 🚀 Running the App

### For Android
```bash
flutter run -d android
```

### For iOS
```bash
flutter run -d ios
```

### For Web
```bash
flutter run -d chrome
```

### For Windows
```bash
flutter run -d windows
```

## 📱 Test Credentials

Since the app uses a mock API (in-memory storage), you can create your own account during registration.

### First Run
1. **Splash Screen** appears for 3 seconds
2. **Login Screen** loads automatically (first-time users can register)
3. **Registration** creates a new account
4. **Home Screen** shows empty initially (no notes)

### Test Flow
1. **Register** with any email/password combination
2. **Click + button** to create a note
3. **Add a title** and description
4. **View notes** on the home screen
5. **Tap a note** to see full details
6. **Edit/Delete** using the options menu
7. **Logout** using the logout button

## 🎨 App Screens

### 1. Splash Screen
- Auto-navigates after 3 seconds
- Beautiful animations
- Shows only on first launch (tracked via SharedPreferences)

### 2. Login Screen
- Email validation
- Password validation (min 6 characters)
- Link to registration screen
- Error messages for failed login attempts

### 3. Registration Screen
- Name, email, password fields
- Password confirmation
- Form validation
- Link to login screen

### 4. Home Screen
- List of all user notes
- Empty state message when no notes
- Floating action button (+) to create note
- Logout button
- Each note card shows:
  - Title
  - Description preview
  - Created date
  - Edit/Delete options

### 5. Add Note Screen
- Title input field
- Description input field (multiline)
- Form validation
- Loading indicator during save

### 6. Note Detail Screen
- Full note view
- Edit button (edit icon)
- Delete button (delete icon)
- Formatted date display

### 7. Edit Note Screen
- Pre-filled form with current note data
- Same validation as add note
- Update button

## 🔧 Architecture Overview

```
┌─────────────────────────────────────────┐
│        Presentation Layer (UI)          │
│  Screens, Widgets, GetX Obx updates    │
└──────────────┬──────────────────────────┘
               │
┌──────────────▼──────────────────────────┐
│      Controllers Layer (GetX)           │
│  AuthController, NoteController,        │
│  SplashController                       │
└──────────────┬──────────────────────────┘
               │
┌──────────────▼──────────────────────────┐
│        Data Layer                       │
│  ApiService, LocalStorageService       │
└──────────────┬──────────────────────────┘
               │
┌──────────────▼──────────────────────────┐
│   External Resources & Databases       │
│  Mock API (In-Memory), SharedPref      │
└─────────────────────────────────────────┘
```

## 📦 Project Dependencies

- **get**: ^4.6.6 - State management
- **go_router**: ^14.0.0 - Navigation
- **shared_preferences**: ^2.2.2 - Local storage
- **http**: ^1.1.0 - HTTP requests (for future API integration)
- **intl**: ^0.19.0 - Date formatting

## 🔌 Connecting to Real Backend

### Step 1: Update API Service
Edit `lib/data/services/api_service.dart`:

```dart
static const String baseUrl = 'https://your-api.com';

// Replace mock implementations with actual HTTP calls
static Future<UserModel?> login({
  required String email,
  required String password,
}) async {
  final response = await http.post(
    Uri.parse('$baseUrl/auth/login'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'email': email, 'password': password}),
  );
  
  if (response.statusCode == 200) {
    return UserModel.fromJson(jsonDecode(response.body));
  }
  throw Exception('Login failed');
}
```

### Step 2: Update Models
Ensure your backend API returns data in this format:

**User Model:**
```json
{
  "id": "user_id",
  "name": "User Name",
  "email": "user@example.com",
  "createdAt": "2024-05-12T10:30:00Z"
}
```

**Note Model:**
```json
{
  "id": "note_id",
  "userId": "user_id",
  "title": "Note Title",
  "description": "Note Description",
  "createdAt": "2024-05-12T10:30:00Z",
  "updatedAt": "2024-05-12T11:00:00Z"
}
```

## 🎯 Key Features Implementation

### GetX State Management
```dart
// Define observable
final count = 0.obs;
final notes = <NoteModel>[].obs;
final isLoading = false.obs;

// Update state
count.value = 10;
notes.add(note);
isLoading.value = true;

// Reactive UI
Obx(() => Text('Count: ${count.value}'))
```

### Go_Router Navigation
```dart
// Push new route
Get.toNamed('/add-note');

// Navigate with arguments
Get.toNamed('/note-detail', arguments: note);

// Replace all routes
Get.offAllNamed('/login');

// Pop back
Get.back();
```

### SharedPreferences
```dart
// Save data
await LocalStorageService.saveUser(user);

// Get data
final user = await LocalStorageService.getUser();

// Clear data
await LocalStorageService.clearUser();
```

## 🐛 Troubleshooting

### App crashes on startup
- Run `flutter clean`
- Run `flutter pub get`
- Clear app cache and try again

### Splash screen not showing
- Check if `LocalStorageService.setSplashShown()` is called
- Verify the 3-second delay in splash_screen.dart

### Notes not displaying
- Ensure you're logged in
- Check that `AuthController.currentUser` is not null
- Verify `NoteController.fetchNotes()` is called with valid userId

### Navigation issues
- Check if controller is initialized with `Get.put()` in main.dart
- Verify route paths match exactly in routes.dart

## 📝 Code Examples

### Creating a Note
```dart
final noteController = Get.find<NoteController>();
await noteController.addNote(
  userId: userId,
  title: 'My Note',
  description: 'Note content',
);
```

### Listening to State Changes
```dart
Obx(() => 
  noteController.isLoading.value
    ? CircularProgressIndicator()
    : ListView.builder(...)
)
```

### Conditional Navigation
```dart
if (authController.isLoggedIn.value) {
  Get.offAllNamed('/home');
} else {
  Get.offAllNamed('/login');
}
```

## 📱 Device Compatibility

- **Android**: API 21+ (Android 5.0+)
- **iOS**: 11.0+
- **Web**: Chrome, Firefox, Safari
- **Windows**: Windows 10+
- **macOS**: 10.11+

## 💡 Best Practices

1. **Always use GetX for state management** - Don't mix setState
2. **Initialize controllers in main.dart** - Use `Get.put()`
3. **Use Obx for reactive UI** - Wrap widgets that depend on state
4. **Proper resource disposal** - Dispose controllers and animations
5. **Error handling** - Always wrap API calls in try-catch
6. **Input validation** - Validate all user inputs
7. **Loading states** - Show loading indicators during async operations

## 🚀 Performance Tips

1. Use `ListView.builder()` for large lists (already implemented)
2. Lazy load controllers with `Get.lazyPut()`
3. Use `GetX` instead of `GetBuilder` for better performance
4. Implement pagination for large datasets
5. Cache frequently used data

## 📞 Support

For issues or questions:
1. Check the comprehensive README_APP.md
2. Review the example code in existing screens
3. Check Flutter documentation: https://flutter.dev
4. Check GetX documentation: https://github.com/jonataslaw/getx

---

**Happy coding! 🎉**
