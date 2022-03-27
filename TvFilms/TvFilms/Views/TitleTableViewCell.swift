//
//  TitleTableViewCell.swift
//  TvFilms
//
//  Created by Малиль Дугулюбгов on 18.03.2022.
//

import UIKit

class TitleTableViewCell: UITableViewCell {

    static let identifier = "TitleCell"
    
    //MARK: Properties
    
    private var titleVoteAverageValue: Double = 0
    
    //MARK: - View
    
    private lazy var posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.backgroundColor = .lightGray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var titleNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .heavy)
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var titleOverviewLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 8
        label.textColor = .lightGray
        return label
    }()
    
    private lazy var titleVoteAverageLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .heavy)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setVoteAverageLabelColor()
    }
    
    //MARK: - Methods
    
    func configure(with model: TitleViewModel) {
        posterImageView.image = nil
        titleVoteAverageValue = model.voteAverage
        let imageURL = SourceURL.imagePath + model.posterURL
        DataProvider.shared.fetchData(from: imageURL) { data in
            guard let imageData = data, let image = UIImage(data: imageData)
            else { return }
            DispatchQueue.main.async { [weak self] in
                self?.posterImageView.image = image
                self?.titleNameLabel.text = model.name
                self?.titleOverviewLabel.text = model.overview
                self?.titleVoteAverageLabel.text = model.voteAverage != 0 ? "\(model.voteAverage)" : ""
            }
        }
    }

    //MARK: - Private methods
    
    private func setConstraints() {
        contentView.addSubview(posterImageView)
        let posterImageViewConstraints = [
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            posterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            posterImageView.widthAnchor.constraint(equalToConstant: 140)
        ]
        
        contentView.addSubview(titleVoteAverageLabel)
        let voteAverageLabelConstraints = [
            titleVoteAverageLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            titleVoteAverageLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            titleVoteAverageLabel.widthAnchor.constraint(equalToConstant: 30)
        ]
        
        contentView.addSubview(titleNameLabel)
        let titleNameLabelConstraints = [
            titleNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            titleNameLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 16),
            titleNameLabel.trailingAnchor.constraint(equalTo: titleVoteAverageLabel.leadingAnchor, constant: -10)
        ]
        
        contentView.addSubview(titleOverviewLabel)
        let titleOverviewLabelConstraints = [
            titleOverviewLabel.topAnchor.constraint(equalTo: titleNameLabel.bottomAnchor, constant: 10),
            titleOverviewLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 16),
            titleOverviewLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            titleOverviewLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -10)
        ]
        
        NSLayoutConstraint.activate(posterImageViewConstraints)
        NSLayoutConstraint.activate(voteAverageLabelConstraints)
        NSLayoutConstraint.activate(titleNameLabelConstraints)
        NSLayoutConstraint.activate(titleOverviewLabelConstraints)
    }
    
    private func setVoteAverageLabelColor() {
        switch titleVoteAverageValue {
        case 0..<4:
            titleVoteAverageLabel.textColor = .systemRed
        case 4..<7:
            titleVoteAverageLabel.textColor = .systemOrange
        case 7...:
            titleVoteAverageLabel.textColor = .systemGreen
        default:
            break
        }
    }

}
