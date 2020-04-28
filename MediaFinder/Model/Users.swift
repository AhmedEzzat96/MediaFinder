import Foundation
import UIKit

enum Gender: String {
    case Male = "Male"
    case Female = "Female"
}

struct Users {
    
    var name: String!
    var email: String!
    var password: String!
    var contactNum: String!
    var gender: String!
    var address: String!
    var image: Data!
    
}
