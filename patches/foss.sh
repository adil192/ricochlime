echo "Removing google_mobile_ads package"
sed -i -e '/google_mobile_ads/d' pubspec.yaml

echo "Replacing ads with dummy widgets"
mv lib/ads/_ads_foss.dart lib/ads/ads.dart

echo "Removing AD_ID permission"
sed -i -e '/com.google.android.gms.permission.AD_ID/d' android/app/src/main/AndroidManifest.xml

echo "Removing internet permission"
sed -i -e '/android.permission.INTERNET/d' android/app/src/main/AndroidManifest.xml
