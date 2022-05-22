//
//  TitlePageBackgroundView.swift
//  TvFilms
//
//  Created by Малиль Дугулюбгов on 19.03.2022.
//

import UIKit

class TitlePageBackgroundView: UIView {
    
    private lazy var backgroundShadowGradient = CAGradientLayer.posterShadow()
    
    //MARK: - View
    
    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.opacity = 0.35
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    //MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(backgroundImageView)
        backgroundImageView.layer.addSublayer(backgroundShadowGradient)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundImageView.frame = bounds
        backgroundShadowGradient.frame = backgroundImageView.bounds
    }
    
    //MARK: - Methods
    
    func setImage(_ image: UIImage?) {
        backgroundImageView.image = image
    }
}
