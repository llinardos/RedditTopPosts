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
    commentsCountLabel.text = text(for: post.commentsCount)
    dateLabel.text = text(for: post.creationDate)
  }
  
  private func text(for commentsCount: Int) -> String {
    // TODO: This can be handled better with localization + strings dict: https://developer.apple.com/library/archive/documentation/MacOSX/Conceptual/BPInternational/StringsdictFileFormat/StringsdictFileFormat.html
    switch commentsCount {
    case 0: return "No comments yet"
    case 1: return "1 comment"
    default: return "\(commentsCount) comments"
    }
  }
  
  private func text(for creationDate: Date) -> String {
    let timeEllapsedSinceCreation = Date().timeIntervalSince(creationDate).rounded(.up) // TODO: here we have an implicit parameter, should be extracted to make it testable
    let formatter = DateComponentsFormatter()
    formatter.calendar = Calendar.current // TODO: remember that we have a "hidden" singleton here, should be extracted to make it testeable
    formatter.allowedUnits = [.year, .month, .day, .hour, .minute, .second]
    formatter.unitsStyle = .full
    formatter.maximumUnitCount = 1
    
    guard let prettyTimeEllapsedString = formatter.string(from: timeEllapsedSinceCreation) else {
      // TODO: not sure when formatter.string() can fail, but a force unwrap will produce a crash in that case.
      // I prefer to return an "empty string" and log the error on a crash/error report sysmtem
      return "--"
    }
    return prettyTimeEllapsedString + " ago"
  }
}
