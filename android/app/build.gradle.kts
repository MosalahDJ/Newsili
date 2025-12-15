import java.io.File
import java.io.FileInputStream
import java.util.Properties

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// Load Keystore Properties
val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")

if (keystorePropertiesFile.exists()) {
    FileInputStream(keystorePropertiesFile).use { keystoreProperties.load(it) }
}


android {
    namespace = "com.mo_salah_dj.newsily"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.mo_salah_dj.newsily"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") {
            // Use 'get' operator and cast to String for properties from the Properties object
            storeFile = File(keystoreProperties.getProperty("storeFile") ?: throw Exception("storeFile not set in key.properties"))
            storePassword = keystoreProperties.getProperty("storePassword")
                ?: throw Exception("storePassword not set in key.properties")
            keyAlias = keystoreProperties.getProperty("keyAlias")
                ?: throw Exception("keyAlias not set in key.properties")
            keyPassword = keystoreProperties.getProperty("keyPassword")
                ?: throw Exception("keyPassword not set in key.properties")
        }
    }

    buildTypes {
        getByName("release") {
            // Apply the signing config defined above
            signingConfig = signingConfigs.getByName("release")
            
            // ProGuard/R8 settings (using Kotlin property syntax)
            isMinifyEnabled = true
            isShrinkResources = true
            
            // Use 'setProguardFiles' for the correct Kotlin function signature
            setProguardFiles(listOf(
                getDefaultProguardFile("proguard-android-optimize.txt"), 
                "proguard-rules.pro"
            ))
        }
    }
}

flutter {
    source = "../.."
}