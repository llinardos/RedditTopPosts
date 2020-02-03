import Foundation

struct StubTopPostsProvider: TopPostsProvider {
  var r: TopPostsProviderResult
  init(returning r: TopPostsProviderResult) {
    self.r = r
  }
  func get(_ callback: @escaping (TopPostsProviderResult) -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
      callback(self.r)
    }
  }
}
