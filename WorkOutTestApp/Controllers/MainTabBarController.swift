//
//  MainTabBarController.swift
//  WorkOutTestApp
//
//  Created by Konstantin on 20.01.2022.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTabBar()
        setupItems()
    }
    
    private func setupTabBar() {
        tabBar.backgroundColor = .specialTabBar
        tabBar.tintColor = .specialDarkGreen
        tabBar.unselectedItemTintColor = .specialGray
        tabBar.layer.borderWidth = 1
        tabBar.layer.borderColor = UIColor.specialLightBrown.cgColor
    }
    
    private func setupItems() {
        let mainVC = MainViewController()
        let statisticVC = StatisticViewController()
        let profileVC = ProfileViewController()
        
        setViewControllers([mainVC, statisticVC, profileVC], animated: true)
        
        guard let items = tabBar.items else { return }
        
        let mainItems = items[0]
        let statisticItems = items[1]
        let profileItems = items[2]
        
        mainItems.title = "Main"
        statisticItems.title = "Statistic"
        profileItems.title = "Profile"
        
        mainItems.image = UIImage(named: "tabBarMain")
        statisticItems.image = UIImage(named: "tabBarStatistic")
        profileItems.image = UIImage(named: "tabBarProfile")
    }
    
}
