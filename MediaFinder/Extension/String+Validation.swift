import Foundation

extension String {
    var isPhoneNumber: Bool {
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.phoneNumber.rawValue)
            let matches = detector.matches(in: self, options: [], range: NSMakeRange(0, self.count))
            if let res = matches.first {
                return res.resultType == .phoneNumber && res.range.location == 0 && res.range.length == self.count && self.count == 11
            } else {
                return false
            }
        } catch {
            return false
        }
    }
    
    var isValidEmail: Bool {
        get {
            let emailRegEx = "^[\\w\\.-]+@([\\w\\-]+\\.)+[A-Z]{1,4}$"
            let emailTest = NSPredicate(format:"SELF MATCHES[c] %@", emailRegEx)
            return emailTest.evaluate(with: self)
        }
    }
    
    var isValidPassword: Bool {
        get {
            let passwordRegex = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$"
            return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: self)
        }
    }
    
}
