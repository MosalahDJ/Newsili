# =========================================================================
# ESSENTIAL FLUTTER/ANDROID RULES
# =========================================================================

# Keep the core Flutter/Android runtime components
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Keep all class names that are used for reflection, serialization, or error reporting
-keepattributes Signature, InnerClasses, *Annotation*
-keep class * implements java.io.Serializable { <fields>; <methods>; }
-keep class * implements android.os.Parcelable { *; }

# =========================================================================
# PROJECT-SPECIFIC RULES (CRITICAL FOR YOUR API)
# =========================================================================

# This rule protects ALL classes within your application's compiled code.
# The ** matches any sub-packages. This is the most important rule 
# to ensure your data models are not stripped.
# The package name is based on your applicationId: com.mo_salah_dj.newsily
-keep class com.mo_salah_dj.newsily.** { *; }

# If you are using a specific networking library (like Dio or http), 
# you might need additional rules, but the above rules cover most common use cases.

# ... (Your existing keep rules for data models go here) ...

# =========================================================================
# R8 FIX: RULES FOR MISSING GOOGLE PLAY CORE CLASSES
# These were generated in build/app/outputs/.../missing_rules.txt
# =========================================================================
-dontwarn com.google.android.play.core.splitcompat.SplitCompatApplication
-dontwarn com.google.android.play.core.splitinstall.SplitInstallException
-dontwarn com.google.android.play.core.splitinstall.SplitInstallManager
-dontwarn com.google.android.play.core.splitinstall.SplitInstallManagerFactory
-dontwarn com.google.android.play.core.splitinstall.SplitInstallRequest$Builder
-dontwarn com.google.android.play.core.splitinstall.SplitInstallRequest
-dontwarn com.google.android.play.core.splitinstall.SplitInstallSessionState
-dontwarn com.google.android.play.core.splitinstall.SplitInstallStateUpdatedListener
-dontwarn com.google.android.play.core.tasks.OnFailureListener
-dontwarn com.google.android.play.core.tasks.OnSuccessListener
-dontwarn com.google.android.play.core.tasks.Task