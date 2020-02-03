import Foundation

class Posts {
  private let topPostsProvider: TopPostsProvider
  private let readPostsStorage: PostsIdsStorage
  private var allPosts: [RedditPost] = []
  
  init(topPostsProvider: TopPostsProvider, readPostsStorage: PostsIdsStorage) {
    self.topPostsProvider = topPostsProvider
    self.readPostsStorage = readPostsStorage
  }
  
  func fetch(_ callback: @escaping (Result<Posts, Error>) -> Void) {
    self.topPostsProvider.get() { [unowned self] result in
      switch result {
      case .success(let posts):
        self.allPosts = posts
        callback(.success(self))
      case .failure(let error):
        callback(.failure(error))
      }
    }
  }
  
  func toShow() -> [RedditPost] {
    return self.allPosts
  }
  
  func markAsRead(_ post: RedditPost) {
    readPostsStorage.appendIds([post.id])
  }
  
  func isPostRead(_ post: RedditPost) -> Bool {
    return readPostsStorage.ids().contains(post.id)
  }
}
