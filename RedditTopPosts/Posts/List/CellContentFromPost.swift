import Foundation

extension PostCell.Content {
  static func fromPost(_ post: RedditPost) -> Self {
    return .init(
      authorText: post.authorName,
      titleText: post.title,
      commentsText: text(for: post.commentsCount),
      dateText: text(for: post.creationDate),
      imageURL: post.image?.thumbnailURL
    )
  }
  
  static func text(for commentsCount: Int) -> String {
    // TODO: This can be handled better with localization + strings dict: https://developer.apple.com/library/archive/documentation/MacOSX/Conceptual/BPInternational/StringsdictFileFormat/StringsdictFileFormat.html
    switch commentsCount {
    case 0: return "No comments yet"
    case 1: return "1 comment"
    default: return "\(commentsCount) comments"
    }
  }
  
  static func text(for creationDate: Date) -> String {
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
