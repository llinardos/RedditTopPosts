import UIKit

class RedditPostRemoteImageView: XibView {
  @IBOutlet private weak var backgroundView: UIView!
  @IBOutlet private weak var loadingIndicator: UIActivityIndicatorView!
  @IBOutlet private weak var errorView: UIView!
  @IBOutlet private weak var imageView: UIImageView!
  
  // TODO: handles reedit special case, can be refactored to make it generic and reuse it in another components/smodules/projects.
  private var defaultImageURL: URL = {
    // Loads reddit noimage in case of NO url
    return URL(string: "https://www.reddit.com/static/noimage.png")!
  }()
  
  private var dataTask: URLSessionDataTask?
  private var imageUrl: URL?
  
  var isTapOnImageEnabled: Bool {
    set { imageView.isUserInteractionEnabled = newValue }
    get { return imageView.isUserInteractionEnabled }
  }
  var onImageTapped: (URL) -> Void = { _ in }
  
  override func commonInit() {
    super.commonInit()
    
    // retry fetch on error
    errorView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(fetchImage)))
    
    // action on image loaded
    imageView.isUserInteractionEnabled = true
    imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(triggerOnImageTapped)))
  }
  
  func loadImageFromURL(_ imageUrl: URL?) {
    self.imageUrl = imageUrl ?? defaultImageURL
    fetchImage()
  }
  
  @objc
  private func fetchImage() {
    dataTask?.cancel()
    
    guard let imageUrl = imageUrl else { return }
    
    self.loadingIndicator.isHidden = false
    self.errorView.isHidden = true
    self.imageView.isHidden = true
    
    dataTask = URLSession.shared.dataTask(with: imageUrl, completionHandler: { data, response, error in
      DispatchQueue.main.async() {
        guard let data = data, error == nil else {
          self.errorView.isHidden = false
          self.imageView.isHidden = true
          self.loadingIndicator.isHidden = true
          return
        }
        
        self.imageView.image = UIImage(data: data)
        
        self.imageView.isHidden = false
        self.loadingIndicator.isHidden = true
        self.errorView.isHidden = true
      }
    })
    dataTask?.resume()
  }
  
  @objc
  private func triggerOnImageTapped() {
    guard let imageUrl = self.imageUrl else { return }
    self.onImageTapped(imageUrl)
  }
}
