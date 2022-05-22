//
//  TitleActionsViewModelProtocol.swift
//  TvFilms
//
//  Created by Малиль Дугулюбгов on 22.05.2022.
//

import Foundation

protocol TitleActionsViewModelProtocol {
    func isTitleInStorage(at indexPath: IndexPath) -> Bool
    func learnMoreAboutTitle(at indexPath: IndexPath)
    func deleteBookmark(at indexPath: IndexPath)
    func addBookmarkForTitle(at indexPath: IndexPath)
}
