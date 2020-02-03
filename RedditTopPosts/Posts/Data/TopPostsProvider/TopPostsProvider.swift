import UIKit

typealias TopPostsProviderResult = Swift.Result<[RedditPost], Error>

protocol TopPostsProvider {
  func get(_ callback: @escaping (TopPostsProviderResult) -> Void)
}
