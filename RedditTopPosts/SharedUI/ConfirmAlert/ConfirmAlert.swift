import UIKit

func showAlertConfirmingAction(
  title: String,
  message: String,
  confirmActionText: String,
  presentFrom presentingVC: UIViewController,
  onConfirmed: @escaping () -> Void)
{
  let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
  alertVC.addAction(.init(title: confirmActionText, style: .destructive, handler: { (_) in onConfirmed() }))
  alertVC.addAction(.init(title: "Cancel", style: .cancel))
  presentingVC.present(alertVC, animated: true, completion: nil)
}
