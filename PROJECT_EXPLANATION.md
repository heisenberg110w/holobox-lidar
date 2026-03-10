# Holobox Client App - Complete Code Explanation

## Table of Contents
1. [Project Overview](#1-project-overview)
2. [Architecture & Folder Structure](#2-architecture--folder-structure)
3. [Main Entry Point (main.dart)](#3-main-entry-point-maindart)
4. [State Management with Provider](#4-state-management-with-provider)
5. [Authentication System](#5-authentication-system)
6. [Repository Pattern](#6-repository-pattern)
7. [Screens Explained](#7-screens-explained)
8. [Firebase Integration](#8-firebase-integration)
9. [Data Models](#9-data-models)
10. [UI Theme & Colors](#10-ui-theme--colors)
11. [Key Flutter Concepts Used](#11-key-flutter-concepts-used)
12. [Data Flow Diagrams](#12-data-flow-diagrams)

---

## 1. Project Overview

### What is Holobox?
Holobox is a **Flutter-based Android client app** that allows users (clients) to:
- **Sign up / Login** with email and password
- **Submit ads** with images and demographic targeting (gender, ethnicity, age group)
- **Track their submissions** and see approval status
- **View analytics** of their approved ads

### How It Fits in the Ecosystem
```
┌─────────────────────────────────────────────────────────────┐
│                      FIREBASE (Cloud)                        │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐       │
│  │ Authentication│  │  Firestore   │  │   Storage    │       │
│  │   (Users)     │  │  (Database)  │  │   (Images)   │       │
│  └──────────────┘  └──────────────┘  └──────────────┘       │
└─────────────────────────────────────────────────────────────┘
         ▲                   ▲                   ▲
         │                   │                   │
    ┌────┴────┐         ┌────┴────┐         ┌────┴────┐
    │ Holobox │         │  Admin  │         │E-commerce│
    │ Client  │         │Software │         │   App    │
    │  (This) │         │(Separate)│        │(Separate)│
    └─────────┘         └─────────┘         └─────────┘
    
    Submits ads      Approves/Rejects     Shows approved
    for review           ads              products to buyers
```

---

## 2. Architecture & Folder Structure

```
lib/
├── main.dart                      # App entry point
├── firebase_options.dart          # Firebase configuration (auto-generated)
│
├── core/                          # Core utilities & theming
│   ├── config/
│   │   └── app_config.dart        # Environment configuration
│   ├── constants/
│   │   └── app_constants.dart     # App-wide constants
│   └── theme/
│       ├── app_colors.dart        # Color definitions
│       └── app_theme.dart         # Material theme configuration
│
├── features/                      # Feature modules
│   └── admin/                     # Main feature (named 'admin' historically)
│       ├── models/
│       │   ├── pending_product.dart   # Data model for submissions
│       │   └── admin_stats.dart       # Stats data model
│       ├── providers/
│       │   └── admin_auth_provider.dart  # Authentication state
│       ├── repositories/
│       │   ├── admin_repository.dart     # Abstract interface
│       │   ├── firebase_admin_repository.dart  # Firebase implementation
│       │   └── demo_admin_repository.dart      # Demo/mock implementation
│       └── screens/
│           ├── admin_auth_wrapper.dart    # Auth routing
│           ├── admin_login_screen.dart    # Login/Signup UI
│           ├── admin_dashboard_screen.dart # Main navigation
│           ├── product_submission_screen.dart # Ad submission form
│           ├── my_submissions_screen.dart    # User's ads list
│           └── analytics_screen.dart         # Analytics dashboard
│
└── shared/                        # Shared widgets
    └── widgets/
        └── custom_app_bar.dart
```

### Architecture Pattern: **Feature-First + Repository Pattern**

```
┌─────────────────────────────────────────────────────┐
│                    UI (Screens)                      │
│  Login, Dashboard, Submission, My Ads, Analytics    │
└─────────────────────────┬───────────────────────────┘
                          │ uses
                          ▼
┌─────────────────────────────────────────────────────┐
│              State Management (Provider)             │
│         ClientAuthProvider, AdminRepository          │
└─────────────────────────┬───────────────────────────┘
                          │ calls
                          ▼
┌─────────────────────────────────────────────────────┐
│              Repository (Data Layer)                 │
│    FirebaseAdminRepository / DemoAdminRepository     │
└─────────────────────────┬───────────────────────────┘
                          │ communicates
                          ▼
┌─────────────────────────────────────────────────────┐
│                   Firebase Services                  │
│        Auth, Firestore, Storage                      │
└─────────────────────────────────────────────────────┘
```

---

## 3. Main Entry Point (main.dart)

```dart
Future<void> main() async {
  // 1. Ensure Flutter is initialized before using platform channels
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Check if we should force demo mode (for testing without Firebase)
  bool demoMode = AppConfig.forceDemo;
  
  // 3. Initialize Firebase
  try {
    if (!demoMode) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
  } catch (_) {
    // If Firebase fails, fall back to demo mode
    demoMode = true;
  }

  // 4. Configure system UI (status bar style)
  SystemChrome.setSystemUIOverlayStyle(...);

  // 5. Launch the app
  runApp(HoloboxApp(demoMode: demoMode));
}
```

### Key Concepts:

**WidgetsFlutterBinding.ensureInitialized()**
- Must be called before using any Flutter services
- Required before Firebase initialization

**Demo Mode**
- Allows testing UI without Firebase connection
- Uses in-memory mock data instead

**Firebase.initializeApp()**
- Connects app to Firebase project
- Uses configuration from `firebase_options.dart`

---

## 4. State Management with Provider

### What is Provider?
Provider is a **state management solution** that allows widgets to:
- Access shared data (state) from anywhere in the widget tree
- Automatically rebuild when data changes

### How We Use Provider

```dart
// In main.dart - Setting up providers
MultiProvider(
  providers: [
    // Repository - for data operations
    Provider<AdminRepository>(
      create: (_) => demoMode 
          ? DemoAdminRepository() 
          : FirebaseAdminRepository(),
    ),
    
    // Auth Provider - for authentication state
    ChangeNotifierProvider(
      create: (_) => ClientAuthProvider(demoMode: demoMode)..init(),
    ),
  ],
  child: MaterialApp(...),
)
```

### Accessing Provider in Widgets

```dart
// READ once (doesn't listen to changes)
final auth = context.read<ClientAuthProvider>();

// WATCH for changes (rebuilds widget when data changes)
final auth = context.watch<ClientAuthProvider>();

// Using Consumer widget (alternative approach)
Consumer<ClientAuthProvider>(
  builder: (context, auth, child) {
    if (auth.isSignedIn) {
      return DashboardScreen();
    }
    return LoginScreen();
  },
)
```

### ChangeNotifier Pattern

```dart
class ClientAuthProvider extends ChangeNotifier {
  User? _user;
  User? get user => _user;  // Getter for external access
  
  void updateUser(User newUser) {
    _user = newUser;
    notifyListeners();  // Tells all listeners to rebuild
  }
}
```

---

## 5. Authentication System

### File: `admin_auth_provider.dart`

### Authentication Flow

```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│   Login     │────▶│  Firebase   │────▶│  Success?   │
│   Screen    │     │    Auth     │     │             │
└─────────────┘     └─────────────┘     └──────┬──────┘
                                               │
                         ┌─────────────────────┴─────────────────────┐
                         │                                           │
                         ▼                                           ▼
                   ┌─────────────┐                           ┌─────────────┐
                   │    YES      │                           │     NO      │
                   │ Go to       │                           │ Show Error  │
                   │ Dashboard   │                           │ Message     │
                   └─────────────┘                           └─────────────┘
```

### Key Code Explained

```dart
class ClientAuthProvider extends ChangeNotifier {
  final bool demoMode;
  final FirebaseAuth? _auth;
  final FirebaseFirestore? _firestore;
  
  // State variables
  bool _isInitializing = true;  // Loading state
  User? _user;                   // Current user
  String? _errorMessage;         // Error to display
  
  // Initialize - called once when app starts
  Future<void> init() async {
    if (demoMode) {
      _isInitializing = false;
      notifyListeners();
      return;
    }

    // Listen to auth state changes (login/logout)
    _auth!.authStateChanges().listen((user) async {
      _user = user;
      _isInitializing = false;
      
      // Save user info to Firestore
      if (user != null) {
        await _firestore!.collection('clients').doc(user.uid).set({
          'email': user.email,
          'lastLogin': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      }
      
      notifyListeners();  // Update UI
    });
  }
  
  // Login method
  Future<void> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    _errorMessage = null;
    notifyListeners();

    try {
      await _auth!.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      // Success - authStateChanges listener will handle the rest
    } on FirebaseAuthException catch (e) {
      _errorMessage = e.message ?? 'Login failed.';
      notifyListeners();
    }
  }
  
  // Signup method
  Future<void> signUpWithEmailPassword({
    required String email,
    required String password,
    String? displayName,
  }) async {
    try {
      // Create user in Firebase Auth
      final credential = await _auth!.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      
      // Create profile in Firestore
      await _firestore!.collection('clients').doc(credential.user!.uid).set({
        'email': email.trim(),
        'displayName': displayName ?? '',
        'createdAt': FieldValue.serverTimestamp(),
      });
    } on FirebaseAuthException catch (e) {
      // Handle specific errors
      if (e.code == 'email-already-in-use') {
        _errorMessage = 'An account already exists with this email.';
      }
      notifyListeners();
    }
  }
}
```

### Auth Wrapper - Routing Based on Auth State

```dart
// admin_auth_wrapper.dart
class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ClientAuthProvider>(
      builder: (context, auth, _) {
        // Show loading screen while checking auth
        if (auth.isInitializing) {
          return SplashScreen();
        }
        
        // Not logged in - show login
        if (!auth.isSignedIn) {
          return LoginScreen();
        }
        
        // Logged in - show main app
        return DashboardScreen();
      },
    );
  }
}
```

---

## 6. Repository Pattern

### What is the Repository Pattern?
A **design pattern** that separates data access logic from business logic.

### Benefits:
1. **Testability** - Easy to mock for testing
2. **Flexibility** - Can swap implementations (Firebase ↔ Demo)
3. **Clean Code** - UI doesn't know about Firebase details

### Abstract Interface

```dart
// admin_repository.dart - Contract/Interface
abstract class AdminRepository {
  // Watch pending products (real-time stream)
  Stream<List<PendingProduct>> watchPendingProducts();
  
  // Submit a new product/ad
  Future<void> submitPendingProduct({
    required String createdBy,
    required String name,
    required String notes,
    required String gender,
    required String ethnicity,
    required String ageGroup,
    required File imageFile,
  });
  
  // Approve a pending product
  Future<void> approvePendingProduct({
    required String id,
    required String approvedBy,
  });
  
  // Reject a pending product
  Future<void> rejectPendingProduct({
    required String id,
    required String rejectedBy,
  });
  
  // Get statistics
  Future<AdminStats> getStats();
}
```

### Firebase Implementation

```dart
// firebase_admin_repository.dart
class FirebaseAdminRepository implements AdminRepository {
  final _uuid = const Uuid();  // For generating unique IDs
  
  @override
  Future<void> submitPendingProduct({...}) async {
    // 1. Generate unique ID
    final productId = _uuid.v4();
    
    // 2. Upload image to Firebase Storage
    final storagePath = 'pending_products/$productId.jpg';
    final storageRef = FirebaseStorage.instance.ref(storagePath);
    final uploadTask = await storageRef.putFile(
      imageFile,
      SettableMetadata(contentType: 'image/jpeg'),
    );
    final imageUrl = await uploadTask.ref.getDownloadURL();
    
    // 3. Create document in Firestore
    await FirebaseFirestore.instance
        .collection('pending_products')
        .doc(productId)
        .set({
          'name': name,
          'notes': notes,
          'gender': gender,
          'ethnicity': ethnicity,
          'ageGroup': ageGroup,
          'imageUrl': imageUrl,
          'imageStoragePath': storagePath,
          'submittedBy': createdBy,
          'submittedAt': FieldValue.serverTimestamp(),
          'status': 'pending',
        });
  }
  
  @override
  Stream<List<PendingProduct>> watchPendingProducts() {
    // Real-time listener to Firestore
    return FirebaseFirestore.instance
        .collection('pending_products')
        .orderBy('submittedAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return PendingProduct.fromFirestore(doc);
          }).toList();
        });
  }
}
```

### Demo Implementation (For Testing)

```dart
// demo_admin_repository.dart
class DemoAdminRepository implements AdminRepository {
  // In-memory storage (not real database)
  final List<PendingProduct> _pendingProducts = [];
  
  @override
  Future<void> submitPendingProduct({...}) async {
    // Simulate network delay
    await Future.delayed(Duration(milliseconds: 500));
    
    // Add to in-memory list
    _pendingProducts.add(PendingProduct(
      id: DateTime.now().toString(),
      name: name,
      // ... other fields
    ));
  }
}
```

---

## 7. Screens Explained

### 7.1 Login Screen (`admin_login_screen.dart`)

**Purpose:** User authentication (login/signup)

**Key Features:**
- Toggle between Login and Sign Up modes
- Form validation
- Error display via SnackBar
- Password visibility toggle

```dart
class _LoginScreenState extends State<LoginScreen> {
  // Controllers for text input
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  
  // State
  bool _isSignUp = false;      // Login vs Signup mode
  bool _isLoading = false;     // Show loading indicator
  bool _obscurePassword = true; // Hide/show password
  
  // Handle login button
  Future<void> _handleLogin() async {
    // Validate inputs
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      // Show error
      return;
    }
    
    setState(() => _isLoading = true);
    
    // Call auth provider
    await context.read<ClientAuthProvider>().signInWithEmailPassword(
      email: _emailController.text,
      password: _passwordController.text,
    );
    
    setState(() => _isLoading = false);
  }
}
```

### 7.2 Dashboard Screen (`admin_dashboard_screen.dart`)

**Purpose:** Main navigation hub with bottom tabs

**Structure:**
```dart
class DashboardScreen extends StatefulWidget {
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;  // Currently selected tab
  
  // Screens for each tab
  final List<Widget> _screens = [
    ProductSubmissionScreen(),  // Tab 0: Post Ad
    MySubmissionsScreen(),      // Tab 1: My Ads
    AnalyticsScreen(),          // Tab 2: Analytics
  ];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Holobox')),
      
      // IndexedStack keeps all screens in memory
      // Only shows the one at _currentIndex
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      
      bottomNavigationBar: _buildBottomNav(),
    );
  }
}
```

**IndexedStack vs PageView:**
- `IndexedStack` keeps all children built (preserves state)
- Shows only one child at a time based on index
- Good for tabs where you want to preserve scroll position

### 7.3 Product Submission Screen (`product_submission_screen.dart`)

**Purpose:** Form to submit new ads

**Form Fields:**
1. Ad Title (text input)
2. Image (from gallery)
3. Target Gender (Male/Female/Unisex)
4. Target Ethnicity (dropdown)
5. Target Age Group (dropdown)
6. Notes (optional text)

**Key Code:**

```dart
class _ProductSubmissionScreenState extends State<ProductSubmissionScreen> {
  File? _selectedImage;
  String? _selectedGender;
  String? _selectedEthnicity;
  String? _selectedAgeGroup;
  
  final _nameController = TextEditingController();
  final _notesController = TextEditingController();
  
  // Pick image from gallery
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1920,
      maxHeight: 1920,
      imageQuality: 85,
    );
    
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }
  
  // Submit the ad
  Future<void> _submitProduct() async {
    // Validation
    if (_nameController.text.isEmpty) { /* show error */ }
    if (_selectedImage == null) { /* show error */ }
    if (_selectedGender == null) { /* show error */ }
    
    setState(() => _isSubmitting = true);
    
    // Get current user ID
    final auth = context.read<ClientAuthProvider>();
    final uid = auth.uid!;
    
    // Submit via repository
    await context.read<AdminRepository>().submitPendingProduct(
      createdBy: uid,
      name: _nameController.text,
      notes: _notesController.text,
      gender: _selectedGender!,
      ethnicity: _selectedEthnicity!,
      ageGroup: _selectedAgeGroup!,
      imageFile: _selectedImage!,
    );
    
    // Clear form on success
    setState(() {
      _selectedImage = null;
      _selectedGender = null;
      // ... reset all fields
    });
    
    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Ad submitted successfully!')),
    );
  }
}
```

### 7.4 My Submissions Screen (`my_submissions_screen.dart`)

**Purpose:** Show user's submitted ads with status

**Key Concept: StreamBuilder**

```dart
StreamBuilder<QuerySnapshot>(
  // Real-time listener to Firestore
  stream: FirebaseFirestore.instance
      .collection('pending_products')
      .where('submittedBy', isEqualTo: uid)  // Only user's ads
      .orderBy('submittedAt', descending: true)  // Newest first
      .snapshots(),
      
  builder: (context, snapshot) {
    // Handle loading
    if (!snapshot.hasData) {
      return CircularProgressIndicator();
    }
    
    // Handle empty
    if (snapshot.data!.docs.isEmpty) {
      return Text('No submissions yet');
    }
    
    // Build list
    return ListView.builder(
      itemCount: snapshot.data!.docs.length,
      itemBuilder: (context, index) {
        final doc = snapshot.data!.docs[index];
        final data = doc.data() as Map<String, dynamic>;
        
        return SubmissionCard(
          name: data['name'],
          status: data['status'],
          imageUrl: data['imageUrl'],
        );
      },
    );
  },
)
```

**Status Display:**
```dart
// Determine status color and text
Color statusColor;
String statusText;

switch (status) {
  case 'approved':
    statusColor = Colors.green;
    statusText = 'Approved';
    break;
  case 'rejected':
    statusColor = Colors.red;
    statusText = 'Rejected';
    break;
  default:
    statusColor = Colors.orange;
    statusText = 'Pending Review';
}
```

### 7.5 Analytics Screen (`analytics_screen.dart`)

**Purpose:** Show performance metrics for approved ads

**Stats Shown:**
- Pending ads count
- Approved ads count
- Total views
- Total sales

**Nested StreamBuilders:**

```dart
// First stream: pending products
StreamBuilder<QuerySnapshot>(
  stream: FirebaseFirestore.instance
      .collection('pending_products')
      .where('submittedBy', isEqualTo: uid)
      .snapshots(),
  builder: (context, pendingSnapshot) {
    
    // Second stream: approved products
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('products')
          .where('submittedBy', isEqualTo: uid)
          .snapshots(),
      builder: (context, approvedSnapshot) {
        // Calculate stats from both streams
        int pendingCount = pendingSnapshot.data?.docs.length ?? 0;
        int approvedCount = approvedSnapshot.data?.docs.length ?? 0;
        
        // Build UI with stats
        return StatsGrid(...);
      },
    );
  },
)
```

---

## 8. Firebase Integration

### 8.1 Firebase Services Used

| Service | Purpose |
|---------|---------|
| **Authentication** | User login/signup with email & password |
| **Firestore** | NoSQL database for storing data |
| **Storage** | File storage for images |

### 8.2 Firestore Collections

```
Firestore Database
│
├── clients/                    # User profiles
│   └── {uid}/
│       ├── email: string
│       ├── displayName: string
│       ├── createdAt: timestamp
│       └── lastLogin: timestamp
│
├── pending_products/           # Submitted ads (awaiting review)
│   └── {productId}/
│       ├── name: string
│       ├── notes: string
│       ├── gender: string
│       ├── ethnicity: string
│       ├── ageGroup: string
│       ├── imageUrl: string
│       ├── imageStoragePath: string
│       ├── submittedBy: string (uid)
│       ├── submittedAt: timestamp
│       └── status: string ('pending')
│
└── products/                   # Approved ads
    └── {productId}/
        ├── (same fields as pending)
        ├── approvedBy: string
        ├── approvedAt: timestamp
        ├── views: number
        ├── sales: number
        └── revenue: number
```

### 8.3 Firebase Storage Structure

```
Firebase Storage
│
└── pending_products/
    ├── {productId1}.jpg
    ├── {productId2}.jpg
    └── ...
```

### 8.4 Firestore Security Rules Explained

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    // Client profiles - users can only access their own
    match /clients/{uid} {
      allow read, write: if request.auth != null   // Must be logged in
                         && request.auth.uid == uid; // Can only access own doc
    }
    
    // Pending products
    match /pending_products/{productId} {
      allow read, write: if request.auth != null;  // Any logged in user
    }
  }
}
```

### 8.5 Firestore Indexes

**Why Indexes?**
Firestore requires indexes for queries with:
- Multiple `where` clauses
- `where` + `orderBy` on different fields

**Required Index:**
```
Collection: pending_products
Fields: submittedBy (Ascending) + submittedAt (Descending)
```

This index is needed for the query:
```dart
.where('submittedBy', isEqualTo: uid)
.orderBy('submittedAt', descending: true)
```

---

## 9. Data Models

### PendingProduct Model

```dart
// pending_product.dart
class PendingProduct {
  final String id;
  final String name;
  final String? notes;
  final String gender;
  final String ethnicity;
  final String ageGroup;
  final String? imageUrl;
  final DateTime submittedAt;

  const PendingProduct({
    required this.id,
    required this.name,
    required this.gender,
    required this.ethnicity,
    required this.ageGroup,
    required this.submittedAt,
    this.notes,
    this.imageUrl,
  });

  // Factory constructor - creates instance from Firestore document
  factory PendingProduct.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PendingProduct(
      id: doc.id,
      name: data['name'] ?? '',
      notes: data['notes'],
      gender: data['gender'] ?? '',
      ethnicity: data['ethnicity'] ?? '',
      ageGroup: data['ageGroup'] ?? '',
      imageUrl: data['imageUrl'],
      submittedAt: (data['submittedAt'] as Timestamp).toDate(),
    );
  }
  
  // Convert to Map for saving to Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'notes': notes,
      'gender': gender,
      'ethnicity': ethnicity,
      'ageGroup': ageGroup,
      'imageUrl': imageUrl,
      'submittedAt': Timestamp.fromDate(submittedAt),
    };
  }
}
```

---

## 10. UI Theme & Colors

### App Colors (`app_colors.dart`)

```dart
class AppColors {
  // Primary colors
  static const primaryPurple = Color(0xFF7C4DFF);
  static const lightBlue = Color(0xFF64B5F6);
  
  // Background colors
  static const scaffoldBackground = Color(0xFFF5F7FA);
  static const white = Color(0xFFFFFFFF);
  
  // Text colors
  static const textDark = Color(0xFF1A1A2E);
  static const textSecondary = Color(0xFF6B7280);
  
  // Status colors
  static const success = Color(0xFF10B981);
  static const error = Color(0xFFEF4444);
  static const warningOrange = Color(0xFFF59E0B);
  static const info = Color(0xFF3B82F6);
}
```

### App Theme (`app_theme.dart`)

```dart
class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: AppColors.primaryPurple,
      scaffoldBackgroundColor: AppColors.scaffoldBackground,
      
      // App bar styling
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.white,
        elevation: 0,
        titleTextStyle: TextStyle(
          color: AppColors.textDark,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      
      // Font family
      fontFamily: 'SF Pro Display',
    );
  }
}
```

---

## 11. Key Flutter Concepts Used

### 11.1 StatelessWidget vs StatefulWidget

```dart
// StatelessWidget - No internal state, rebuilds only when parent rebuilds
class MyStatelessWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text('I never change internally');
  }
}

// StatefulWidget - Has internal state, can rebuild itself
class MyStatefulWidget extends StatefulWidget {
  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int counter = 0;  // Internal state
  
  void increment() {
    setState(() {  // Triggers rebuild
      counter++;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Text('Count: $counter');
  }
}
```

### 11.2 Async/Await

```dart
// Asynchronous function (returns Future)
Future<void> fetchData() async {
  // 'await' pauses execution until Future completes
  final result = await someAsyncOperation();
  
  // This runs after someAsyncOperation completes
  print(result);
}

// Handling errors
Future<void> safeOperation() async {
  try {
    await riskyOperation();
  } catch (e) {
    print('Error: $e');
  }
}
```

### 11.3 Streams and StreamBuilder

```dart
// Stream - Continuous flow of data (like real-time updates)
Stream<int> countStream() async* {
  for (int i = 0; i < 10; i++) {
    await Future.delayed(Duration(seconds: 1));
    yield i;  // Emit value
  }
}

// StreamBuilder - Widget that rebuilds when stream emits
StreamBuilder<int>(
  stream: countStream(),
  builder: (context, snapshot) {
    if (snapshot.hasError) return Text('Error');
    if (!snapshot.hasData) return CircularProgressIndicator();
    return Text('Count: ${snapshot.data}');
  },
)
```

### 11.4 BuildContext

```dart
// BuildContext represents the widget's location in the tree
// Used to:
// 1. Access inherited widgets (like Provider)
// 2. Navigate
// 3. Show dialogs/snackbars

Widget build(BuildContext context) {
  // Access Provider
  final auth = context.read<ClientAuthProvider>();
  
  // Navigate
  Navigator.of(context).push(...);
  
  // Show snackbar
  ScaffoldMessenger.of(context).showSnackBar(...);
  
  // Get screen size
  final size = MediaQuery.of(context).size;
}
```

### 11.5 Widget Lifecycle

```dart
class _MyWidgetState extends State<MyWidget> {
  @override
  void initState() {
    super.initState();
    // Called once when widget is created
    // Good for: initialization, subscriptions
  }
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Called when dependencies change (e.g., inherited widgets)
  }
  
  @override
  Widget build(BuildContext context) {
    // Called every time widget needs to rebuild
    return Container();
  }
  
  @override
  void dispose() {
    // Called when widget is removed
    // Good for: cleanup, cancel subscriptions
    super.dispose();
  }
}
```

---

## 12. Data Flow Diagrams

### Login Flow

```
┌──────────┐    ┌──────────────┐    ┌───────────────┐    ┌──────────┐
│  User    │───▶│ LoginScreen  │───▶│ AuthProvider  │───▶│ Firebase │
│  types   │    │ _handleLogin │    │ signIn()      │    │   Auth   │
│  email   │    └──────────────┘    └───────────────┘    └────┬─────┘
│  & pass  │                                                   │
└──────────┘                                                   │
                                                               ▼
┌──────────┐    ┌──────────────┐    ┌───────────────┐    ┌──────────┐
│Dashboard │◀───│ AuthWrapper  │◀───│ AuthProvider  │◀───│ Success  │
│  shown   │    │ checks       │    │ notifies      │    │ callback │
└──────────┘    │ isSignedIn   │    │ listeners     │    └──────────┘
                └──────────────┘    └───────────────┘
```

### Ad Submission Flow

```
┌──────────┐    ┌──────────────┐    ┌───────────────┐    ┌──────────┐
│  User    │───▶│ Submission   │───▶│  Repository   │───▶│ Storage  │
│  fills   │    │   Screen     │    │  submitProd() │    │  upload  │
│  form    │    └──────────────┘    └───────┬───────┘    │  image   │
└──────────┘                                │            └────┬─────┘
                                            │                 │
                                            ▼                 ▼
┌──────────┐    ┌──────────────┐    ┌───────────────┐    ┌──────────┐
│ Success  │◀───│   SnackBar   │◀───│   Firestore   │◀───│  Create  │
│ message  │    │   shown      │    │   document    │    │  doc     │
└──────────┘    └──────────────┘    └───────────────┘    └──────────┘
```

### Real-time Updates Flow

```
┌───────────────┐         ┌───────────────┐         ┌───────────────┐
│   Firestore   │────────▶│ StreamBuilder │────────▶│     UI        │
│   changes     │  stream │   receives    │ rebuild │   updates     │
│   data        │         │   new data    │         │   automatically│
└───────────────┘         └───────────────┘         └───────────────┘

Example: Admin approves ad → Firestore updates → 
         StreamBuilder gets new snapshot → UI shows "Approved" status
```

---

## Quick Reference - Common Questions

### Q: How does the app know if user is logged in?
**A:** `ClientAuthProvider` listens to `FirebaseAuth.authStateChanges()`. When user logs in/out, this stream emits the new state, and `AuthWrapper` rebuilds to show the appropriate screen.

### Q: How do real-time updates work?
**A:** Firestore's `.snapshots()` returns a Stream. When data changes in the database, Firestore pushes the new data through the stream. `StreamBuilder` listens to this and rebuilds the UI.

### Q: Why use Repository pattern?
**A:** 
1. **Separation of concerns** - UI doesn't know about Firebase
2. **Testability** - Can swap `FirebaseRepository` with `MockRepository`
3. **Flexibility** - Easy to change data source later

### Q: What happens when user submits an ad?
**A:**
1. Image uploads to Firebase Storage
2. Document creates in Firestore `pending_products`
3. Form clears and success message shows
4. Ad appears in "My Ads" tab (via real-time stream)

### Q: How does the app handle errors?
**A:** Try-catch blocks catch errors, set `_errorMessage` in providers, and UI shows SnackBars with error messages.

---

## Glossary

| Term | Definition |
|------|------------|
| **Widget** | Basic building block of Flutter UI |
| **State** | Data that can change over time |
| **Provider** | State management solution |
| **ChangeNotifier** | Class that notifies listeners when data changes |
| **Stream** | Sequence of asynchronous data events |
| **Future** | Represents a value that will be available later |
| **async/await** | Syntax for handling asynchronous code |
| **BuildContext** | Handle to widget's location in tree |
| **Firestore** | NoSQL document database |
| **Collection** | Group of documents in Firestore |
| **Document** | Single record in Firestore |

---

Good luck with your project review! 🎯
