//
//  TitlesHeaderView.swift
//  TvFilms
//
//  Created by Малиль Дугулюбгов on 18.03.2022.
//

import UIKit

class TitlesHeaderView: UIView {
    
    //MARK: Properties
    
    var viewModel: TitlesHeaderViewViewModelProtocol! {
        didSet {
            viewModel.fetchTitle { [unowned self] in
                updateUI()
            }
        }
    }
    
    //MARK: - View
    
    private lazy var headerShadowGradient = CAGradientLayer.posterShadow()
    
    private lazy var containerView: UIView = {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        return container
    }()
    
    private lazy var coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .systemBackground
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var titleNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .heavy)
        label.numberOfLines = 2
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var titleOverviewLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 15)
        label.numberOfLines = 3
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var detailedButton: UIButton = {
        let button = UIButton()
        button.tintColor = .black
        button.setTitle(" LEARN MORE", for: .normal)
        button.setImage(UIImage(systemName: "ellipsis.circle.fill"), for: .normal)
        button.backgroundColor = .orange
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(detailedButtonDidTapped), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(coverImageView)
        coverImageView.layer.addSublayer(headerShadowGradient)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        headerShadowGradient.frame = coverImageView.bounds
        coverImageView.frame = self.bounds
        setConstraints()
    }
    
    //MARK: - Ations
    
    @objc private func detailedButtonDidTapped() {
        viewModel.showTitlePage()
    }
    
    //MARK: - Private methods
    
    private func updateUI() {
        titleNameLabel.text = viewModel.titleName
        titleOverviewLabel.text = viewModel.overview
        viewModel.fetchImageData { [weak self] imageData in
            guard let imageData = imageData else { return }
            self?.coverImageView.image = UIImage(data: imageData)
        }
    }
    
    private func setConstraints() {
//        addSubview(coverImageView)
//        NSLayoutConstraint.activate([
//            coverImageView.topAnchor.constraint(equalTo: topAnchor),
//            coverImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
//            coverImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
//            coverImageView.bottomAnchor.constraint(equalTo: bottomAnchor)
//        ])
        
        addSubview(detailedButton)
        let detailedButtonConstraints = [
            detailedButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            detailedButton.heightAnchor.constraint(equalToConstant: 35),
            detailedButton.widthAnchor.constraint(equalToConstant: 150),
            detailedButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20)
        ]
        
        addSubview(titleOverviewLabel)
        let titleOverviewLabelConstraints = [
            titleOverviewLabel.bottomAnchor.constraint(equalTo: detailedButton.topAnchor, constant: -20),
            titleOverviewLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            titleOverviewLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ]

        addSubview(titleNameLabel)
        let titleNameLabelConstraints = [
            titleNameLabel.bottomAnchor.constraint(equalTo: titleOverviewLabel.topAnchor, constant: -10),
            titleNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            titleNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
        ]
        
        NSLayoutConstraint.activate(detailedButtonConstraints)
        NSLayoutConstraint.activate(titleOverviewLabelConstraints)
        NSLayoutConstraint.activate(titleNameLabelConstraints)
    }
}
