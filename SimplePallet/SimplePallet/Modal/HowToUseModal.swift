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
                Text("Simple Pallet の使い方")
                    .font(.title)
                    .fontWeight(.bold)

                Text("SimplePalletとは、macOS向けのシンプルなウィンドウ管理アプリです。キーボードショートカットで最前面ウィンドウを「最大化 / 2分割 / 3分割」に瞬間的に切り替えることができます。")
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
                    sectionHeader("ショートカットキー(デフォルト)")

                    shortcutRow(
                        icon: "rectangle.fill",
                        shortcut: "⌘ + ↑",
                        description: "最大化"
                    )

                    shortcutRow(
                        icon: "rectangle.lefthalf.filled",
                        shortcut: "⌘ + ←",
                        description: "左半分"
                    )

                    shortcutRow(
                        icon: "rectangle.righthalf.filled",
                        shortcut: "⌘ + →",
                        description: "右半分"
                    )
                }
                .frame(maxWidth: .infinity)

                // 中央: 3分割の場合
                VStack(alignment: .leading, spacing: 12) {
                    sectionHeader("3分割の場合(デフォルト)")

                    shortcutRow(
                        icon: "rectangle.leadingthird.inset.filled",
                        shortcut: "⌥ + ⌘ + ←",
                        description: "左1/3"
                    )

                    shortcutRow(
                        icon: "rectangle.center.inset.filled",
                        shortcut: "⌥ + ⌘ + ↑",
                        description: "中央1/3"
                    )

                    shortcutRow(
                        icon: "rectangle.trailingthird.inset.filled",
                        shortcut: "⌥ + ⌘ + →",
                        description: "右1/3"
                    )
                }
                .frame(maxWidth: .infinity)

                // 右側: アプリ間移動と推奨設定
                VStack(alignment: .leading, spacing: 12) {
                    sectionHeader("アプリ間移動")

                    HStack(spacing: 12) {
                        Image(systemName: "rectangle.stack.fill")
                            .font(.title)
                            .foregroundColor(.blue)
                            .frame(width: 40)

                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text("⌘ + Tab")
                                    .font(.system(.body, design: .monospaced))
                                    .fontWeight(.semibold)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color.secondary.opacity(0.2))
                                    .cornerRadius(6)

                                Text("で切り替え")
                                    .foregroundColor(.primary)
                                    .font(.caption)
                            }

                            Text("アプリを素早く移動")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }

                        Spacer()
                    }
                    .padding(12)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(12)

                    Spacer()
                        .frame(height: 8)

                    sectionHeader("推奨設定")

                    recommendationRow(
                        icon: "desktopcomputer",
                        title: "デスクトップは一つだけ",
                        description: "複数デスクトップを使わず、一つのデスクトップで作業"
                    )

                    recommendationRow(
                        icon: "rectangle.3.group",
                        title: "アプリ間移動を活用",
                        description: "⌘+Tab でアプリを切り替えて効率的にウィンドウを管理"
                    )
                }
                .frame(maxWidth: .infinity)
            }
            .padding(.horizontal, 4)

            Divider()

            // フッター
            HStack {
                Spacer()

                Button("閉じる") {
                    dismiss()
                }
                .keyboardShortcut(.defaultAction)
                .controlSize(.large)
            }
        }
        .padding(24)
        .frame(width: 900, height: 600)
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
            contentRect: NSRect(x: 0, y: 0, width: 900, height: 600),
            styleMask: [.titled, .closable, .fullSizeContentView],
            backing: .buffered,
            defer: false
        )

        window.contentViewController = hostingController
        window.title = "使い方"
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
