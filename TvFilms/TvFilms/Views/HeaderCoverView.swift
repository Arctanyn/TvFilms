//
//  HeaderCoverView.swift
//  TvFilms
//
//  Created by Малиль Дугулюбгов on 18.03.2022.
//

import UIKit

protocol HeaderCoverViewDelegate: AnyObject {
    func learnMoreAbout(title: TitleViewModel) -> Void
}

class HeaderCoverView: UIView {
    
    private lazy var headerShadowGradient = CAGradientLayer.posterShadow()
    
    //MARK: Properties
    
    private var headerTitleModel: TitleViewModel?
    weak var delegate: HeaderCoverViewDelegate?
    
    //MARK: - View
    
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
        label.numberOfLines = 5
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
        setConstraints()
        coverImageView.layer.addSublayer(headerShadowGradient)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        coverImageView.frame = self.bounds
        headerShadowGradient.frame = coverImageView.bounds
    }
    
    //MARK: - Methods
    
    func configure(with model: TitleViewModel) {
        let imageURL = SourceURL.imagePath + model.posterURL
        DataProvider.shared.fetchData(from: imageURL) { [weak self] data in
            guard let imageData = data, let image = UIImage(data: imageData) else { return }
            DispatchQueue.main.async {
                self?.coverImageView.image = image
                self?.titleNameLabel.text = model.name
                self?.titleOverviewLabel.text = model.overview
            }
        }
        headerTitleModel = model
    }
    
    //MARK: - Ations
    
    @objc private func detailedButtonDidTapped() {
        guard let titleModel = headerTitleModel else { return }
        delegate?.learnMoreAbout(title: titleModel)
    }
    
    //MARK: - Private methods
    
    private func setConstraints() {
        addSubview(detailedButton)
        let detailedButtonConstraints = [
            detailedButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            detailedButton.heightAnchor.constraint(equalToConstant: 35),
            detailedButton.widthAnchor.constraint(equalToConstant: 150),
            detailedButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16)
        ]
        
        addSubview(titleOverviewLabel)
        let titleOverviewLabelConstraints = [
            titleOverviewLabel.bottomAnchor.constraint(equalTo: detailedButton.topAnchor, constant: -20),
            titleOverviewLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            titleOverviewLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ]

        addSubview(titleNameLabel)
        let titleNameLabelConstraints = [
            titleNameLabel.bottomAnchor.constraint(equalTo: titleOverviewLabel.topAnchor, constant: -10),
            titleNameLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            titleNameLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
        ]
        
        NSLayoutConstraint.activate(detailedButtonConstraints)
        NSLayoutConstraint.activate(titleOverviewLabelConstraints)
        NSLayoutConstraint.activate(titleNameLabelConstraints)
    }
}
