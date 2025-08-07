# Keep Play Core classes required by Flutter
-keep class com.google.android.play.core.** { *; }
-dontwarn com.google.android.play.core.**

# Keep Google Play Services Tasks classes
-keep class com.google.android.gms.tasks.** { *; }
-dontwarn com.google.android.gms.tasks.**

# Keep classes for in-app updates
-keep class com.google.android.play.core.appupdate.** { *; }
-keep class com.google.android.play.core.install.** { *; }
-keep class com.google.android.play.core.splitinstall.** { *; }
-keep class com.google.android.play.core.tasks.** { *; }

# Keep review API classes
-keep class com.google.android.play.core.review.** { *; }

# Keep feature delivery classes  
-keep class com.google.android.play.core.splitcompat.** { *; }
