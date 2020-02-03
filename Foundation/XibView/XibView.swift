import UIKit

class XibView: UIView {
  var xibName: String?
  
  override required init(frame: CGRect) {
    super.init(frame: frame)
    commonInit()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    commonInit()
  }
  
  internal func commonInit() {
    setupFromXib()
  }
  
  private func setupFromXib() {
    let xibName = self.xibName ?? String(describing: type(of: self))
    
    let viewsInXib = Bundle(for: type(of: self)).loadNibNamed(xibName, owner: self, options: nil)
    guard let view = viewsInXib?.first as? UIView else {
      return
    }
    
    self.addSubview(view)
    
    view.translatesAutoresizingMaskIntoConstraints = false
    view.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
    view.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    view.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
    view.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
    
    view.backgroundColor = UIColor.clear
  }
}
