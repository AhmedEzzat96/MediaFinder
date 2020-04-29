import UIKit

class SignUpVC: UIViewController {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var contactNumTextField: UITextField!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var joinBtn: UIButton!
    @IBOutlet weak var genderSwitch: UISwitch!
    let database = DatabaseManager.shared()

    var gender: String = Gender.Male.rawValue
    var address: String!
    let imagePicker = UIImagePickerController()
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        genderSwitch.addTarget(self, action: #selector(switchIsChanged), for: .valueChanged)
    }
    
    @IBAction func mapBtnPressed(_ sender: UIButton) {
        let mapVC = UIStoryboard.init(name: Storyboards.main, bundle: nil).instantiateViewController(withIdentifier: VCs.mapVC) as! MapVC
        mapVC.delegate = self
        self.navigationController?.pushViewController(mapVC, animated: true)
    }
    
    @objc func switchIsChanged() {
        if genderSwitch.isOn {
            self.gender = Gender.Female.rawValue
        } else {
            self.gender = Gender.Male.rawValue
        }
    }

    private func isValidData() -> Bool {
        if let name = fullNameTextField.text, !name.isEmpty, let email = emailTextField.text, let address = locationLabel.text, !address.isEmpty, !email.isEmpty, let password = passwordTextField.text, !password.isEmpty, let contact = contactNumTextField.text, !contact.isEmpty, let image = profileImageView.image, image != UIImage(named: "reg") {
            if email.isValidEmail, password.isValidPassword, contact.isPhoneNumber, database.emailNotExists(email: email) {
                return true
            } else {
                let alert = UIAlertController(title: "Fields Required!", message: "", preferredStyle: UIAlertController.Style.alert)
                
                if email.isValidEmail == false {
                    alert.message = "Your Email Address is wrong, please try again"
                }
                if password.isValidPassword == false {
                    alert.message = "Your password is wrong, please try again, your password at least 8 character & at least one letter "
                }
                if contact.isPhoneNumber == false {
                    alert.message = "Your phone no. is wrong, please try again, your phone no. should be 11 numbers"
                }
                
                if database.emailNotExists(email: email) == false {
                    alert.title = "Email Address already Exists"
                    alert.message = "Your Email Address is already Exists, please try another email address"
                }
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        return false
    }

    
    
    private func saveUser() {
        createDatabase()
        let user = Users(name: fullNameTextField.text!, email: emailTextField.text!, password: passwordTextField.text!, contactNum: contactNumTextField.text!, gender: self.gender , address: address, image: profileImageView.image?.pngData())
        database.insertUsers(user: user)
        database.insertCacheData()
    }
    
    private func createDatabase() {
        database.createUsersTable()
        database.createCachDataTable()
    }
    
    private func goToSignInScreen() {
        let signInVC = UIStoryboard.init(name: Storyboards.main, bundle: nil).instantiateViewController(withIdentifier: VCs.signInVC) as! SignInVC
        self.navigationController?.pushViewController(signInVC, animated: true)
    }
    
    
    @IBAction func joinBtnPressed(_ sender: UIButton) {
        if isValidData() {
            saveUser()
            goToSignInScreen()
        } else {
            let alert = UIAlertController(title: "Fields Required!", message: "", preferredStyle: UIAlertController.Style.alert)
            alert.message = "Please fill all text fields"
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func selectPhotoBtnPressed(_ sender: UIButton) {
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }
    
}

extension SignUpVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        profileImageView.image = selectedImage
        profileImageView.circularImageView()
        dismiss(animated: true) {
        }
    }
}

extension SignUpVC: SendingMessageDelegate{
    func messageData(data: String) {
        locationLabel.text = "Your location is \(data)"
        self.address = data
    }
}
