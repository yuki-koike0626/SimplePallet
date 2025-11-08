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
            Text("ショートカットをカスタマイズ")
                .font(.headline)

            VStack(spacing: 10) {
                // 最大化
                HStack {
                    Spacer()
                    Text("最大化")
                        .frame(width: 80, alignment: .trailing)
                    KeyboardShortcuts.Recorder(for: .maximize)
                        .frame(width: 200, alignment: .leading)
                    Spacer()
                }

                // 左半分
                HStack {
                    Spacer()
                    Text("左半分")
                        .frame(width: 80, alignment: .trailing)
                    KeyboardShortcuts.Recorder(for: .left)
                        .frame(width: 200, alignment: .leading)
                    Spacer()
                }

                // 右半分
                HStack {
                    Spacer()
                    Text("右半分")
                        .frame(width: 80, alignment: .trailing)
                    KeyboardShortcuts.Recorder(for: .right)
                        .frame(width: 200, alignment: .leading)
                    Spacer()
                }
            }

            Divider()
                .padding(.vertical, 4)

            Text("3分割")
                .font(.subheadline)
                .foregroundColor(.secondary)

            VStack(spacing: 10) {
                // 左1/3
                HStack {
                    Spacer()
                    Text("左1/3")
                        .frame(width: 80, alignment: .trailing)
                    KeyboardShortcuts.Recorder(for: .leftThird)
                        .frame(width: 200, alignment: .leading)
                    Spacer()
                }

                // 中央1/3
                HStack {
                    Spacer()
                    Text("中央1/3")
                        .frame(width: 80, alignment: .trailing)
                    KeyboardShortcuts.Recorder(for: .centerThird)
                        .frame(width: 200, alignment: .leading)
                    Spacer()
                }

                // 右1/3
                HStack {
                    Spacer()
                    Text("右1/3")
                        .frame(width: 80, alignment: .trailing)
                    KeyboardShortcuts.Recorder(for: .rightThird)
                        .frame(width: 200, alignment: .leading)
                    Spacer()
                }
            }
        }
    }

    private var generalSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Toggle("ログイン時に自動起動", isOn: $settings.launchAtLogin)
        }
    }

    private var footer: some View {
        VStack(spacing: 5) {
            Text("SimplePallet v1.0")
                .font(.caption)
                .foregroundColor(.secondary)

            Text("© 2025 SimplePallet. All rights reserved.")
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .padding(.bottom)
    }

    // MARK: - アクション

    private func checkPermission() {
        hasPermission = AccessibilityPermission.isGranted()
    }
}

// MARK: - プレビュー

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

