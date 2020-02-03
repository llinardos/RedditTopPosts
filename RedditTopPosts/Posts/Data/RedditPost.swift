import Foundation

struct RedditPost {
  struct Image {
    var thumbnailURL: URL
    var fullURL: URL
  }
  
  var id: String
  var title: String
  var authorName: String
  var commentsCount: Int
  var creationDate: Date
  var image: Image?
}

extension RedditPost: Equatable {
  static func == (lhs: Self, rhs: Self) -> Bool {
    return lhs.id == rhs.id
  }
}
