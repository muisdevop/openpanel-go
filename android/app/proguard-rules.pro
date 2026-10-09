# The Flutter engine and plugin registration are reached through JNI and method
# channels, i.e. by class/method name, so R8 must not rename or strip them.
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# flutter_secure_storage resolves EncryptedSharedPreferences and its key
# providers reflectively, and behaviour differs across OEM keystore builds.
-keep class androidx.security.crypto.** { *; }
-dontwarn javax.crypto.**
-dontwarn org.json.**

# Flutter's deferred-components glue (io.flutter.embedding.engine.deferredcomponents.
# PlayStoreDeferredComponentManager) is compiled against Play Core, which is not on
# the classpath because this app ships one plain APK rather than split APKs. With
# minification on, R8 treats those unresolvable references as a hard error and
# `flutter build apk --release` fails. These are the rules AGP itself writes to
# build/app/outputs/mapping/release/missing_rules.txt.
-dontwarn com.google.android.play.core.**
