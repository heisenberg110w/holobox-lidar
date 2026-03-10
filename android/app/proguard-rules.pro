# Firebase
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }

# Firestore / gRPC
-keep class io.grpc.** { *; }
-keepclassmembers class io.grpc.** { *; }
-dontwarn io.grpc.**

# OkHttp (used by gRPC)
-dontwarn com.squareup.okhttp.**
-dontwarn okhttp3.**
-dontwarn okio.**

# Google Play Core (deferred components)
-dontwarn com.google.android.play.core.**

# Keep model classes
-keepclassmembers class * {
  @com.google.gson.annotations.SerializedName <fields>;
}

# Flutter
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-dontwarn io.flutter.embedding.**
