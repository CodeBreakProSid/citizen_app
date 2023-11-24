##---------------------------vconsol ----------------------
-keep class * extends androidx.fragment.app.Fragment{}
-keepnames class * extends android.os.Parcelable
-keepnames class * extends java.io.Serializable
#-keepnames class * implements java.io.Serializable
#-keepnames class * implements android.os.Parcelable

-keep public class org.citizen.janamaithri.entity.** { *; }
-keep public class com.tst.core.** { *; }
-keep class org.webrtc.** { *; }