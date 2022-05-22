//
//  ViewModelRouteDelegate.swift
//  TvFilms
//
//  Created by Малиль Дугулюбгов on 22.05.2022.
//

import Foundation

protocol ViewModelRouteDelegate: AnyObject {
    func showTitlePage(with title: TMDBTitle)
}
