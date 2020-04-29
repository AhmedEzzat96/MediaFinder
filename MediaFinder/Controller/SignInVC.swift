import UIKit

class SignInVC: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var logInBtn: UIButton!
    let database = DatabaseManager.shared()
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logInBtn.isEnabled = true
        logInBtn.isHighlighted = false
        self.navigationController?.isNavigationBarHidden = true
        database.listUsersTable()
        database.listCachDataTable()
    }

    override func viewWillAppear(_ animated: Bool) {
        emailTextField.text = ""
        passwordTextField.text = ""
    }
    
    private func checkUser() -> Bool {
        if database.userExists(email: emailTextField.text!, password: passwordTextField.text!) {
            return true
        }
        return false
    }
    
    private func goToTabBar() {
        self.navigationController?.pushViewController(TabBarVC(), animated: true)
    }
    
    private func unauthorizedMsg() {
        let alert = UIAlertController(title: "Fields Required!", message: "", preferredStyle: UIAlertController.Style.alert)
        alert.message = "your email or password was incorrect. please try again"
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func isValidData() -> Bool {
        if let email = emailTextField.text, !email.isEmpty, let password = passwordTextField.text, !password.isEmpty { if email.isValidEmail, password.isValidPassword {
        return true
        }
            }
        return false
    }
    
    
    @IBAction func lognInBtnPressed(_ sender: UIButton) {
        if isValidData() && checkUser() {
            UserDefaultsManager.shared().isLoggedIn = true
            goToTabBar()
        } else {
            unauthorizedMsg()
        }
    }
    
    @IBAction func signUpBtnPressed(_ sender: UIButton) {
        let signUpVC = UIStoryboard.init(name: Storyboards.main, bundle: nil).instantiateViewController(withIdentifier: VCs.signUpVC) as! SignUpVC
        self.navigationController?.pushViewController(signUpVC, animated: true)
    }
}
