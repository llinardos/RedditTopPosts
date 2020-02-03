import Foundation

class Posts {
  private let topPostsProvider: TopPostsProvider
  private let readPostsStorage: PostsIdsStorage
  private let dismissedPostsStorage: PostsIdsStorage
  private var allPosts: [RedditPost] = []
  private var postsToShow: [RedditPost] = []
  
  init(topPostsProvider: TopPostsProvider, readPostsStorage: PostsIdsStorage, dismissedPostsStorage: PostsIdsStorage) {
    self.topPostsProvider = topPostsProvider
    self.readPostsStorage = readPostsStorage
    self.dismissedPostsStorage = dismissedPostsStorage
  }
  
  func fetch(_ callback: @escaping (Result<Posts, Error>) -> Void) {
    self.topPostsProvider.get() { [unowned self] result in
      switch result {
      case .success(let posts):
        self.setAll(posts)
        callback(.success(self))
      case .failure(let error):
        callback(.failure(error))
      }
    }
  }
  
  func toShow() -> [RedditPost] {
    return self.postsToShow
  }
  
  func markAsRead(_ post: RedditPost) {
    readPostsStorage.appendIds([post.id])
  }
  
  func isPostRead(_ post: RedditPost) -> Bool {
    return readPostsStorage.ids().contains(post.id)
  }
  
  func dismiss(_ post: RedditPost) {
    dismissedPostsStorage.appendIds([post.id])
    self.setAll(allPosts)
  }
  
  private func setAll(_ allPosts: [RedditPost]) {
    self.allPosts = allPosts
    self.postsToShow = self.allPosts.filter {
      !self.dismissedPostsStorage.ids().contains($0.id)
    }
  }
}
