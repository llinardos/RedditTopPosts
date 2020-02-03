import UIKit

class PostCell: UITableViewCell {
  @IBOutlet private weak var authorLabel: UILabel!
  @IBOutlet private weak var titleLabel: UILabel!
  @IBOutlet private weak var commentsCountLabel: UILabel!
  @IBOutlet private weak var dateLabel: UILabel!
  
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
    
    selectedBackgroundView = UIView()
    selectedBackgroundView?.backgroundColor = UIColor.darkGray
    
    accessoryView = UIImageView(image: UIImage(systemName: "chevron.right"))
    accessoryView?.tintColor = .white
  }
  
  func setPost(_ post: RedditPost) {
    authorLabel.text = post.authorName
    titleLabel.text = post.title
    commentsCountLabel.text = "\(post.commentsCount)"
    dateLabel.text = "\(post.creationDate.timeIntervalSince1970)"
  }
}
