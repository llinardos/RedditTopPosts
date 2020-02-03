import UIKit

class PostCell: UITableViewCell {
  struct Content {
    var authorText: String
    var titleText: String
    var commentsText: String
    var dateText: String
    var imageURL: URL?
  }
  
  @IBOutlet private weak var authorLabel: UILabel!
  @IBOutlet private weak var titleLabel: UILabel!
  @IBOutlet private weak var commentsCountLabel: UILabel!
  @IBOutlet private weak var dateLabel: UILabel!
  @IBOutlet private weak var thumbnailView: RedditPostRemoteImageView!
  @IBOutlet private weak var badgeView: UIView!
  @IBOutlet private weak var dismissPostButton: UIButton!
  
  var onDismiss: () -> Void = {}
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    self.backgroundColor = UIColor.black
    
    self.authorLabel.font = UIFont.preferredFont(forTextStyle: .headline)
    self.authorLabel.textColor = UIColor.white
    
    self.dateLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
    self.dateLabel.textColor = UIColor.systemGray4
    
    self.titleLabel.font = UIFont.preferredFont(forTextStyle: .body)
    self.titleLabel.textColor = UIColor.white
    
    self.commentsCountLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
    self.commentsCountLabel.textColor = UIColor.systemOrange
    
    self.thumbnailView.isTapOnImageEnabled = false
    
    selectedBackgroundView = UIView()
    selectedBackgroundView?.backgroundColor = UIColor.darkGray
    
    accessoryView = UIImageView(image: UIImage(systemName: "chevron.right"))
    accessoryView?.tintColor = .white
  }
  
  func setContent(_ content: Content) {
    authorLabel.text = content.authorText
    titleLabel.text = content.titleText
    commentsCountLabel.text = content.commentsText
    dateLabel.text = content.dateText
    thumbnailView.loadImageFromURL(content.imageURL)
  }
  
  func showBadge(_ show: Bool) {
    badgeView.isHidden = !show
  }
    
  @IBAction private func onDismissButtonTap(_ sender: Any) {
    onDismiss()
  }
}
