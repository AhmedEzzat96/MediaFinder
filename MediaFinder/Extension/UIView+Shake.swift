import Foundation
import UIKit

extension UIView {
    func shake(_ duration: Double? = 0.6) {
        self.transform = CGAffineTransform(translationX: 10, y: 0)
        UIView.animate(withDuration: duration ?? 0.4, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 100, options: .curveEaseInOut, animations: {
            self.transform = CGAffineTransform.identity
        }, completion: nil)
    }
}
