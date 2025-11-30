#!/bin/bash
set -e

APP_PATH="build/SimplePallet.app"
CERT_ID="Developer ID Application: Yuki Koike (9552ZD2XMV)"
ENTITLEMENTS="entitlements.plist"

echo "Using certificate: $CERT_ID"
echo "Re-signing Sparkle components..."

# Sign inside out

# 1. Sparkle XPC Services
codesign -f -o runtime --timestamp --sign "$CERT_ID" "$APP_PATH/Contents/Frameworks/Sparkle.framework/Versions/B/XPCServices/Downloader.xpc"
codesign -f -o runtime --timestamp --sign "$CERT_ID" "$APP_PATH/Contents/Frameworks/Sparkle.framework/Versions/B/XPCServices/Installer.xpc"

# 2. Sparkle Updater App
codesign -f -o runtime --timestamp --sign "$CERT_ID" "$APP_PATH/Contents/Frameworks/Sparkle.framework/Versions/B/Updater.app"

# 3. Sparkle Autoupdate Tool
codesign -f -o runtime --timestamp --sign "$CERT_ID" "$APP_PATH/Contents/Frameworks/Sparkle.framework/Versions/B/Autoupdate"

# 4. Sparkle Framework itself
codesign -f -o runtime --timestamp --sign "$CERT_ID" "$APP_PATH/Contents/Frameworks/Sparkle.framework"

echo "Re-signing main application..."
# 5. Main Application
codesign -f -o runtime --timestamp --entitlements "$ENTITLEMENTS" --sign "$CERT_ID" "$APP_PATH"

echo "Verifying signature..."
codesign -dv --verbose=4 "$APP_PATH"
spctl --assess --type execute --verbose --ignore-cache --no-cache "$APP_PATH"

echo "Done!"

