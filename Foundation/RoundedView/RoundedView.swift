import UIKit

public class RoundedView: UIView {
  public var cornerRadius: CGFloat {
    set { layer.cornerRadius = newValue; layer.masksToBounds = true }
    get { return layer.cornerRadius }
  }
  
  public var borderWidth: CGFloat {
    set { layer.borderWidth = newValue }
    get { return layer.borderWidth }
  }
  
  public var borderColor: () -> UIColor? = { return nil } {
    didSet { layer.borderColor = borderColor()?.cgColor }
  }
  
  @IBInspectable
  public var isCircle: Bool = false
  
  override public func layoutSubviews() {
    super.layoutSubviews()
    self.borderColor = { return self.borderColor }()
    if isCircle {
      becomeACircle()
    }
  }
  
  fileprivate func becomeACircle() {
    layer.cornerRadius = min(frame.height, frame.width) / 2.0
    clipsToBounds = true
  }
}
