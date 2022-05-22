//
//  TitleCellActionsBuilder.swift
//  TvFilms
//
//  Created by Малиль Дугулюбгов on 22.05.2022.
//

import UIKit

struct TitleCellActionsBuilder {
    func createDeleteAction(performedAction: @escaping () -> Void) -> UIAction {
        UIAction(title: "Delete bookmark", image: UIImage(systemName: "bookmark.slash"), attributes: .destructive) { _ in
            performedAction()
        }
    }
    
    func createAddToBookmarksAction(performedAction: @escaping () -> Void) -> UIAction {
        UIAction(title: "Add to bookmarks", image: UIImage(systemName: "bookmark")) { _ in
            performedAction()
        }
    }
    
    func createLearnMoreAction(performedAction: @escaping () -> Void) -> UIAction {
        UIAction(title: "Learn more", image: UIImage(systemName: "ellipsis.circle")) { _ in
            performedAction()
        }
    }
}
