//
//  MainTabBarController.swift
//  TvFilms
//
//  Created by Малиль Дугулюбгов on 16.03.2022.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    private let assemblyBuilder = AssemblyBuilder()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        tabBar.tintColor = .orange
        
        viewControllers = [
            createNavigationController(
                rootVC: assemblyBuilder.createHomePageModule(),
                tabBarTitle: "Home",
                tabBarImage: UIImage(systemName: "house"),
                tabBarSelectedImage: UIImage(systemName: "house.fill")
            ),
            createNavigationController(
                rootVC: assemblyBuilder.createUpcomingTitlesModule(),
                tabBarTitle: "Upcoming",
                tabBarImage: UIImage(systemName: "play.circle"),
                tabBarSelectedImage: UIImage(systemName: "play.circle.fill")
            ),
            createNavigationController(
                rootVC: assemblyBuilder.createBookmarksModule(),
                tabBarTitle: "Bookmarks",
                tabBarImage: UIImage(systemName: "bookmark"),
                tabBarSelectedImage: UIImage(systemName: "bookmark.fill")
            )
        ]
    }
    
    //MARK: - Private methods
    
    private func createNavigationController(rootVC: UIViewController, tabBarTitle: String, tabBarImage: UIImage?, tabBarSelectedImage: UIImage? = nil) -> UIViewController {
        let viewController = UINavigationController(rootViewController: rootVC)
        viewController.tabBarItem.image = tabBarImage
        viewController.tabBarItem.selectedImage = tabBarSelectedImage
        viewController.tabBarItem.title = tabBarTitle
        viewController.navigationBar.tintColor = .label
        return viewController
    }
    
}
