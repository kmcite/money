# Money - Expense Tracker App

A modern, cross-platform expense tracking application built with Flutter. Track your daily expenses, monitor spending patterns, and manage your budget with an intuitive and beautiful interface.

## Features

### 📊 Dashboard
- **Total Expense Overview**: View your complete expense summary at a glance
- **Quick Stats**: Track monthly and daily spending with visual indicators
- **Recent Expenses**: See your last 5 expenses with easy navigation to view all
- **Real-time Updates**: All data updates instantly across the app

### 💰 Expense Management
- **Add Expenses**: Quickly add new expenses with notes and amounts
- **Search & Filter**: Find expenses instantly with powerful search functionality
- **Sort Options**: Organize expenses by date, amount, or notes
- **Edit & Delete**: Full CRUD operations for expense management

### 🎨 User Interface
- **Dark Mode**: Toggle between light and dark themes
- **Material Design**: Modern, clean interface following Material Design 3
- **Responsive Layout**: Optimized for all screen sizes and orientations
- **Smooth Navigation**: Bottom navigation bar with intuitive page switching

### 💾 Data Storage
- **Local Database**: Uses ObjectBox for fast, reliable local data storage
- **Offline First**: Works completely offline without requiring internet connection
- **Data Persistence**: All your data is safely stored on your device

## Tech Stack

- **Framework**: Flutter 3.11.0+
- **State Management**: Signals for reactive state management
- **Database**: ObjectBox for high-performance local storage
- **Navigation**: Custom navigation system with Material routes
- **UI Components**: Material Design 3 with custom theming
- **Platforms**: Android, iOS, Windows, Linux, macOS, Web

## Installation

### Prerequisites
- Flutter SDK 3.11.0 or higher
- Dart SDK compatible with Flutter version
- Platform-specific development tools (Android Studio, Xcode, etc.)

### Setup Instructions

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd money
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate required files**
   ```bash
   flutter packages pub run build_runner build
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

## Project Structure

```
lib/
├── dashboard/           # Dashboard screen and components
│   ├── application_shell.dart
│   └── dashboard.dart
├── expenses/           # Expense management screens
│   ├── add_expense_dialog.dart
│   ├── delete_expense_dialog.dart
│   ├── edit_expense_dialog.dart
│   ├── expense_model.dart
│   ├── expense_tile.dart
│   ├── expenses_screen.dart
│   └── show_expense_dialog.dart
├── navigation/         # Navigation utilities
│   └── navigator.dart
├── db/                # Database configuration
│   ├── hive.dart
│   └── objects.dart
├── settings/          # App settings
│   └── dark.dart
└── main.dart          # App entry point
```

## Key Dependencies

- `objectbox`: High-performance database
- `signals`: Reactive state management
- `flutter_native_splash`: Splash screen configuration
- `flutter_launcher_icons`: App icon generation
- `navigation_builder`: Custom navigation utilities

## Usage

### Adding Expenses
1. Navigate to the Expenses tab
2. Tap the + button to open the Add Expense dialog
3. Enter a note and amount
4. Tap "Add" to save the expense

### Viewing Dashboard
1. The Dashboard tab shows your total expenses
2. View monthly and daily statistics
3. See recent expenses with quick access to details

### Managing Expenses
1. Use the search bar to find specific expenses
2. Sort expenses by date, amount, or notes using the sort menu
3. Tap on any expense to view or edit details

## Development

### Running Tests
```bash
flutter test
```

### Building for Production

**Android:**
```bash
flutter build apk --release
```

**iOS:**
```bash
flutter build ios --release
```

**Web:**
```bash
flutter build web
```

**Windows:**
```bash
flutter build windows
```

### Code Generation
The project uses code generation for ObjectBox models. Run this command after making changes to model files:
```bash
flutter packages pub run build_runner build --delete-conflicting-outputs
```

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Screenshots

*Add screenshots of the app in action here*

## Roadmap

- [ ] Expense categories and tags
- [ ] Budget tracking and limits
- [ ] Export functionality (CSV, PDF)
- [ ] Data backup and sync
- [ ] Charts and analytics
- [ ] Recurring expenses
- [ ] Multi-currency support

## Support

For support and questions, please open an issue on the GitHub repository.