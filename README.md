# Holobox

Holobox is a Flutter **client app** (Android & iOS) that allows clients to submit ads for the Holobox e-commerce platform. Submitted ads go through an approval process by the admin team.

## Features

- User authentication (Firebase Auth) with Sign Up and Login
- Ad submission with:
  - Image upload
  - **LiDAR 3D scanning** (iOS only, on supported devices)
  - Target demographics (Gender, Ethnicity, Age Group)
  - Notes for reviewers
- View submitted ads and their approval status
- Analytics dashboard showing product performance
- All submitted ads are stored in Firebase for admin review

## Platform Support

| Feature | Android | iOS |
|---------|---------|-----|
| Ad Submission | ✅ | ✅ |
| Image Upload | ✅ | ✅ |
| LiDAR 3D Scan | ❌ | ✅ (iPhone 12 Pro+, iPad Pro 2020+) |
| Analytics | ✅ | ✅ |

## How It Works

1. **Clients sign up/login** using email and password
2. **Submit ads** through the "Post Ad" tab with all required details
3. **iOS users with LiDAR** can optionally add a 3D scan of their product
4. **Track status** in the "My Ads" tab (Pending Review, Approved, or Rejected)
5. **View analytics** for approved products (views, sales, etc.)
6. **Admins** use a separate admin app to approve or reject submitted ads

## Firebase Structure

### Firestore Collections

- `clients/{uid}` - Client profiles (auto-created on sign-up)
- `pending_products/{id}` - Submitted ads awaiting review
- `products/{id}` - Approved ads (moved from pending after approval)
- `scans/{id}` - Standalone LiDAR scans (optional)

### Firebase Storage

- `pending_products/{productId}.jpg` - Submitted ad images
- `pending_products/{productId}.obj` - LiDAR 3D scan files (OBJ format)
- `scans/{userId}/{scanId}.obj` - Standalone scan files

## Firebase Setup

### 1. Firebase Console Setup

1. Create/use an existing Firebase project at [console.firebase.google.com](https://console.firebase.google.com)
2. Enable **Email/Password Authentication** in Authentication > Sign-in method

### 2. Android Setup

1. Add your Android app to Firebase Console (use package: `com.holobox.client`)
2. Download `google-services.json` and place in `android/app/`
3. Add your SHA-1 fingerprint to Firebase Console

### 3. iOS Setup

1. Add your iOS app to Firebase Console
2. Download `GoogleService-Info.plist` and place in `ios/Runner/`
3. The bundle identifier should match your Firebase configuration

### 4. Firestore Security Rules

Update your Firestore rules to include:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Client profiles
    match /clients/{uid} {
      allow read, write: if request.auth != null && request.auth.uid == uid;
    }
    
    // Pending products (client submissions)
    match /pending_products/{productId} {
      // Clients can create new submissions
      allow create: if request.auth != null;
      // Authenticated users can read (for "My Ads" screen)
      allow read: if request.auth != null;
      // Admin app handles update/delete
      allow update, delete: if request.auth != null;
    }
    
    // Approved products
    match /products/{productId} {
      allow read: if true;
      // Write handled by admin app
      allow write: if request.auth != null;
    }
    
    // LiDAR scans storage metadata
    match /scans/{scanId} {
      allow read, write: if request.auth != null;
    }
  }
}
```

### 5. Firebase Storage Rules

Update your Storage rules to allow uploads:

```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    // Pending products - images and scans
    match /pending_products/{fileName} {
      allow read: if true;
      allow write: if request.auth != null;
    }
    
    // Standalone scans
    match /scans/{userId}/{fileName} {
      allow read: if true;
      allow write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Product images (approved products)
    match /products/{fileName} {
      allow read: if true;
      allow write: if request.auth != null;
    }
  }
}
```

### 6. Firestore Indexes

Create a composite index for the "My Ads" screen:

| Collection | Fields |
|------------|--------|
| `pending_products` | `submittedBy` (Ascending), `submittedAt` (Descending) |

## Running the App

### Android

```bash
flutter pub get
flutter run
# or for release APK
flutter build apk --release
```

### iOS

```bash
flutter pub get
cd ios && pod install && cd ..
flutter run
# or for release IPA
flutter build ios --release
```

## LiDAR Scanning (iOS Only)

The app automatically detects if the device supports LiDAR scanning. On supported devices:

1. A "3D Scan" option appears in the ad submission form
2. Tap to open the LiDAR scanner
3. Move around the product to capture the 3D mesh
4. The progress bar shows scan completion
5. Tap "Capture" when ready
6. The OBJ file is uploaded to Firebase Storage alongside the image

**Supported Devices:**
- iPhone 12 Pro / Pro Max and newer Pro models
- iPad Pro (2020) and newer

## Firebase Changes Summary

When setting up this app with your Firebase project, you need to:

1. ✅ Enable Email/Password Authentication
2. ✅ Update Firestore Security Rules (see above)
3. ✅ Update Storage Security Rules (see above)
4. ✅ Create composite index for `pending_products` collection
5. ✅ Add Android app with SHA-1 fingerprint
6. ✅ Add iOS app (if using iOS)

## Notes

- This is the **client-facing app** for ad submissions
- A separate **admin app** handles approval/rejection of submissions
- Both apps share the same Firebase project
- LiDAR scans are stored as OBJ (Wavefront) files
- The app works on both Android and iOS, but LiDAR is iOS-only
