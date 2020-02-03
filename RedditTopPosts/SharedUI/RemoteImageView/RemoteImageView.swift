import UIKit

class RemoteImageView: XibView {
  @IBOutlet private weak var backgroundView: UIView!
  @IBOutlet private weak var loadingIndicator: UIActivityIndicatorView!
  @IBOutlet private weak var errorView: UIView!
  @IBOutlet private weak var imageView: UIImageView!
  
  private var dataTask: URLSessionDataTask?
  private var imageUrl: URL?
  
  override func commonInit() {
    super.commonInit()
  }
  
  func loadImageFromURL(_ imageUrl: URL) {
    self.imageUrl = imageUrl
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
}
