import Cocoa
import FlutterMacOS

@main
class AppDelegate: FlutterAppDelegate {
  override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {// ứng dụng sẽ thoát khi không còn cửa sổ mở.
    return true
  }

  override func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool { // ứng dụng có thể lưu và khôi phục trạng thái của nó một cách an toàn.
    return true
  }
}
