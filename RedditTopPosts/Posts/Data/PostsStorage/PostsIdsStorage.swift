import Foundation

protocol PostsIdsStorage {
  func appendIds(_ ids: [String])
  func ids() -> [String]
  func removeAll()
}

class InRamPostsIdsStorage: PostsIdsStorage {
  private var array: [String] = []
  
  init(initialState: [String] = []) {
    self.array = initialState
  }
  
  func appendIds(_ ids: [String]) {
    self.array.append(contentsOf: ids)
  }
  
  func ids() -> [String] {
    return self.array
  }
  
  func removeAll() {
    self.array = []
  }
}

class UserDefaultsPostsIdsStorage: PostsIdsStorage {
  private var key: String
  private var cached: InRamPostsIdsStorage!
  
  init(key: String) {
    self.key = key
    self.cached = InRamPostsIdsStorage(initialState: UserDefaults.standard.stringArray(forKey: key) ?? [])
  }
  
  func appendIds(_ ids: [String]) {
    self.cached.appendIds(ids)
    UserDefaults.standard.set(self.cached.ids(), forKey: key)
    UserDefaults.standard.synchronize()
  }
  
  func ids() -> [String] {
    return cached.ids()
  }
  
  func removeAll() {
    cached.removeAll()
    UserDefaults.standard.set(nil, forKey: key)
  }
}
