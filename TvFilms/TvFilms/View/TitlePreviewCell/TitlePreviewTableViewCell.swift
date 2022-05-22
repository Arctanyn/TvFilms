//
//  TitlePreviewTableViewCell.swift
//  TvFilms
//
//  Created by Малиль Дугулюбгов on 18.03.2022.
//

import UIKit

class TitlePreviewTableViewCell: UITableViewCell {

    //MARK: Properties
    
    var titleID: Int?
    
    static let identifier = "TitleCell"
    
    var viewModel: TitlePreviewCellViewModelProtocol! {
        didSet {
            titleNameLabel.text = viewModel.titleName
            titleOverviewLabel.text = viewModel.overview
            if let voteAverage = viewModel.voteAverage, voteAverage != 0 {
                titleVoteAverageLabel.text = "\(voteAverage)"
                titleVoteAverageLabel.textColor = determineVoteAverageColor(with: voteAverage)
            }
            if self.titleID == viewModel.titleID {
                posterImageView.image = nil
                viewModel.fetchPosterImage { [weak self] imageData in
                    guard let imageData = imageData else { return }
                    self?.posterImageView.image = UIImage(data: imageData)
                }
            } else { posterImageView.image = nil }
        }
    }
    
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
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var titleOverviewLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 5
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

    //MARK: - Private methods
    
    private func determineVoteAverageColor(with value: Double) -> UIColor {
        switch value {
        case 0..<5:
            return .systemRed
        case 5..<7:
            return .systemOrange
        default:
            return .systemGreen
        }
    }
    
    private func setConstraints() {
        contentView.addSubview(posterImageView)
        let posterImageViewConstraints = [
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            posterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            posterImageView.widthAnchor.constraint(equalToConstant: contentView.bounds.width * 0.4),
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

}
