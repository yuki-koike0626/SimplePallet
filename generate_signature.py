import sys
import base64
import subprocess
import os
import argparse

# 引数解析
parser = argparse.ArgumentParser(description='Generate Sparkle signature.')
parser.add_argument('--dmg', default="dist/SimplePallet-1.0.dmg", help='Path to DMG file')
parser.add_argument('--key', default="../SimplePallet-Source/sparkle_private_key.pem", help='Path to private key')
args = parser.parse_args()

dmg_path = args.dmg
priv_key_path = args.key

# 鍵ファイルの存在確認
if not os.path.exists(priv_key_path):
    # カレントディレクトリも探してみる
    if os.path.exists("sparkle_private_key.pem"):
        priv_key_path = "sparkle_private_key.pem"
    else:
        print(f"Error: Private key not found at {priv_key_path}")
        print("Please provide the correct path using --key argument or move the key to ../SimplePallet-Source/")
        sys.exit(1)

# DMGファイルの存在確認
if not os.path.exists(dmg_path):
    print(f"Error: DMG file not found at {dmg_path}")
    sys.exit(1)

# 1. ファイルサイズを取得
file_size = os.path.getsize(dmg_path)
print(f"File size: {file_size}")

# 2. 秘密鍵を読み込む
with open(priv_key_path, "r") as f:
    priv_key_pem = f.read()

# 3. 署名を生成（opensslを使用）
# まずDMGのデータを読み込む
with open(dmg_path, "rb") as f:
    dmg_data = f.read()

# openssl pkeyutl を使って署名
# 注意: これは簡易的な方法です。本来は sign_update ツール推奨ですが、
# 手元にツールがないため、openssl で代用を試みます。
try:
    proc = subprocess.run(
        ["openssl", "pkeyutl", "-sign", "-inkey", priv_key_path, "-rawin", "-in", dmg_path],
        capture_output=True,
        check=True
    )
    signature = proc.stdout
    signature_base64 = base64.b64encode(signature).decode('utf-8')
    print(f"Signature: {signature_base64}")
except subprocess.CalledProcessError as e:
    print(f"Error signing: {e}")
    print(e.stderr)
