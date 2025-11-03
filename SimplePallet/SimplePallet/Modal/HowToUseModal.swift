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
            HStack {
                Text("Simple palet の使い方")
                    .font(.title)
                    .fontWeight(.bold)

                Spacer()

                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title2)
                        .foregroundColor(.secondary)
                }
                .buttonStyle(.plain)
            }
            .padding(.bottom, 8)

            Divider()

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // ショートカットキー
                    sectionHeader("ショートカットキー")

                    shortcutRow(
                        icon: "arrow.up.square.fill",
                        shortcut: "⌘ + ↑",
                        description: "最大化"
                    )

                    shortcutRow(
                        icon: "arrow.left.square.fill",
                        shortcut: "⌘ + ←",
                        description: "左半分"
                    )

                    shortcutRow(
                        icon: "arrow.right.square.fill",
                        shortcut: "⌘ + →",
                        description: "右半分"
                    )

                    Divider()
                        .padding(.vertical, 8)

                    // アプリ間移動
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

                                Text("でアプリを切り替え")
                                    .foregroundColor(.primary)
                            }

                            Text("ウィンドウ間を素早く移動できます")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding()
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(12)

                    Divider()
                        .padding(.vertical, 8)

                    // 推奨設定
                    sectionHeader("推奨設定")

                    VStack(alignment: .leading, spacing: 12) {
                        recommendationRow(
                            icon: "desktopcomputer",
                            title: "デスクトップは一つだけ",
                            description: "Mission Control で複数デスクトップを使わず、一つのデスクトップで作業するとウィンドウ管理が簡単になります"
                        )

                        recommendationRow(
                            icon: "rectangle.3.group",
                            title: "アプリ間移動を活用",
                            description: "⌘+Tab でアプリを切り替えることで、効率的にウィンドウを管理できます"
                        )
                    }
                }
                .padding(.horizontal, 4)
            }

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
        .frame(width: 500, height: 600)
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
                .font(.title)
                .foregroundColor(.green)
                .frame(width: 40)

            VStack(alignment: .leading, spacing: 4) {
                Text(shortcut)
                    .font(.system(.body, design: .monospaced))
                    .fontWeight(.semibold)

                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()
        }
        .padding()
        .background(Color.secondary.opacity(0.1))
        .cornerRadius(12)
    }

    private func recommendationRow(icon: String, title: String, description: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.orange)
                .frame(width: 30)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)

                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding()
        .background(Color.orange.opacity(0.1))
        .cornerRadius(12)
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
            contentRect: NSRect(x: 0, y: 0, width: 500, height: 600),
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
