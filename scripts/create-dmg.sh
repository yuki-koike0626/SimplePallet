#!/bin/bash

# SimplePallet DMG作成スクリプト
# このスクリプトは、アプリのDMGファイルを作成します
#
# 使用方法:
#   ./scripts/create-dmg.sh

set -e

# 色付きログ
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}SimplePallet DMG作成スクリプト${NC}"
echo ""

# 変数設定
APP_NAME="SimplePallet"
VERSION="1.0"
BUNDLE_PATH="./build/SimplePallet.app"
DMG_NAME="${APP_NAME}-${VERSION}.dmg"
DMG_PATH="./dist/${DMG_NAME}"
VOLUME_NAME="${APP_NAME}"
TEMP_DMG="temp.dmg"

# ディレクトリ作成
mkdir -p dist
mkdir -p temp_dmg

# 既存のDMGを削除
if [ -f "$DMG_PATH" ]; then
    echo -e "${BLUE}既存のDMGを削除中...${NC}"
    rm "$DMG_PATH"
fi

# アプリがビルドされているか確認
if [ ! -d "$BUNDLE_PATH" ]; then
    echo -e "${RED}エラー: ${BUNDLE_PATH} が見つかりません${NC}"
    echo "先にXcodeでアプリをビルドしてください（Product > Archive）"
    exit 1
fi

echo -e "${BLUE}アプリをコピー中...${NC}"
cp -R "$BUNDLE_PATH" temp_dmg/

echo -e "${BLUE}アプリケーションフォルダへのシンボリックリンクを作成中...${NC}"
ln -s /Applications temp_dmg/Applications

echo -e "${BLUE}DMGを作成中...${NC}"

# 一時的なDMGを作成
hdiutil create -srcfolder temp_dmg -volname "$VOLUME_NAME" -fs HFS+ \
    -fsargs "-c c=64,a=16,e=16" -format UDRW -size 100m "$TEMP_DMG"

# DMGをマウント
echo -e "${BLUE}DMGをマウント中...${NC}"
MOUNT_OUTPUT=$(hdiutil attach -readwrite -noverify -noautoopen "$TEMP_DMG")
MOUNT_DIR=$(echo "$MOUNT_OUTPUT" | grep "/Volumes/" | awk '{$1=$2=""; print $0}' | xargs)

echo "マウント先: $MOUNT_DIR"

# マウント失敗チェック
if [ -z "$MOUNT_DIR" ]; then
    echo -e "${RED}エラー: DMGのマウントに失敗しました${NC}"
    echo "$MOUNT_OUTPUT"
    exit 1
fi

# アイコン位置とウィンドウ設定（AppleScript）
echo -e "${BLUE}ウィンドウレイアウトを設定中...${NC}"
osascript <<EOF
tell application "Finder"
    tell disk "$VOLUME_NAME"
        open
        set current view of container window to icon view
        set toolbar visible of container window to false
        set statusbar visible of container window to false
        set the bounds of container window to {100, 100, 650, 450}
        set viewOptions to the icon view options of container window
        set arrangement of viewOptions to not arranged
        set icon size of viewOptions to 100
        set position of item "${APP_NAME}.app" of container window to {150, 150}
        set position of item "Applications" of container window to {400, 150}
        close
        open
        update without registering applications
        delay 2
    end tell
end tell
EOF

# アンマウント
echo -e "${BLUE}DMGをアンマウント中...${NC}"
hdiutil detach "$MOUNT_DIR"

# 圧縮してファイナルDMGを作成
echo -e "${BLUE}最終DMGを圧縮中...${NC}"
hdiutil convert "$TEMP_DMG" -format UDZO -imagekey zlib-level=9 -o "$DMG_PATH"

# 一時ファイルを削除
echo -e "${BLUE}一時ファイルを削除中...${NC}"
rm -f "$TEMP_DMG"
rm -rf temp_dmg

echo -e "${BLUE}DMGに署名中...${NC}"
codesign --sign "Developer ID Application: Yuki Koike (9552ZD2XMV)" --timestamp "$DMG_PATH"

echo ""
echo -e "${GREEN}✅ DMG作成完了！${NC}"
echo -e "${GREEN}ファイル: ${DMG_PATH}${NC}"
echo ""
echo "次のステップ:"
echo "1. Developer IDで署名: codesign --sign 'Developer ID Application' ${DMG_PATH}"
echo "2. 公証（notarization）を実行"
echo "3. GitHub Releasesにアップロード"

