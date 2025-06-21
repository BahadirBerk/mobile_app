# Brainy Note - Neumorphic Note Taking App

A beautiful, modern note-taking application built with Flutter featuring neumorphic design, 3D parallax backgrounds, and smooth animations.

## Features

### 🎨 Design
- **Neumorphic UI**: Soft, elegant design with emboss/deboss effects
- **3D Parallax Background**: Dynamic day/night mode with animated clouds, stars, sun, and moon
- **Smooth Animations**: Premium animations with elastic curves and fade effects
- **Theme Switching**: Seamless day/night mode transitions

### 📱 Screens
- **Splash Screen**: Animated logo and welcome screen
- **Notes List**: Beautiful note cards with neumorphic design
- **Note Editor**: Rich text editor with formatting tools
- **Responsive Design**: Works on all screen sizes

### ✨ Animations
- **Page Transitions**: Slide and fade animations between screens
- **Button Interactions**: Scale and shadow animations on press
- **Floating Action Button**: Pulsing animation with scale effects
- **List Animations**: Staggered entrance animations for notes
- **Theme Toggle**: Smooth rotation animation

## Technical Details

### Architecture
- **Provider Pattern**: State management with ChangeNotifier
- **Custom Painters**: 3D parallax background implementation
- **Animation Controllers**: Complex animation orchestration
- **Neumorphic Widgets**: Reusable design components

### Key Components
- `ThemeProvider`: Manages day/night mode and color schemes
- `ParallaxBackground`: 3D animated background with CustomPainter
- `NeumorphicButton`: Animated buttons with press effects
- `NeumorphicCard`: Interactive cards with shadow animations
- `NeumorphicInput`: Styled text inputs with focus animations

### Color Palette
- **Light Mode**: Soft pastels (#F4F2F8, #E0DFF7, #F2C94C)
- **Dark Mode**: Deep blues (#1A1A2E, #16213E, #FFD93D)
- **Accent Colors**: Purple gradients (#8B5CF6, #A78BFA)

## Getting Started

### Prerequisites
- Flutter SDK (>=2.17.0)
- Dart SDK
- Android Studio / VS Code

### Installation
1. Clone the repository
2. Navigate to the project directory
3. Install dependencies:
   ```bash
   flutter pub get
   ```
4. Run the app:
   ```bash
   flutter run
   ```

### Dependencies
- `provider`: State management
- `path_provider`: File system access
- `shared_preferences`: Local storage
- `intl`: Internationalization

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── theme/
│   └── theme_provider.dart   # Theme management
├── widgets/
│   ├── parallax_background.dart  # 3D background
│   └── neumorphic_widgets.dart   # UI components
├── screens/
│   ├── splash_screen.dart        # Welcome screen
│   ├── notes_list_screen.dart    # Main notes list
│   └── note_editor_screen.dart   # Note editor
└── models/
    └── note.dart                 # Data model
```

## Features to Add

### Planned Enhancements
- [ ] User authentication
- [ ] Cloud synchronization
- [ ] AI-powered note suggestions
- [ ] Rich text formatting
- [ ] Image attachments
- [ ] Voice notes
- [ ] Search functionality
- [ ] Categories and tags
- [ ] Export options
- [ ] Offline support

### Technical Improvements
- [ ] Unit tests
- [ ] Integration tests
- [ ] Performance optimization
- [ ] Accessibility features
- [ ] Internationalization
- [ ] Deep linking
- [ ] Push notifications

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- Flutter team for the amazing framework
- Neumorphism design inspiration
- Open source community for various packages

---

**Note**: This is a prototype/demo version focusing on UI/UX design. Production features like authentication, data persistence, and AI integration are planned for future releases.
