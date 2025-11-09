import SwiftUI
import AppKit
import Combine

/**
 トーストの種類
 */
enum ToastType {
    case success
    case error
    case info

    var icon: String {
        switch self {
        case .success: return "checkmark.circle.fill"
        case .error: return "xmark.circle.fill"
        case .info: return "info.circle.fill"
        }
    }

    var color: Color {
        switch self {
        case .success: return .green
        case .error: return .red
        case .info: return .blue
        }
    }
}

/**
 トースト通知の管理

 軽量なフィードバックを画面上部に短時間表示する。
 */
class ToastManager: ObservableObject {
    static let shared = ToastManager()

    @Published var isShowing = false
    @Published var message = ""
    @Published var type: ToastType = .info

    private var toastWindow: NSWindow?

    private init() {}

    /**
     トーストを表示

     - Parameters:
       - message: 表示するメッセージ
       - type: トーストの種類
       - duration: 表示時間（秒）
     */
    func showToast(message: String, type: ToastType, duration: TimeInterval = 1.5) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }

            self.message = message
            self.type = type
            self.isShowing = true

            self.showToastWindow()

            // 指定時間後に非表示
            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                self.hideToast()
            }
        }
    }

    private func showToastWindow() {
        // 既存のウィンドウを閉じる
        toastWindow?.close()

        // トーストビューを作成
        let toastView = ToastContentView(message: message, type: type)
        let hostingView = NSHostingView(rootView: toastView)
        hostingView.frame = NSRect(x: 0, y: 0, width: 300, height: 60)

        // ウィンドウを作成
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 300, height: 60),
            styleMask: [.borderless],
            backing: .buffered,
            defer: false
        )

        window.contentView = hostingView
        window.backgroundColor = .clear
        window.isOpaque = false
        window.level = .floating
        window.collectionBehavior = [.canJoinAllSpaces, .stationary]
        window.ignoresMouseEvents = true

        // 画面中央上部に配置
        if let screen = NSScreen.main {
            let screenFrame = screen.visibleFrame
            let x = screenFrame.midX - 150
            let y = screenFrame.maxY - 100
            window.setFrameOrigin(NSPoint(x: x, y: y))
        }

        window.orderFrontRegardless()
        window.animator().alphaValue = 1.0

        toastWindow = window
    }

    private func hideToast() {
        NSAnimationContext.runAnimationGroup({ context in
            context.duration = 0.3
            toastWindow?.animator().alphaValue = 0.0
        }, completionHandler: { [weak self] in
            self?.toastWindow?.close()
            self?.toastWindow = nil
            self?.isShowing = false
        })
    }
}

/**
 トーストのコンテンツビュー
 */
struct ToastContentView: View {
    let message: String
    let type: ToastType

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: type.icon)
                .font(.title2)
                .foregroundColor(type.color)

            Text(message)
                .font(.body)
                .foregroundColor(.primary)

            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(NSColor.windowBackgroundColor))
                .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
        )
        .padding()
    }
}

// MARK: - プレビュー

struct ToastContentView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            ToastContentView(message: String(localized: "action.maximize", bundle: .main, comment: "Maximize action"), type: .success)
            ToastContentView(message: String(localized: "toast.error", bundle: .main, comment: "Error toast"), type: .error)
            ToastContentView(message: String(localized: "toast.info", bundle: .main, comment: "Info toast"), type: .info)
        }
        .frame(width: 400, height: 300)
    }
}

