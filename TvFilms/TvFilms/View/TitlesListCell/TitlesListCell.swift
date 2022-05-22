//
//  TitlesListCell.swift
//  TvFilms
//
//  Created by Малиль Дугулюбгов on 16.03.2022.
//

import UIKit

class TitlesListCell: UICollectionViewCell {
    
    //MARK: Properties
    
    static let identifier = "TitleCollectionViewCell"
    
    var titleID: Int?
    
    var viewModel: TitlesListCellViewModelProtocol! {
        didSet {
            if titleID == viewModel.titleID {
                posterImageView.image = nil
                viewModel.fetchPoster { [weak self] imageData in
                    guard let imageData = imageData else { return }
                    self?.posterImageView.image = UIImage(data: imageData)
                }
            } else {
                posterImageView.image = nil
            }
        }
    }
    
    //MARK: - View
    
    private lazy var posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .lightGray
        return imageView
    }()
    
    //MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(posterImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        posterImageView.frame = contentView.bounds
    }
}
