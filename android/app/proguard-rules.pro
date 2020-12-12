-keepclassmembers class * {
    @android.webkit.JavascriptInterface <methods>;
}

-keepattributes JavascriptInterface
-keepattributes *Annotation*

-dontwarn com.razorpay.**
-keep class com.razorpay.** {*;}

-optimizations !method/inlining/*

-keepclasseswithmembers class * {
  public void onPayment*(...);
}
-keep class com.google.**{*;}
-keepclassmembers class * implements java.io.Serializable { *; } #or -keep class com.baseflow.permissionhandler.** { *; }