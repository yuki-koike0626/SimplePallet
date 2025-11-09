import SwiftUI
import AppKit

/**
 使い方を表示するモーダル

 ショートカットキーの説明とアプリの推奨使用方法を表示。
 */
struct HowToUseModalView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 24) {
            // ヘッダー
            VStack(alignment: .leading, spacing: 12) {
                Text("howToUse.title", bundle: .main, comment: "How to use title")
                    .font(.title)
                    .fontWeight(.bold)

                Text("howToUse.description", bundle: .main, comment: "App description")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.bottom, 8)

            Divider()

            HStack(alignment: .top, spacing: 16) {
                // 左側: 2分割ショートカットキー
                VStack(alignment: .leading, spacing: 12) {
                    sectionHeader(String(localized: "howToUse.shortcutKeys", bundle: .main, comment: "Shortcut keys section"))

                    shortcutRow(
                        icon: "rectangle.fill",
                        shortcut: "⌘ + ↑",
                        description: String(localized: "action.maximize", bundle: .main, comment: "Maximize action")
                    )

                    shortcutRow(
                        icon: "rectangle.lefthalf.filled",
                        shortcut: "⌘ + ←",
                        description: String(localized: "action.left", bundle: .main, comment: "Left half action")
                    )

                    shortcutRow(
                        icon: "rectangle.righthalf.filled",
                        shortcut: "⌘ + →",
                        description: String(localized: "action.right", bundle: .main, comment: "Right half action")
                    )
                }
                .frame(maxWidth: .infinity)

                // 中央: 3分割の場合
                VStack(alignment: .leading, spacing: 12) {
                    sectionHeader(String(localized: "howToUse.thirdSplit", bundle: .main, comment: "Third split section"))

                    shortcutRow(
                        icon: "rectangle.leadingthird.inset.filled",
                        shortcut: "⌥ + ⌘ + ←",
                        description: String(localized: "action.leftThird", bundle: .main, comment: "Left third action")
                    )

                    shortcutRow(
                        icon: "rectangle.center.inset.filled",
                        shortcut: "⌥ + ⌘ + ↑",
                        description: String(localized: "action.centerThird", bundle: .main, comment: "Center third action")
                    )

                    shortcutRow(
                        icon: "rectangle.trailingthird.inset.filled",
                        shortcut: "⌥ + ⌘ + →",
                        description: String(localized: "action.rightThird", bundle: .main, comment: "Right third action")
                    )
                }
                .frame(maxWidth: .infinity)

                // 右側: アプリ間移動と推奨設定
                VStack(alignment: .leading, spacing: 12) {
                    sectionHeader(String(localized: "howToUse.appSwitching", bundle: .main, comment: "App switching section"))

                    VStack(spacing: 8) {
                        HStack(spacing: 12) {
                            Image(systemName: "rectangle.stack.fill")
                                .font(.title2)
                                .foregroundColor(.blue)
                                .frame(width: 32)

                            VStack(alignment: .leading, spacing: 4) {
                                Text("howToUse.cmdTab", bundle: .main, comment: "Cmd+Tab shortcut")
                                    .font(.system(.callout, design: .monospaced))
                                    .fontWeight(.semibold)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color.secondary.opacity(0.2))
                                    .cornerRadius(6)

                                Text("howToUse.cmdTabDesc", bundle: .main, comment: "Cmd+Tab description")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }

                            Spacer()
                        }
                        .padding(10)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(10)

                        HStack(spacing: 12) {
                            Image(systemName: "minus.circle.fill")
                                .font(.title2)
                                .foregroundColor(.orange)
                                .frame(width: 32)

                            VStack(alignment: .leading, spacing: 4) {
                                Text("howToUse.minimizeDock", bundle: .main, comment: "Minimize dock shortcut")
                                    .font(.system(.callout, design: .monospaced))
                                    .fontWeight(.semibold)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color.secondary.opacity(0.2))
                                    .cornerRadius(6)

                                Text("howToUse.minimizeDockDesc", bundle: .main, comment: "Minimize dock description")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                    .fixedSize(horizontal: false, vertical: true)
                            }

                            Spacer()
                        }
                        .padding(10)
                        .background(Color.orange.opacity(0.1))
                        .cornerRadius(10)

                        HStack(spacing: 12) {
                            Image(systemName: "arrow.up.circle.fill")
                                .font(.title2)
                                .foregroundColor(.green)
                                .frame(width: 32)

                            VStack(alignment: .leading, spacing: 4) {
                                Text("howToUse.cmdTabOption", bundle: .main, comment: "Cmd+Tab+Option shortcut")
                                    .font(.system(.callout, design: .monospaced))
                                    .fontWeight(.semibold)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color.secondary.opacity(0.2))
                                    .cornerRadius(6)

                                Text("howToUse.cmdTabOptionDesc", bundle: .main, comment: "Cmd+Tab+Option description")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                    .fixedSize(horizontal: false, vertical: true)
                            }

                            Spacer()
                        }
                        .padding(10)
                        .background(Color.green.opacity(0.1))
                        .cornerRadius(10)
                    }

                    Spacer()
                        .frame(height: 8)

                    sectionHeader(String(localized: "howToUse.recommendationsTitle", bundle: .main, comment: "Recommendations section"))

                    recommendationRow(
                        icon: "desktopcomputer",
                        title: String(localized: "howToUse.recommendationsSingleDesktop", bundle: .main, comment: "Single desktop recommendation"),
                        description: String(localized: "howToUse.recommendationsSingleDesktopDesc", bundle: .main, comment: "Single desktop description")
                    )

                    recommendationRow(
                        icon: "rectangle.3.group",
                        title: String(localized: "howToUse.appSwitching", bundle: .main, comment: "App switching recommendation"),
                        description: String(localized: "howToUse.appSwitchingDesc", bundle: .main, comment: "App switching description")
                    )
                }
                .frame(maxWidth: .infinity)
            }
            .padding(.horizontal, 4)

            Divider()

            // フッター
            HStack {
                Spacer()

                Button(String(localized: "button.close", bundle: .main, comment: "Close button")) {
                    dismiss()
                }
                .keyboardShortcut(.defaultAction)
                .controlSize(.large)
            }
        }
        .padding(24)
        .frame(width: 900, height: 680)
    }

    // MARK: - Helper Views

    private func sectionHeader(_ title: String) -> some View {
        Text(title)
            .font(.headline)
            .foregroundColor(.primary)
    }

    private func shortcutRow(icon: String, shortcut: String, description: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.green)
                .frame(width: 35)

            VStack(alignment: .leading, spacing: 3) {
                Text(shortcut)
                    .font(.system(.callout, design: .monospaced))
                    .fontWeight(.semibold)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.secondary.opacity(0.2))
                    .cornerRadius(6)

                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()
        }
        .padding(12)
        .background(Color.secondary.opacity(0.1))
        .cornerRadius(10)
    }

    private func recommendationRow(icon: String, title: String, description: String) -> some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.orange)
                .frame(width: 28)

            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.caption)
                    .fontWeight(.semibold)

                Text(description)
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer()
        }
        .padding(10)
        .background(Color.orange.opacity(0.1))
        .cornerRadius(10)
    }
}

/**
 使い方モーダルのマネージャー

 モーダルウィンドウを管理し、表示・非表示を制御。
 */
class HowToUseModalManager {
    static let shared = HowToUseModalManager()

    private var modalWindow: NSWindow?

    private init() {}

    /**
     使い方モーダルを表示
     */
    func show() {
        // 既存のウィンドウがあれば閉じる
        modalWindow?.close()
        modalWindow = nil

        // SwiftUI ビューを作成
        let modalView = HowToUseModalView()
        let hostingController = NSHostingController(rootView: modalView)

        // ウィンドウを作成
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 900, height: 680),
            styleMask: [.titled, .closable, .fullSizeContentView],
            backing: .buffered,
            defer: false
        )

        window.contentViewController = hostingController
        window.title = String(localized: "window.howToUse", bundle: .main, comment: "How to use window title")
        window.center()
        window.level = .floating
        window.isReleasedWhenClosed = false
        window.titlebarAppearsTransparent = true

        // ウィンドウを表示
        window.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)

        modalWindow = window
    }
}

// MARK: - プレビュー

struct HowToUseModalView_Previews: PreviewProvider {
    static var previews: some View {
        HowToUseModalView()
    }
}
