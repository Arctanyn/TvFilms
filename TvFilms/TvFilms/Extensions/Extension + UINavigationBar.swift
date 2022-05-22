//
//  Extension + UINavigationBar.swift
//  TvFilms
//
//  Created by Малиль Дугулюбгов on 22.05.2022.
//

import UIKit

extension UINavigationBar {
    func setupNavigationBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        let textAttributes: [NSAttributedString.Key : Any] = [
            .foregroundColor: UIColor.label,
            .font: UIFont.systemFont(ofSize: 25, weight: .semibold)
        ]
        appearance.titleTextAttributes = textAttributes
        appearance.largeTitleTextAttributes = textAttributes
        appearance.backgroundColor = .systemBackground
        
        standardAppearance = appearance
        scrollEdgeAppearance = appearance
    }
}
