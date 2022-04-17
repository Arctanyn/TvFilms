//
//  Extension + ViewController.swift
//  TvFilms
//
//  Created by Малиль Дугулюбгов on 17.04.2022.
//

import UIKit

extension UIViewController {
   func presentTitlePage(with title: TitleModel) {
        let titlePageVC = TitlePageViewController()
        titlePageVC.configure(with: title)
        titlePageVC.modalPresentationStyle = .fullScreen
        present(titlePageVC, animated: true)
    }
    
    func setupTitleContextMenu(_ title: TitleModel) -> UIContextMenuConfiguration {
        let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { [weak self] _ in
            let learnMore = UIAction(title: "Learn more", image: UIImage(systemName: "ellipsis.circle")) { _ in
                Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { [weak self] _ in
                    self?.presentTitlePage(with: title)
                }
            }
            
            let bookmarkAction: UIAction
            
            if StorageManager.shared.isInStorage(title) {
                bookmarkAction = UIAction(
                    title: "Delete bookmark",
                    image: UIImage(systemName: "bookmark.slash"),
                    attributes: .destructive) { _ in
                        StorageManager.shared.delete(title)
                    }
            } else {
                bookmarkAction = UIAction(title: "Add to bookmarks", image: UIImage(systemName: "bookmark")) { _ in
                    StorageManager.shared.save(title)
                }
            }
            return UIMenu(title: (title.original_name ?? title.original_title) ?? "", image: nil, children: [bookmarkAction, learnMore])
        }
        return configuration
    }
}
