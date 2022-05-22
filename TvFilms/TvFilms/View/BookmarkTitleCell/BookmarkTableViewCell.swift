//
//  BookmarkTableViewCell.swift
//  TvFilms
//
//  Created by Малиль Дугулюбгов on 12.04.2022.
//

import UIKit

class BookmarkTableViewCell: UITableViewCell {
    
    static let identifier = "BookmarkCell"
    
    var titleID: Int?
    
    var viewModel: BookmarkCellViewModelProtocol! {
        didSet {
            titleNameLabel.text = viewModel.titleName
            titleOverviewLabel.text = viewModel.overview
            
            if titleID == viewModel.titleID {
                backgroundImage.image = nil
                viewModel.fetchBackgroundImage { [unowned self] imageData in
                    guard let imageData = imageData else { return }
                    backgroundImage.image = UIImage(data: imageData)
                }
            } else {
                backgroundImage.image = nil
            }
        }
    }

    //MARK: - View
    
    private lazy var shadow = CAGradientLayer.posterShadow()
    
    private lazy var backgroundImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var titleNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var titleOverviewLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.numberOfLines = 3
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundImage.layer.addSublayer(shadow)
        contentView.addSubview(backgroundImage)
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
    
    
    //MARK: - Private methods
    
    private func setConstarints() {
        contentView.addSubview(titleOverviewLabel)
        NSLayoutConstraint.activate([
            titleOverviewLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleOverviewLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            titleOverviewLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
        
        contentView.addSubview(titleNameLabel)
        NSLayoutConstraint.activate([
            titleNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            titleNameLabel.bottomAnchor.constraint(equalTo: titleOverviewLabel.topAnchor, constant: -10),
        ])
    }
    
}
