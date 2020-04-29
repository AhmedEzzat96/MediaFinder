import UIKit
import Alamofire
import AVKit
import SQLite

class MediaListVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var itunesArr: [Media] = []
    let searchController = UISearchController(searchResultsController: nil)
    let playerViewController = AVPlayerViewController()
    let database = DatabaseManager.shared()
    var indicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Media List"
        activityIndicator()
        self.tableView.reloadData()
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Type something here to search"
        searchController.searchBar.scopeButtonTitles = ["All", "Music", "TvShow", "Movie"]
        navigationItem.searchController = searchController
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")
        tableView.dataSource = self
        tableView.delegate = self
        getData(search: database.getCachedData(), scope: "")
        self.showDetailViewController(playerViewController, sender: self)
        database.listUsersTable()
    }
    
    
    
    private func getData(search: String, scope: String) {
        indicator.startAnimating()
        APIManager.loadMedia(search: search, scope: scope) { (error, mediaArr, mediaResult) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                if mediaResult == 0 {
                    self.itunesArr.removeAll()
                    self.tableView.reloadData()
                    self.indicator.stopAnimating()
                } else {
                    if let media = mediaArr {
                    self.itunesArr = media
                    self.indicator.stopAnimating()
                    self.tableView.reloadData()
                    self.tableView.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: .top, animated: true)
                    }
                    
                }
            }
        }
    }
}

extension MediaListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itunesArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as? TableViewCell else {
            return UITableViewCell()
        }
        cell.shadowAndBorderForCell(yourTableViewCell: cell)
        cell.configurecell(media: itunesArr[indexPath.row])
        return cell
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        if itunesArr.count > 0 {
            self.tableView.backgroundView = nil
            self.tableView.separatorStyle = .singleLine
            return 1
        }
        
        let imageName = "NoRecordFound"
        let image = UIImage(named: imageName)
        let imageView = UIImageView(image: image)
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        self.tableView.backgroundView = imageView
        self.tableView.separatorStyle = .none

        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let mediaUrl = URL(string: itunesArr[indexPath.row].previewUrl ?? "") else {return}
        let player = AVPlayer(url: mediaUrl)
        self.playerViewController.player = player
        self.present(playerViewController, animated: true, completion: {
            self.playerViewController.player!.play()
        })
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return UITableView.automaticDimension
        } else {
            return 40
        }
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return UITableView.automaticDimension
        } else {
            return 40
        }
    }
    
    
     func activityIndicator() {
        indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 500, height: 500))
        indicator.style = UIActivityIndicatorView.Style.large
        indicator.color = .darkGray
        indicator.center = self.view.center
        self.view.addSubview(indicator)
        }
}

extension MediaListVC: UISearchBarDelegate {
    
    func filterMedia(selectedScope: Int) -> String {
        if selectedScope == 1 {
            return MediaType.music.rawValue
        } else if selectedScope == 2 {
            return MediaType.tvShow.rawValue
        } else if selectedScope == 3 {
            return MediaType.movie.rawValue
        }
        return MediaType.all.rawValue
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchController.searchBar.text else { return }
        let selectedScope = filterMedia(selectedScope: searchController.searchBar.selectedScopeButtonIndex)
        getData(search: text, scope: selectedScope)
        database.updateCacheData(text: text)
    }

}

