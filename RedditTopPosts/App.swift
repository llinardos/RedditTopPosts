import UIKit

class App {
  private var splitVC: UISplitViewController
  private var listVC: PostsListVC
  private var detailVC: PostDetailVC
  private var storyboard: UIStoryboard
  
  init() {
    self.storyboard = UIStoryboard(name: "Main", bundle: nil)
    
    self.splitVC = storyboard.instantiateInitialViewController() as! UISplitViewController
    
    self.listVC = (splitVC.viewControllers[0] as? UINavigationController)
      .flatMap { $0.viewControllers.first }
      .flatMap { $0 as? PostsListVC }!
    
    self.detailVC = (splitVC.viewControllers[1] as? UINavigationController)
      .flatMap { $0.viewControllers.first }
      .flatMap { $0 as? PostDetailVC }!
    
    splitVC.delegate = self
    splitVC.preferredDisplayMode = .allVisible
    
    self.listVC.onGoToDetail = { [weak self] in
      if self?.splitVC.viewControllers.count == 1 { // Only showing master
        guard let self = self else { return }
        self.detailVC = self.storyboard.instantiateViewController(identifier: "PostDetailVC") as! PostDetailVC
        self.listVC.navigationController?.pushViewController(self.detailVC, animated: true)
      }
    }
  }
  
  func run(on window: UIWindow) {
    window.rootViewController = splitVC
  }
}


extension App: UISplitViewControllerDelegate {
  func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController:UIViewController, onto primaryViewController:UIViewController) -> Bool {
    // Necesarry to show listVC as initial VC on iphone-ish layout (if not present, detail is presented as first VC and we need to pop to show the list).
      return true
  }
}
