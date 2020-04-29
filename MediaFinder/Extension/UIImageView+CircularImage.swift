import Foundation
import UIKit

extension UIImageView {
    func circularImageView() {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = self.bounds.width / 2
    }
}
