import SwiftUI
import KeyboardShortcuts

/**
 設定画面のメインビュー

 ショートカットの変更、権限の確認、自動起動の設定を提供。
 KeyboardShortcutsライブラリの標準UIを使用。
 */
struct SettingsView: View {
    @ObservedObject private var settings = AppSettings.shared
    @ObservedObject private var languageManager = LanguageManager.shared
    @State private var hasPermission = AccessibilityPermission.isGranted()
    @State private var saveFeedback: SaveFeedback?
    @State private var feedbackDismissWorkItem: DispatchWorkItem?
    @State private var refreshID = UUID()

    var body: some View {
        VStack(spacing: 20) {
            // ヘッダー
            LText("settings.title")
                .font(.title)
                .padding(.top)

            // アクセシビリティ権限セクション
            permissionSection

            Divider()

            // 言語設定セクション
            languageSection

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
        .frame(width: 500)
        .fixedSize(horizontal: false, vertical: true)
        .id(refreshID)
        .onAppear {
            checkPermission()
        }
        .onReceive(languageManager.languageDidChange) { _ in
            // 言語変更時にビュー全体を再描画
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                refreshID = UUID()
            }
        }
    }

    // MARK: - セクション

    private var permissionSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            LText("settings.accessibility")
                .font(.headline)

            HStack {
                Image(systemName: hasPermission ? "checkmark.circle.fill" : "xmark.circle.fill")
                    .foregroundColor(hasPermission ? .green : .red)

                Text(hasPermission ? L("settings.permissionGranted") : L("settings.permissionRequired"))
                    .foregroundColor(.secondary)

                Spacer()

                if !hasPermission {
                    Button(L("button.openSettings")) {
                        AccessibilityPermission.openSystemPreferences()
                    }

                    Button(L("button.checkAgain")) {
                        checkPermission()
                    }
                }
            }

            if !hasPermission {
                LText("settings.accessibilityDescription")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }

    private var shortcutSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            LText("settings.customizeShortcuts")
                .font(.headline)

            VStack(spacing: 10) {
                // 最大化
                HStack {
                    Spacer()
                    LText("action.maximize")
                        .frame(width: 80, alignment: .trailing)
                    KeyboardShortcuts.Recorder(for: .maximize)
                        .frame(width: 200, alignment: .leading)
                    Spacer()
                }

                // 左半分
                HStack {
                    Spacer()
                    LText("action.left")
                        .frame(width: 80, alignment: .trailing)
                    KeyboardShortcuts.Recorder(for: .left)
                        .frame(width: 200, alignment: .leading)
                    Spacer()
                }

                // 右半分
                HStack {
                    Spacer()
                    LText("action.right")
                        .frame(width: 80, alignment: .trailing)
                    KeyboardShortcuts.Recorder(for: .right)
                        .frame(width: 200, alignment: .leading)
                    Spacer()
                }
            }

            Divider()
                .padding(.vertical, 4)

            LText("settings.thirdSplit")
                .font(.subheadline)
                .foregroundColor(.secondary)

            VStack(spacing: 10) {
                // 左1/3
                HStack {
                    Spacer()
                    LText("action.leftThird")
                        .frame(width: 80, alignment: .trailing)
                    KeyboardShortcuts.Recorder(for: .leftThird)
                        .frame(width: 200, alignment: .leading)
                    Spacer()
                }

                // 中央1/3
                HStack {
                    Spacer()
                    LText("action.centerThird")
                        .frame(width: 80, alignment: .trailing)
                    KeyboardShortcuts.Recorder(for: .centerThird)
                        .frame(width: 200, alignment: .leading)
                    Spacer()
                }

                // 右1/3
                HStack {
                    Spacer()
                    LText("action.rightThird")
                        .frame(width: 80, alignment: .trailing)
                    KeyboardShortcuts.Recorder(for: .rightThird)
                        .frame(width: 200, alignment: .leading)
                    Spacer()
                }
            }
        }
    }

    private var languageSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            LText("settings.language")
                .font(.headline)

            HStack {
                Spacer()

                Picker("", selection: Binding(
                    get: { languageManager.currentLanguage },
                    set: { languageManager.changeLanguage($0) }
                )) {
                    ForEach(AppLanguage.allCases, id: \.self) { language in
                        Text(language.displayName)
                            .tag(language)
                    }
                }
                .pickerStyle(.menu)
                .frame(width: 200)

                Spacer()
            }

            LText("settings.languageDescription")
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
        }
    }

    private var generalSection: some View {
        VStack(alignment: .center, spacing: 12) {
            Toggle(L("settings.launchAtLogin"), isOn: $settings.launchAtLogin)

            Button(L("button.save")) {
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
            LText("app.version")
                .font(.caption)
                .foregroundColor(.secondary)

            LText("app.copyright")
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
                return L("settings.saveSuccess")
            case .failure(let error):
                return L("settings.saveFailed").replacingOccurrences(of: "%@", with: error)
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

