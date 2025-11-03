#!/bin/bash

echo "🔍 macOS のキーボードショートカット設定を確認"
echo ""
echo "Mission Control のショートカット設定："
echo ""

# Mission Control のショートカット設定を確認
defaults read com.apple.symbolichotkeys 2>/dev/null | grep -A 5 "32\|33\|34\|79\|80\|81" | head -30

echo ""
echo "📋 次のステップ："
echo "1. システム設定 → キーボード → キーボードショートカット"
echo "2. 「Mission Control」を選択"
echo "3. 以下のショートカットを確認・無効化："
echo "   - 「ウインドウを画面左側に移動」"
echo "   - 「ウインドウを画面右側に移動」"
echo "   - その他 ⌘+矢印 を使用している項目"
echo ""

