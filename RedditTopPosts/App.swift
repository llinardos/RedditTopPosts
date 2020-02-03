import UIKit

class App {
  func run(on window: UIWindow) {
    let vc = UIViewController()
    vc.view.backgroundColor = .red
    window.rootViewController = vc
  }
}
