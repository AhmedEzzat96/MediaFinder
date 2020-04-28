import UIKit
import SDWebImage

class TableViewCell: UITableViewCell {
    @IBOutlet weak var artistImageView: UIImageView!
    @IBOutlet weak var artistNameOrTrackNameLabel: UILabel!
    @IBOutlet weak var longDescribtionOrArtistNameLabel: UILabel!
    var indicator = UIActivityIndicatorView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 3, bottom: 5, right: 3))
    }
  
    func configurecell(media: Media) {
        if media.getKind() == MediaType.tvShow {
            artistNameOrTrackNameLabel?.text = media.artistName
        } else {
            artistNameOrTrackNameLabel?.text = media.trackName
        }
        if media.getKind() == MediaType.music {
            longDescribtionOrArtistNameLabel?.text = media.artistName
        } else {
            longDescribtionOrArtistNameLabel?.text = media.longDescription
        }
        artistImageView?.sd_setImage(with: URL(string: media.artworkUrl100), completed: nil)
    }
    
    @IBAction func animationBtnPressed(_ sender: UIButton) {
        artistImageView?.shake()
    }
}

extension UIView {
    func shake(_ duration: Double? = 0.6) {
        self.transform = CGAffineTransform(translationX: 10, y: 0)
        UIView.animate(withDuration: duration ?? 0.4, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 100, options: .curveEaseInOut, animations: {
            self.transform = CGAffineTransform.identity
        }, completion: nil)
    }
}

extension UITableViewCell{
    func shadowAndBorderForCell(yourTableViewCell : UITableViewCell){
        yourTableViewCell.contentView.layer.cornerRadius = 25
        yourTableViewCell.contentView.layer.borderWidth = 2
        yourTableViewCell.contentView.layer.borderColor = UIColor.darkGray.cgColor
        yourTableViewCell.contentView.layer.masksToBounds = true
        yourTableViewCell.layer.shadowColor = UIColor.gray.cgColor
        yourTableViewCell.layer.shadowOffset = CGSize(width: 2, height: 1)
        yourTableViewCell.layer.shadowRadius = 2
        yourTableViewCell.layer.shadowOpacity = 0
        yourTableViewCell.layer.masksToBounds = false
        yourTableViewCell.layer.shadowPath = UIBezierPath(roundedRect:yourTableViewCell.bounds, cornerRadius:yourTableViewCell.contentView.layer.cornerRadius).cgPath
    }
}
