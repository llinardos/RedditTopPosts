import UIKit

class PostDetailVC: UIViewController {
  @IBOutlet private weak var contentView: UIView!
  @IBOutlet private weak var emptyView: UIView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "Selected Post"
    
    self.view.backgroundColor = .white
    
    showEmpty()
  }
  
  private func showEmpty() {
    self.emptyView.isHidden = false
    self.contentView.isHidden = true
  }
  
  private func showPost(_ post: RedditPost) {
    self.emptyView.isHidden = true
    self.contentView.isHidden = false
  }
}
