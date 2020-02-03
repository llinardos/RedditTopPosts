import UIKit

class PostDetailVC: UIViewController {
  @IBOutlet private weak var contentView: UIView!
  @IBOutlet private weak var emptyView: UIView!
  
  @IBOutlet weak var authorLabel: UILabel!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var thumbnailView: RedditPostRemoteImageView!
  
  private var post: RedditPost?
  var onImageTapped: (RedditPost.Image) -> Void = { _ in }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "Selected Post"
    
    self.view.backgroundColor = .white
    self.thumbnailView.isTapOnImageEnabled = true
    self.thumbnailView.onImageTapped = { [weak self] _ in
      guard let self = self else { return }
      guard let image = self.post?.image else { return }
      self.onImageTapped(image)
    }
    
    setPost(post)
  }
  
  func setPost(_ post: RedditPost?) {
    self.post = post
    
    guard self.viewIfLoaded != nil else {
      return
    }
    
    if let post = post {
      showPost(post)
    } else {
      showEmpty()
    }
  }
  
  private func showEmpty() {
    self.emptyView.isHidden = false
    self.contentView.isHidden = true
  }
  
  private func showPost(_ post: RedditPost) {
    self.emptyView.isHidden = true
    self.contentView.isHidden = false
    
    self.authorLabel.text = post.authorName
    self.titleLabel.text = post.title
    self.thumbnailView.loadImageFromURL(post.image?.thumbnailURL)
  }
}
