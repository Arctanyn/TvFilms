//
//  Extension + CAGradientLayer.swift
//  TvFilms
//
//  Created by Малиль Дугулюбгов on 20.03.2022.
//

import UIKit

extension CAGradientLayer {
    static func posterShadow() -> CAGradientLayer {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        return gradient
    }
}
