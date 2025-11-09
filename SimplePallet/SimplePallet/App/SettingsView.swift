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
    @State private var saveFeedback: SaveFeedback?
    @State private var feedbackDismissWorkItem: DispatchWorkItem?

    var body: some View {
        VStack(spacing: 20) {
            // ヘッダー
            Text("settings.title", bundle: .main, comment: "Settings title")
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
            Text("settings.accessibility", bundle: .main, comment: "Accessibility permission section")
                .font(.headline)

            HStack {
                Image(systemName: hasPermission ? "checkmark.circle.fill" : "xmark.circle.fill")
                    .foregroundColor(hasPermission ? .green : .red)

                Text(hasPermission ? String(localized: "settings.permissionGranted", bundle: .main, comment: "Permission granted") : String(localized: "settings.permissionRequired", bundle: .main, comment: "Permission required"))
                    .foregroundColor(.secondary)

                Spacer()

                if !hasPermission {
                    Button(String(localized: "button.openSettings", bundle: .main, comment: "Open settings button")) {
                        AccessibilityPermission.openSystemPreferences()
                    }

                    Button(String(localized: "button.checkAgain", bundle: .main, comment: "Check again button")) {
                        checkPermission()
                    }
                }
            }

            if !hasPermission {
                Text("settings.accessibilityDescription", bundle: .main, comment: "Accessibility description")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }

    private var shortcutSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("settings.customizeShortcuts", bundle: .main, comment: "Customize shortcuts section")
                .font(.headline)

            VStack(spacing: 10) {
                // 最大化
                HStack {
                    Spacer()
                    Text("action.maximize", bundle: .main, comment: "Maximize action")
                        .frame(width: 80, alignment: .trailing)
                    KeyboardShortcuts.Recorder(for: .maximize)
                        .frame(width: 200, alignment: .leading)
                    Spacer()
                }

                // 左半分
                HStack {
                    Spacer()
                    Text("action.left", bundle: .main, comment: "Left half action")
                        .frame(width: 80, alignment: .trailing)
                    KeyboardShortcuts.Recorder(for: .left)
                        .frame(width: 200, alignment: .leading)
                    Spacer()
                }

                // 右半分
                HStack {
                    Spacer()
                    Text("action.right", bundle: .main, comment: "Right half action")
                        .frame(width: 80, alignment: .trailing)
                    KeyboardShortcuts.Recorder(for: .right)
                        .frame(width: 200, alignment: .leading)
                    Spacer()
                }
            }

            Divider()
                .padding(.vertical, 4)

            Text("settings.thirdSplit", bundle: .main, comment: "Third split section")
                .font(.subheadline)
                .foregroundColor(.secondary)

            VStack(spacing: 10) {
                // 左1/3
                HStack {
                    Spacer()
                    Text("action.leftThird", bundle: .main, comment: "Left third action")
                        .frame(width: 80, alignment: .trailing)
                    KeyboardShortcuts.Recorder(for: .leftThird)
                        .frame(width: 200, alignment: .leading)
                    Spacer()
                }

                // 中央1/3
                HStack {
                    Spacer()
                    Text("action.centerThird", bundle: .main, comment: "Center third action")
                        .frame(width: 80, alignment: .trailing)
                    KeyboardShortcuts.Recorder(for: .centerThird)
                        .frame(width: 200, alignment: .leading)
                    Spacer()
                }

                // 右1/3
                HStack {
                    Spacer()
                    Text("action.rightThird", bundle: .main, comment: "Right third action")
                        .frame(width: 80, alignment: .trailing)
                    KeyboardShortcuts.Recorder(for: .rightThird)
                        .frame(width: 200, alignment: .leading)
                    Spacer()
                }
            }
        }
    }

    private var generalSection: some View {
        VStack(alignment: .center, spacing: 12) {
            Toggle(String(localized: "settings.launchAtLogin", bundle: .main, comment: "Launch at login toggle"), isOn: $settings.launchAtLogin)

            Button(String(localized: "button.save", bundle: .main, comment: "Save button")) {
                saveSettings()
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.regular)

            if let feedback = saveFeedback {
                HStack(spacing: 6) {
                    Image(systemName: feedback.iconName)
                        .foregroundColor(feedback.color)
                    Text(feedback.message)
                        .font(.caption)
                        .foregroundColor(feedback.color)
                }
                .transition(.opacity)
            }
        }
    }

    private var footer: some View {
        VStack(spacing: 5) {
            Text("app.version", bundle: .main, comment: "App version")
                .font(.caption)
                .foregroundColor(.secondary)

            Text("app.copyright", bundle: .main, comment: "Copyright")
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .padding(.bottom)
    }

    // MARK: - アクション

    private func saveSettings() {
        // 既存のタイマーをキャンセル
        feedbackDismissWorkItem?.cancel()

        do {
            try settings.saveSettings()
            withAnimation(.easeInOut(duration: 0.2)) {
                saveFeedback = .success
            }
        } catch {
            withAnimation(.easeInOut(duration: 0.2)) {
                saveFeedback = .failure(error.localizedDescription)
            }
        }

        // 2.5秒後にフィードバックを消す
        let workItem = DispatchWorkItem {
            withAnimation(.easeInOut(duration: 0.2)) {
                saveFeedback = nil
            }
        }
        feedbackDismissWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: workItem)
    }

    private func checkPermission() {
        hasPermission = AccessibilityPermission.isGranted()
    }

    // MARK: - フィードバック

    private enum SaveFeedback {
        case success
        case failure(String)

        var message: String {
            switch self {
            case .success:
                return String(localized: "settings.saveSuccess", bundle: .main, comment: "Save success message")
            case .failure(let error):
                return String(localized: "settings.saveFailed", bundle: .main, comment: "Save failed message").replacingOccurrences(of: "%@", with: error)
            }
        }

        var color: Color {
            switch self {
            case .success:
                return .green
            case .failure:
                return .red
            }
        }

        var iconName: String {
            switch self {
            case .success:
                return "checkmark.circle.fill"
            case .failure:
                return "exclamationmark.triangle.fill"
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

