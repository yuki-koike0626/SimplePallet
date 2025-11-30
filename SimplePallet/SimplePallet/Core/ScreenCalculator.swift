import Cocoa
import ApplicationServices

/**
 マルチディスプレイ環境での画面計算を担当

 ウィンドウが表示されている画面を特定し、
 その画面のvisibleFrame（メニューバー・Dock領域を除く）内で
 最大化・左半分・右半分の矩形を計算する。
 */
enum ScreenCalculator {

    /**
     指定されたウィンドウが最も多く表示されている画面を取得

     - Parameter window: 対象のウィンドウ (AXUIElement)
     - Returns: ウィンドウが最も占有しているNSScreen。取得できない場合はメイン画面
     */
    static func targetScreen(for window: AXUIElement) -> NSScreen {
        guard let windowFrame = getWindowFrame(window) else {
            return NSScreen.main ?? NSScreen.screens[0]
        }

        return findBestScreen(for: windowFrame)
    }

    /**
     最大化用の矩形を計算

     - Parameter screen: 対象の画面
     - Returns: 画面のvisibleFrameいっぱいに広がる矩形
     */
    static func frameForMaximize(on screen: NSScreen) -> CGRect {
        return screen.visibleFrame
    }

    /**
     左半分用の矩形を計算

     - Parameter screen: 対象の画面
     - Returns: 画面の左半分を占める矩形
     */
    static func frameForLeft(on screen: NSScreen) -> CGRect {
        let visible = screen.visibleFrame
        return CGRect(
            x: visible.origin.x,
            y: visible.origin.y,
            width: visible.width / 2,
            height: visible.height
        )
    }

    /**
     右半分用の矩形を計算

     - Parameter screen: 対象の画面
     - Returns: 画面の右半分を占める矩形
     */
    static func frameForRight(on screen: NSScreen) -> CGRect {
        let visible = screen.visibleFrame
        return CGRect(
            x: visible.origin.x + visible.width / 2,
            y: visible.origin.y,
            width: visible.width / 2,
            height: visible.height
        )
    }

    /**
     左1/3用の矩形を計算

     - Parameter screen: 対象の画面
     - Returns: 画面の左1/3を占める矩形
     */
    static func frameForLeftThird(on screen: NSScreen) -> CGRect {
        let visible = screen.visibleFrame
        return CGRect(
            x: visible.origin.x,
            y: visible.origin.y,
            width: visible.width / 3,
            height: visible.height
        )
    }

    /**
     中央1/3用の矩形を計算

     - Parameter screen: 対象の画面
     - Returns: 画面の中央1/3を占める矩形
     */
    static func frameForCenterThird(on screen: NSScreen) -> CGRect {
        let visible = screen.visibleFrame
        return CGRect(
            x: visible.origin.x + visible.width / 3,
            y: visible.origin.y,
            width: visible.width / 3,
            height: visible.height
        )
    }

    /**
     右1/3用の矩形を計算

     - Parameter screen: 対象の画面
     - Returns: 画面の右1/3を占める矩形
     */
    static func frameForRightThird(on screen: NSScreen) -> CGRect {
        let visible = screen.visibleFrame
        return CGRect(
            x: visible.origin.x + visible.width * 2 / 3,
            y: visible.origin.y,
            width: visible.width / 3,
            height: visible.height
        )
    }

    // MARK: - Private Helpers

    /**
     AXUIElementからウィンドウの矩形を取得

     AXUIElement座標系（左上原点、Y軸下向き）をNSScreen座標系（左下原点、Y軸上向き）に変換する
     */
    private static func getWindowFrame(_ window: AXUIElement) -> CGRect? {
        var positionValue: CFTypeRef?
        var sizeValue: CFTypeRef?

        guard AXUIElementCopyAttributeValue(window, kAXPositionAttribute as CFString, &positionValue) == .success,
              AXUIElementCopyAttributeValue(window, kAXSizeAttribute as CFString, &sizeValue) == .success else {
            return nil
        }

        var position = CGPoint.zero
        var size = CGSize.zero

        guard let positionValue = positionValue,
              AXValueGetValue(positionValue as! AXValue, .cgPoint, &position),
              let sizeValue = sizeValue,
              AXValueGetValue(sizeValue as! AXValue, .cgSize, &size) else {
            return nil
        }

        // AXUIElement座標系（左上原点、Y軸下向き）からNSScreen座標系（左下原点、Y軸上向き）に変換
        let baseHeight = primaryScreenHeight()

        // Y座標を反転（左上原点 → 左下原点）
        // AXUIElement: Y=0が一番上、下に行くほど増える
        // NSScreen: Y=0が一番下、上に行くほど増える
        let convertedY = baseHeight - position.y - size.height

        return CGRect(x: position.x, y: convertedY, width: size.width, height: size.height)
    }

    /**
     ウィンドウ矩形に対して最も占有面積が大きい画面を見つける
     */
    private static func findBestScreen(for windowFrame: CGRect) -> NSScreen {
        var bestScreen = NSScreen.main ?? NSScreen.screens[0]
        var maxArea: CGFloat = 0

        for screen in NSScreen.screens {
            let intersection = windowFrame.intersection(screen.frame)
            let area = intersection.width * intersection.height

            if area > maxArea {
                maxArea = area
                bestScreen = screen
            }
        }

        return bestScreen
    }

    static func primaryScreenHeight() -> CGFloat {
        if let primary = NSScreen.screens.first(where: { abs($0.frame.origin.x) < 0.1 && abs($0.frame.origin.y) < 0.1 }) {
            return primary.frame.height
        }
        if let screen = NSScreen.screens.first(where: { $0.frame.contains(NSPoint(x: 1, y: 1)) }) {
            return screen.frame.height
        }
        return NSScreen.main?.frame.height ?? NSScreen.screens.first?.frame.height ?? 0
    }
}
