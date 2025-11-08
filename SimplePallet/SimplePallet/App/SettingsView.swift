import SwiftUI
import KeyboardShortcuts

/**
 設定画面のメインビュー

 ショートカットの変更、権限の確認、自動起動の設定を提供。
 KeyboardShortcutsライブラリの標準UIを使用。
 */
struct SettingsView: View {
    @ObservedObject private var settings = AppSettings.shared
    @State private var hasPermission = AccessibilityPermission.isGranted()
    @State private var showSavedMessage = false

    var body: some View {
        VStack(spacing: 20) {
            // ヘッダー
            Text("SimplePallet 設定")
                .font(.title)
                .padding(.top)

            // アクセシビリティ権限セクション
            permissionSection

            Divider()

            // ショートカット設定セクション
            shortcutSection

            Divider()

            // 一般設定セクション
            generalSection

            Spacer()

            // 保存ボタン
            saveButton

            // フッター
            footer
        }
        .padding()
        .frame(width: 500, height: 600)
        .onAppear {
            checkPermission()
        }
    }

    // MARK: - セクション

    private var permissionSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("アクセシビリティ権限")
                .font(.headline)

            HStack {
                Image(systemName: hasPermission ? "checkmark.circle.fill" : "xmark.circle.fill")
                    .foregroundColor(hasPermission ? .green : .red)

                Text(hasPermission ? "許可されています" : "権限が必要です")
                    .foregroundColor(.secondary)

                Spacer()

                if !hasPermission {
                    Button("設定を開く") {
                        AccessibilityPermission.openSystemPreferences()
                    }

                    Button("再確認") {
                        checkPermission()
                    }
                }
            }

            if !hasPermission {
                Text("ウィンドウを操作するには、システム環境設定でアクセシビリティ権限を許可してください。")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }

    private var shortcutSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("ショートカット")
                .font(.headline)

            Text("KeyboardShortcutsライブラリが提供する標準UIでショートカットを設定できます。")
                .font(.caption)
                .foregroundColor(.secondary)

            // 2分割
            Text("2分割")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .padding(.top, 4)

            // 最大化
            HStack {
                Text("最大化")
                    .frame(width: 80, alignment: .leading)
                KeyboardShortcuts.Recorder(for: .maximize)
            }

            // 左半分
            HStack {
                Text("左半分")
                    .frame(width: 80, alignment: .leading)
                KeyboardShortcuts.Recorder(for: .left)
            }

            // 右半分
            HStack {
                Text("右半分")
                    .frame(width: 80, alignment: .leading)
                KeyboardShortcuts.Recorder(for: .right)
            }

            // 3分割
            Text("3分割")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .padding(.top, 8)

            // 左1/3
            HStack {
                Text("左1/3")
                    .frame(width: 80, alignment: .leading)
                KeyboardShortcuts.Recorder(for: .leftThird)
            }

            // 中央1/3
            HStack {
                Text("中央1/3")
                    .frame(width: 80, alignment: .leading)
                KeyboardShortcuts.Recorder(for: .centerThird)
            }

            // 右1/3
            HStack {
                Text("右1/3")
                    .frame(width: 80, alignment: .leading)
                KeyboardShortcuts.Recorder(for: .rightThird)
            }
        }
    }

    private var generalSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("一般")
                .font(.headline)

            Toggle("ログイン時に自動起動", isOn: $settings.launchAtLogin)
        }
    }

    private var saveButton: some View {
        VStack(spacing: 8) {
            Button(action: {
                saveSettings()
            }) {
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                    Text("この設定で保存する")
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)

            if showSavedMessage {
                HStack(spacing: 6) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                        .font(.caption)
                    Text("設定を保存しました")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .transition(.opacity)
            }
        }
    }

    private var footer: some View {
        VStack(spacing: 5) {
            Text("SimplePallet v1.0")
                .font(.caption)
                .foregroundColor(.secondary)

            Text("© 2025 Yuki. All rights reserved.")
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .padding(.bottom)
    }

    // MARK: - アクション

    private func checkPermission() {
        hasPermission = AccessibilityPermission.isGranted()
    }

    private func saveSettings() {
        // 設定は既にリアルタイムで保存されているため、
        // ここではユーザーに保存完了を通知するだけ
        withAnimation {
            showSavedMessage = true
        }

        // 2秒後にメッセージを非表示
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                showSavedMessage = false
            }
        }
    }
}

// MARK: - プレビュー

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

