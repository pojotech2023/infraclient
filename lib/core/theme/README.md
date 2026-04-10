# Theme System

This directory contains the theme management system for the Flutter app using BLoC pattern.

## Structure

```
lib/core/theme/
├── bloc/
│   ├── theme_bloc.dart          # Main theme BLoC
│   ├── theme_event.dart         # Theme events
│   └── theme_state.dart         # Theme state
├── colorscheme/
│   ├── colorscheme.dart         # Base color scheme class
│   ├── blue_colorscheme.dart    # Blue theme
│   ├── default_colorscheme.dart # Default theme
│   ├── green_colorscheme.dart   # Green theme
│   ├── orange_colorscheme.dart  # Orange theme
│   ├── pink_colorscheme.dart    # Pink theme
│   └── yellow_colorscheme.dart  # Yellow theme
├── app_theme/
│   └── app_theme.dart           # Theme definitions and mappings
├── appearance/
│   ├── base_appearance.dart     # Abstract appearance class
│   └── app_appearance.dart      # Concrete appearance implementation
├── widgets/
│   └── theme_provider.dart      # Theme provider widget
└── utils/
    └── theme_utils.dart         # Theme utility functions
```

## Features

### Theme Modes
- **Light**: Light theme mode
- **Dark**: Dark theme mode  
- **System**: Follows system theme setting

### Color Schemes
- **Default**: Gray-based neutral theme
- **Blue**: Blue primary color theme
- **Green**: Green primary color theme
- **Orange**: Orange primary color theme
- **Pink**: Pink primary color theme
- **Yellow**: Yellow primary color theme

## Usage

### 1. Theme Provider
Wrap your app with the `ThemeProvider`:

```dart
ThemeProvider(
  child: YourApp(),
)
```

### 2. Using Theme BLoC
Access the theme state and dispatch events:

```dart
// Get theme state
BlocBuilder<ThemeBloc, ThemeState>(
  builder: (context, state) {
    return Text('Current theme: ${state.colorSchemeName}');
  },
)

// Change theme mode
context.read<ThemeBloc>().add(ThemeModeChanged(ThemeMode.dark));

// Change color scheme
context.read<ThemeBloc>().add(ColorSchemeChanged('Blue'));
```

### 3. Theme Page
The theme page provides a UI for users to select theme mode and color scheme:

```dart
ThemePage()
```

## Color Scheme Structure

Each color scheme includes:
- `primary`: Primary color
- `onPrimary`: Color for content on primary
- `primaryContainer`: Primary container color
- `secondary`: Secondary color
- `onSecondary`: Color for content on secondary
- `background`: Background color
- `onBackground`: Color for content on background
- `surface`: Surface color
- `onSurface`: Color for content on surface
- `error`: Error color
- `onError`: Color for content on error
- `scaffoldBackgroundColor`: Scaffold background color

## Persistence

Theme settings are automatically persisted using Hive:
- Theme mode preference
- Selected color scheme

## Adding New Themes

1. Create a new color scheme file in `colorscheme/`
2. Add the theme to `BuiltInThemes` class
3. Add the theme to `AppTheme.themeMap`
4. Update `ThemeUtils` if needed

## Example

```dart
// Create a new purple theme
class PurpleColorScheme extends AppColorScheme {
  const PurpleColorScheme.light() : super(/* ... */);
  const PurpleColorScheme.dark() : super(/* ... */);
}

// Add to BuiltInThemes
static const String purpleTheme = 'Purple';

// Add to themeMap
static final Map<String, AppTheme> themeMap = {
  // ... existing themes
  BuiltInThemes.purpleTheme: purpleLight,
};
```
