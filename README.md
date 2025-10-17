## 🏗️ Architectural Approach & Design Decisions

### **MVVM Architecture with SwiftUI**
- **ViewModels**: `AuthManager` and `UserViewModel` handle business logic and state management
- **Views**: Modular SwiftUI components with clear separation of concerns
- **Models**: Comprehensive data models with proper Codable conformance
- **Environment Objects**: Dependency injection for shared state across the app

### **Key Design Patterns**

#### **1. State Management**
- `@Published` properties for reactive UI updates
- `@MainActor` isolation for thread-safe UI operations
- Environment objects for cross-component state sharing

#### **2. Performance Optimizations**
- **Background Task Processing**: Network requests on background queues
- **Caching Strategy**: UserDefaults-based caching with background persistence
- **Retry Logic**: Exponential backoff with configurable retry attempts
- **Optimized Networking**: Custom URLSession configuration with timeouts
- **Visual Effects**: Efficient viewport-based scaling and positioning

#### **3. Advanced UI Patterns**
- **Honeycomb Layout**: Mathematical positioning system with concentric rings
- **Dynamic Scaling**: Viewport-aware bubble scaling for immersive experience
- **Smooth Animations**: Spring-based transitions with staggered timing
- **Push-Away Effects**: Physics-inspired interactions between UI elements

#### **4. Component Architecture**
- **Reusable Components**: Modular profile components with consistent styling
- **Async Image Loading**: Custom async image handling with fallbacks
- **Navigation Stack**: Modern navigation with type-safe routing

## ⚖️ Trade-offs & Limitations

### **Performance vs. Complexity**
- **Pros**: Advanced visual effects and smooth animations
- **Cons**: Complex mathematical calculations for honeycomb positioning
- **Mitigation**: Pre-calculated constants and optimized rendering

### **Caching Strategy**
- **Pros**: Fast app startup and offline capability
- **Cons**: UserDefaults storage limitations for large datasets
- **Limitation**: No persistent database for complex queries

### **Network Architecture**
- **Pros**: Robust retry logic and error handling
- **Cons**: Single API dependency (randomuser.me)
- **Limitation**: No offline-first architecture

### **UI Complexity**
- **Pros**: Unique and engaging user experience
- **Cons**: Higher memory usage for complex animations
- **Limitation**: May not perform well on older devices

### **Authentication**
- **Pros**: Simple demo authentication flow
- **Cons**: No real authentication system
- **Limitation**: Uses random user generation for demo purposes

## 🚀 How to Build and Run

### **Prerequisites**
- **iOS 26.0+** deployment target

### **Setup Instructions**

1. **Clone the Repository**
   ```bash
   git clone <repository-url>
   cd LumenoAi-Test
   ```

2. **Open in Xcode**
   ```bash
   open LumenoAi-Test.xcodeproj
   ```

3. **Configure Project**
   - Select your development team in project settings
   - Ensure deployment target is set to iOS 26.0+
   - Verify bundle identifier is unique

4. **Build and Run**
   - Select target device or simulator
   - Press `Cmd + R` or click the Run button
   - App will launch with login screen

### **Project Structure**
```
LumenoAi-Test/
├── Model/                    # Data models and structures
│   ├── UserResponse.swift   # API response models
│   └── HoneycombPosition.swift # UI positioning model
├── View/                    # SwiftUI views and components
│   ├── Components/          # Reusable UI components
│   ├── ContentView.swift    # Main app container
│   ├── HomeListView.swift   # Honeycomb user interface
│   ├── LoginView.swift      # Authentication screen
│   └── ProfileView.swift    # User profile details
├── ViewModel/               # Business logic and state management
│   ├── AuthManager.swift    # Authentication handling
│   ├── UserViewModel.swift  # User data management
│   └── HoneycombViewModel.swift # UI positioning logic
└── Assets.xcassets/         # App icons and images
```

### **Key Features to Test**

1. **Authentication Flow**
   - Login with any credentials (demo mode)
   - Random user generation
   - Persistent login state

2. **Honeycomb Interface**
   - Interactive bubble scaling
   - Smooth animations and transitions
   - Profile navigation

3. **Performance Features**
   - Background data refresh
   - Caching and offline capability
   - Smooth scrolling and interactions

4. **Profile Management**
   - Detailed user profiles
   - Image viewing and navigation
   - User information

### **Development Notes**

- **Background Tasks**: Requires proper provisioning profile for background refresh
- **Network Requests**: Uses randomuser.me API (no authentication required)
- **Caching**: Data persists between app launches
- **Animations**: Optimized for 60fps on modern devices

### **Testing**
- Unit tests available in `LumenoAi-TestTests/`
- Run tests with `Cmd + U`

---

