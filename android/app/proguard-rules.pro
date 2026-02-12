# Flutter and Android keep rules
-keep class io.flutter.app.** { *; }
-keep class io.flutter.embedding.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.FlutterInjector { *; }
-keep class io.flutter.plugins.GeneratedPluginRegistrant { *; }

# Keep Gson/JSON models if reflection is used
-keepclassmembers class ** {
    @com.google.gson.annotations.SerializedName <fields>;
}

# OkHttp and WebSocket
-dontwarn okhttp3.**
-dontwarn okio.**

# Dio uses reflection for some types in debug; keep warnings quiet
-dontwarn retrofit2.**
