import UIKit

class PostsListVC: UIViewController {
  var onGoToDetail: () -> Void = {}
  
  override func viewDidLoad() {
    super.viewDidLoad()

    title = "Reddit Posts"
    
    self.view.backgroundColor = .black
    
    view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(fireGoToDetail)))
  }
  
  @objc
  private func fireGoToDetail() {
    onGoToDetail()
  }
}
