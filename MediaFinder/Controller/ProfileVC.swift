import UIKit

class ProfileVC: UIViewController {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var contactNumLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    let database = DatabaseManager.shared()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = false
        getUserData()
        circularImageView(image: profileImageView)
    }
    
    private func circularImageView(image: UIImageView) {
        image.layer.masksToBounds = true
        image.layer.cornerRadius = image.bounds.width / 2
    }
    
    private func getUserData() {
        let user = database.getUserData()
        if let imageData = user?.image {
            profileImageView.image = UIImage(data: imageData)
        }
        nameLabel.text = user?.name
        emailLabel.text = user?.email
        genderLabel.text = user?.gender
        addressLabel.text = user?.address
        contactNumLabel.text = user?.contactNum
    }
    
    private func goToSignInVC() {
        let signInVC = UIStoryboard.init(name: Storyboards.main, bundle: nil).instantiateViewController(withIdentifier: "SignInVC") as! SignInVC
        self.navigationController?.pushViewController(signInVC, animated: true)
    }
    
    @IBAction func logOutBtnPressed(_ sender: UIButton) {
        goToSignInVC()
        UserDefaultsManager.shared().isLoggedIn = false
        hideTabBar()
    }
    
    private func hideTabBar() {
        self.tabBarController?.tabBar.isHidden = true
        self.tabBarController?.tabBar.isTranslucent = true
    }
}
