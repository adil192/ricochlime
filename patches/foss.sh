echo "Removing in_app_purchase package"
sed -i -e '/in_app_purchase/d' pubspec.yaml

echo "Replacing iaps with dummy class"
mv lib/ads/_iap_foss.dart lib/ads/iap.dart

echo "Removing internet permission"
sed -i -e '/android.permission.INTERNET/d' android/app/src/main/AndroidManifest.xml
