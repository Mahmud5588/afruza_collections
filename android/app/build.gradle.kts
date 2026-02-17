import java.io.FileInputStream
import java.util.Properties

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// ✅ 1) key.properties ni android{} dan tashqarida o‘qiymiz
val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    namespace = "com.afruza.collection"
    compileSdk = flutter.compileSdkVersion
    // ndkVersion removed - let Gradle auto-detect

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
        languageVersion = "1.8"
        apiVersion = "1.8"
    }

    defaultConfig {
        applicationId = "com.afruza.collection"
        minSdk = flutter.minSdkVersion
        // Google Play requires API level 35+ (Android 15)
        targetSdk = 35
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    // ✅ 2) signingConfigs faqat android{} ichida bo‘ladi
    signingConfigs {
        create("release") {
            if (keystorePropertiesFile.exists()) {
                keyAlias = keystoreProperties["keyAlias"] as String
                keyPassword = keystoreProperties["keyPassword"] as String
                storeFile = file(keystoreProperties["storeFile"] as String)
                storePassword = keystoreProperties["storePassword"] as String
            }
        }
    }

    buildTypes {
        release {
            // ✅ 3) key.properties bo‘lsa release, bo‘lmasa debug
            signingConfig = if (keystorePropertiesFile.exists()) {
                signingConfigs.getByName("release")
            } else {
                signingConfigs.getByName("debug")
            }

            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro",
            )
        }
    }

    // Disable symbol stripping completely
    packagingOptions {
        jniLibs {
            useLegacyPackaging = false
            // Don't strip native libraries
            excludes += setOf()
        }
        // Keep debug symbols
        resources {
            excludes += setOf("META-INF/*.kotlin_module")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // No additional dependencies needed
    // Flutter plugins will add their own dependencies automatically
}
