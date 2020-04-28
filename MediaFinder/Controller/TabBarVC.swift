//
//  TabBar.swift
//  MediaFinder
//
//  Created by Ahmed Ezzat on 3/25/20.
//  Copyright © 2020 Ahmed Ezzat. All rights reserved.
//

import UIKit

class TabBarVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTabBar()
    }
    
    func setUpTabBar() {
        
        let mediaListVC = UIStoryboard(name: Storyboards.main, bundle: nil).instantiateViewController(withIdentifier: VCs.mediaListVC) as! MediaListVC
        let mediaListNav = UINavigationController(rootViewController: mediaListVC)
        let moviesIcon = UITabBarItem.init(title: "Media", image: UIImage(named: "movie"), tag: 0)
        mediaListVC.tabBarItem = moviesIcon
        let profileVC = UIStoryboard(name: Storyboards.main, bundle: nil).instantiateViewController(withIdentifier: VCs.profileVC) as! ProfileVC
        let profileNav = UINavigationController(rootViewController: profileVC)
        let profileIcon = UITabBarItem.init(title: "Profile", image: UIImage(named: "profile"), tag: 1)
        profileVC.tabBarItem = profileIcon
        let controllers = [mediaListNav, profileNav]
        self.viewControllers = controllers
        tabBar.backgroundColor = .white
    }
    
}
