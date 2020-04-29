import UIKit
import SDWebImage

class TableViewCell: UITableViewCell {
    @IBOutlet weak var artistImageView: UIImageView!
    @IBOutlet weak var artistNameOrTrackNameLabel: UILabel!
    @IBOutlet weak var longDescribtionOrArtistNameLabel: UILabel!
    
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




