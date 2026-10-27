# Keep ML Kit text-recognition classes referenced reflectively by
# google_mlkit_text_recognition; R8 otherwise strips the script-specific
# recognizer options and the release build fails with missing classes.
-keep class com.google.mlkit.vision.text.** { *; }
-dontwarn com.google.mlkit.vision.text.**
