import UIKit
import SafariServices

class App {
  private var splitVC: UISplitViewController
  private var listVC: PostsListVC
  private var detailVC: PostDetailVC
  private var storyboard: UIStoryboard
  
  init() {
    self.storyboard = UIStoryboard(name: "Main", bundle: nil)
    
    self.splitVC = storyboard.instantiateInitialViewController() as! UISplitViewController
    
    self.listVC = (splitVC.viewControllers[0] as? UINavigationController)
      .flatMap { $0.viewControllers.first }
      .flatMap { $0 as? PostsListVC }!
    
    self.detailVC = (splitVC.viewControllers[1] as? UINavigationController)
      .flatMap { $0.viewControllers.first }
      .flatMap { $0 as? PostDetailVC }!
    self.setupShowFullscreenImageOn(self.detailVC)
    
    splitVC.delegate = self
    splitVC.preferredDisplayMode = .allVisible
    
//    let topPostsProvider = StubTopPostsProvider(returning: .success(dummyPosts()))
//    let topPostsProvider = StubTopPostsProvider(returning: .failure(NSError()))
    let topPostsProvider = RedditAPITopPostsProvider()
    let readPostsStorage = UserDefaultsPostsIdsStorage(key: "RedditTopPosts.ReadPotsIds")
//    let readPostsStorage = InRamPostsIdsStorage(initialState: [])
//    let dismissedPostsStorage = UserDefaultsPostsIdsStorage(key: "RedditTopPosts.DismissedPotsIds")
    let dismissedPostsStorage = InRamPostsIdsStorage(initialState: [])
//    readPostsStorage.removeAll()
    let posts = Posts(topPostsProvider: topPostsProvider, readPostsStorage: readPostsStorage, dismissedPostsStorage: dismissedPostsStorage)
    
    self.listVC.posts = posts
    
    self.listVC.onPostSelected = { [weak self] selectedPost in
      if self?.splitVC.viewControllers.count == 1 { // Only showing master
        guard let self = self else { return }
        self.detailVC = self.storyboard.instantiateViewController(identifier: "PostDetailVC") as! PostDetailVC
        self.setupShowFullscreenImageOn(self.detailVC)
        self.listVC.navigationController?.pushViewController(self.detailVC, animated: true)
      }
      self?.detailVC.setPost(selectedPost)
    }
    
    
  }
  
  func run(on window: UIWindow) {
    window.rootViewController = splitVC
  }
  
  func setupShowFullscreenImageOn(_ detailVC: PostDetailVC) {
    detailVC.onImageTapped = { image in
      let safariVC = SFSafariViewController(url: image.fullURL)
      detailVC.present(safariVC, animated: true, completion: nil)
    }
  }
}


extension App: UISplitViewControllerDelegate {
  func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController:UIViewController, onto primaryViewController:UIViewController) -> Bool {
    // Necesarry to show listVC as initial VC on iphone-ish layout (if not present, detail is presented as first VC and we need to pop to show the list).
      return true
  }
}

func dummyPosts() -> [RedditPost] {
  return [
    RedditPost(
      id: "1",
      title: "There is a finite number of people who were born the same year as you. Every time one of them dies, you are closer to being the last one.",
      authorName: "Author 1",
      commentsCount: 0, creationDate:
      Date(),
      image: .init(
        thumbnailURL: URL(string: "https://b.thumbs.redditmedia.com/6P1_FO0JYWGsW9sZbaauLsVrl5406oWxvzYAY7jF0mI.jpg")!,
        fullURL: URL(string: "https://i.redd.it/hwsmjg28rke41.jpg")!
      )
    ),
    RedditPost(
      id: "2",
      title: "Title 2",
      authorName: "Author 2",
      commentsCount: 1,
      creationDate: Date().advanced(by: -30),
      image: .init(
        thumbnailURL: URL(string: "https://b.thumbs.redditmedia.com/vjeshsBc_5iDZ1tLGeo_6rdZDU4_vP5RzEHOhO0tBxE.jpg")!,
        fullURL: URL(string: "https://i.redd.it/vfwfif8iake41.jpg")!
      )
    ),
    RedditPost(
      id: "3",
      title: "Title 3",
      authorName: "Author 3",
      commentsCount: 12124618987,
      creationDate: Date().advanced(by: -121),
      image: nil
    ),
    RedditPost(
      id: "4",
      title: "Title 4",
      authorName: "Author 4",
      commentsCount: 1251,
      creationDate: Date().advanced(by: -1241231),
      image: nil
    ),
  ]
}

