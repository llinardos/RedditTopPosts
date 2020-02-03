import UIKit

class PostCell: UITableViewCell {
  @IBOutlet private weak var authorLabel: UILabel!
  @IBOutlet private weak var titleLabel: UILabel!
  @IBOutlet private weak var commentsCountLabel: UILabel!
  @IBOutlet private weak var dateLabel: UILabel!
  
  func setPost(_ post: RedditPost) {
    authorLabel.text = post.authorName
    titleLabel.text = post.title
    commentsCountLabel.text = "\(post.commentsCount)"
    dateLabel.text = "\(post.creationDate.timeIntervalSince1970)"
  }
}
