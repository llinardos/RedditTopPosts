import Foundation

class RedditAPITopPostsProvider: TopPostsProvider {
  enum Error: Swift.Error {
    case noDataInResponse
  }
  
  private var urlSession: URLSession
  
  init() {
    let configuration = URLSessionConfiguration.default
    configuration.timeoutIntervalForRequest = TimeInterval(15)
    urlSession = URLSession(configuration: configuration)
  }
  
  func get(_ callback: @escaping (TopPostsProviderResult) -> Void) {
    let redditTopEntriesURL = URL(string: "https://www.reddit.com/top.json?limit=50")!
    let request = URLRequest(url: redditTopEntriesURL)
    urlSession.dataTask(with: request, completionHandler: { (data, response, error) in
      DispatchQueue.main.async {
        if let error = error {
          return callback(.failure(error))
        }
        guard let data = data else {
          return callback(.failure(Error.noDataInResponse))
        }
        return callback(parseRedditEntriesFromJSONData(data))
      }
    }).resume()

  }
}

fileprivate struct ResponseFromRedditWebAPI: Decodable {
  struct Data: Decodable {
    struct Children: Decodable {
      struct Data: Decodable {
        var title: String
        var created_utc: Double
        var num_comments: Int
        var author: String
        var thumbnail: String
      }
      let data: Data
    }
    let children: [Children]
  }
  let data: Data
}

fileprivate func parseRedditEntriesFromJSONData(_ data: Data) -> Result<[RedditPost], Error> {
  return Result {
    try JSONDecoder().decode(ResponseFromRedditWebAPI.self, from: data).data.children.map({ $0.data }).map {
      return RedditPost(
        title: $0.title,
        authorName: $0.author,
        commentsCount: $0.num_comments,
        creationDate: Date(timeIntervalSince1970: $0.created_utc),
        thumbnailURL: sanitizedThumbnailURLFrom($0.thumbnail)
      )
    }
  }
}

fileprivate func sanitizedThumbnailURLFrom(_ urlString: String) -> URL? {
  // This handles the cases when thumbnail is a reddit "indirect" reference: instead
  // of returning an url or none, it returs "default" or "self" (https://www.reddit.com/r/redditdev/comments/2wwuje/what_does_it_mean_when_the_thumbnail_field_has/)
  // In these cases, I decide to set the thumnail as nil and let the client of this component
  // decide how to handle the missing image.
  guard let url = URL(string: urlString) else { return nil }
  guard url.scheme == "http" || url.scheme == "https" else { return nil } //
  return url
}

