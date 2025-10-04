# Bartoo Monorepo

A Flutter monorepo for the Bartoo project, featuring a business application with modular architecture and shared packages.

## 🏗️ Tech Stack

### **Frontend Framework**
- **Flutter** - Cross-platform UI framework
- **Dart** SDK >=3.7.0 <4.0.0

### **Architecture & State Management**
- **GetX** - State management, routing, and dependency injection
- **Modular Package Architecture** - Shared packages for better code organization

### **Key Dependencies**

#### **Maps & Location**
- `flutter_map` - Interactive map widget
- `google_maps_flutter` - Google Maps integration
- `geolocator`    - Location services
- `latlong2` - Latitude/longitude utilities

#### **UI & User Experience**
- `flutter_svg` - SVG rendering
- `introduction_screen` - Onboarding screens
- `badges` - Badge widgets
- `infinite_scroll_pagination` - Infinite scrolling lists

#### **Data & Storage**
- `shared_preferences` - Local data persistence
- `get_storage` - Fast key-value storage
- `json_annotation` & `json_serializable` - JSON serialization

#### **Authentication & Security**
- `jwt_decoder` - JWT token handling
- `flutter_dotenv` - Environment variable management

#### **Utilities**
- `image_picker` - Image selection from gallery/camera
- `intl` - Internationalization
- `moment_dart` - Date manipulation
- `logger` - Logging utilities
- `uuid` - Unique identifier generation

### **Development Tools**
- **Melos** - Monorepo management
- **VS Code** - Configured with launch configurations
- **Flutter Lints** - Code quality and style enforcement

## 📁 Project Structure

```
bartoo-monorepo/
├── apps/
│   └── bartoo-business/          # Main business application
│       ├── lib/
│       │   ├── main.dart         # Application entry point
│       │   └── app/              # App-specific code
│       ├── assets/               # Images, fonts, map styles
│       ├── android/              # Android platform code
│       ├── ios/                  # iOS platform code
│       ├── web/                  # Web platform code
│       ├── windows/              # Windows platform code
│       ├── linux/                # Linux platform code
│       └── macos/                # macOS platform code
├── packages/
│   ├── base/                     # Base utilities and constants
│   ├── core/                     # Core business logic
│   ├── ui/                       # Shared UI components and themes
│   └── utils/                    # Utility functions and services
├── melos.yaml                    # Monorepo configuration
└── pubspec.yaml                  # Root package configuration
```

## 🚀 Getting Started

### Prerequisites

- Flutter SDK >=3.7.0
- Dart SDK >=3.7.0
- Node.js (for web development)
- Android Studio / Xcode (for mobile development)

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd bartoo-monorepo
   ```

2. **Install Melos globally**
   ```bash
   dart pub global activate melos
   ```

3. **Bootstrap the monorepo**
   ```bash
   melos bootstrap
   ```

4. **Set up environment variables**
   - Copy `.env.example` to `.env` in the main app directory
   - Configure your environment-specific variables

## 🛠️ Development Workflow

### Available Melos Scripts

```bash
# Analyze all packages
melos run analyze

# Format code across all packages
melos run format

# Fix formatting issues
melos run format:fix

# Run tests for all packages
melos run test

# Clean all packages
melos run clean
```

### Running the Application

#### Web Development (Recommended Port: 50000)
```bash
cd apps/bartoo-business
flutter run -d chrome --web-renderer canvaskit --web-port=50000
```

#### Mobile Development
```bash
cd apps/bartoo-business
flutter run
```

### VS Code Launch Configurations

The project includes pre-configured launch configurations:

- **BartooBusiness** - Debug mode with web port 50000
- **BartooBusiness (profile mode)** - Performance profiling
- **BartooBusiness (release mode)** - Production build

## 📦 Package Dependencies

### Internal Packages

- **`base`** - Foundational utilities and constants
- **`core`** - Business logic, services, and data models
- **`ui`** - Shared UI components, themes, and widgets
- **`utils`** - Helper functions and utility services

### Package Dependency Graph

```
bartoo-business
├── base
├── core → base, ui
├── ui → utils, core
└── utils → ui, base, core
```

## 🏭 Architecture

### State Management
- **GetX** for reactive state management
- **GetX Routes** for navigation
- **GetX Bindings** for dependency injection

### Themes
- Dark and light theme support
- Centralized theme management in the `ui` package
- Automatic theme switching based on system preferences

### Services
- Centralized service initialization
- Authentication services
- Location services
- Storage services

## 🌐 Platform Support

- ✅ **Web** - Optimized with CanvasKit renderer
- ✅ **Android** - Native Android support
- ✅ **iOS** - Native iOS support
- ✅ **Windows** - Desktop Windows support
- ✅ **Linux** - Desktop Linux support
- ✅ **macOS** - Desktop macOS support

## 🔧 Configuration

### Environment Variables (Shared Configuration)

The monorepo uses a **shared environment configuration** through a single `.env` file located at the root of the project. This ensures consistent environment variables across all apps and packages.

**File Structure:**
- **`.env`** - Shared environment file used by all apps and packages
- **`.env.example`** - Template file with all available environment variables

**Environment Variables Used:**

#### API Configuration
- `API_URL` - Backend API base URL (default: http://localhost:8000/api)

#### Authentication & Social Login
- `FACEBOOK_APP_ID` - Facebook OAuth app ID
- `FACEBOOK_SECRET_KEY` - Facebook OAuth secret key
- `FACEBOOK_AUTH_REDIRECT_URL` - Supabase auth callback URL

#### Database & Backend Services
- `SUPABASE_URL` - Supabase project URL
- `SUPABASE_ANON_KEY` - Supabase anonymous key

#### Google Services
- `MAPS_API_KEY` - Google Maps API key

#### Mapbox Configuration
- `MAPBOX_ACCESS_TOKEN` - Mapbox access token
- `MAPBOX_DARK_STYLE_ID` - Dark theme map style ID
- `MAPBOX_DARK_URL` - Dark theme map tiles URL
- `MAPBOX_LIGHT_STYLE_ID` - Light theme map style ID  
- `MAPBOX_LIGHT_URL` - Light theme map tiles URL

#### Navigation Routes
- `HOME_ROUTE` - Default home route (default: /home)
- `INTRODUCTION_ROUTE` - Onboarding route (default: /introduction)
- `ARTIST_HOME_ROUTE` - Artist dashboard route (default: /artist-home)

#### Flutter Configuration
- `FLUTTER_WEB_USE_SKIA` - Enable Skia renderer for web (default: true)

**Setup:**
1. Copy `.env.example` to `.env` in the root directory
2. Configure your environment-specific values

### Web Configuration
- **Renderer**: CanvasKit for better performance
- **Port**: 50000 (configurable)
- **PWA**: Configured with manifest.json

## 📚 Documentation

For detailed documentation, visit the [Documentation Index](./docs/index.md).

## 🤝 Contributing

1. Create a feature branch from `main`
2. Make your changes following the existing code style
3. Run `melos run analyze` to check for issues
4. Run `melos run format` to format your code
5. Run `melos run test` to ensure tests pass
6. Submit a pull request

## 📝 License

This project is proprietary and confidential.

---

**Built with ❤️ using Flutter and Melos**
