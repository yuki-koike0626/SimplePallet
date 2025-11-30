import sys
import base64
import subprocess

# ファイルパス
dmg_path = "dist/SimplePallet-1.0.dmg"
priv_key_path = "sparkle_private_key.pem"

# 1. ファイルサイズを取得
import os
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

