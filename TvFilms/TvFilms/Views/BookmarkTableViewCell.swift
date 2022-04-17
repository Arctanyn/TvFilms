//
//  BookmarkTableViewCell.swift
//  TvFilms
//
//  Created by Малиль Дугулюбгов on 12.04.2022.
//

import UIKit

class BookmarkTableViewCell: UITableViewCell {
    
    static let identifier = "BookmarkCell"
    
    private lazy var shadow = CAGradientLayer.posterShadow()

    //MARK: - View
    
    private lazy var backgroundImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var titleNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var titleOverviewLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.numberOfLines = 3
        label.font = .systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(backgroundImage)
        backgroundImage.layer.addSublayer(shadow)
        setConstarints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundImage.frame = contentView.bounds
        shadow.frame = backgroundImage.bounds
    }
    
    //MARK: - Methods
    
    func configure(with model: TitleViewModel) {
        backgroundImage.image = nil
        let imageURL = SourceURL.imagePath + model.backgroundPosterPath
        fetchImage(imageURL)
        DispatchQueue.main.async { [titleNameLabel, titleOverviewLabel] in
            titleNameLabel.text = model.name
            titleOverviewLabel.text = model.overview
        }
    }
    
    //MARK: - Private methods
    
    private func fetchImage(_ imageURL: String) {
        DataProvider.shared.fetchData(from: imageURL) { [backgroundImage] data in
            guard let imageData = data, let fetchedImage = UIImage(data: imageData) else { return }
            DispatchQueue.main.async {
                backgroundImage.image = fetchedImage
            }
        }
    }
    
    private func setConstarints() {
        contentView.addSubview(titleOverviewLabel)
        NSLayoutConstraint.activate([
            titleOverviewLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleOverviewLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            titleOverviewLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
        
        contentView.addSubview(titleNameLabel)
        NSLayoutConstraint.activate([
            titleNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            titleNameLabel.bottomAnchor.constraint(equalTo: titleOverviewLabel.topAnchor, constant: -10)
        ])
    }
    
}
