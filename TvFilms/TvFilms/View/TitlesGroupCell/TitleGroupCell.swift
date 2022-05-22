//
//  TitleGroupCell.swift
//  TvFilms
//
//  Created by Малиль Дугулюбгов on 16.03.2022.
//

import UIKit

class TitleGroupCell: UITableViewCell {
    
    //MARK: Properties
    
    var viewModel: TitlesGroupCellViewModelProtocol! {
        didSet {
            viewModel.fetchTitles { [weak self] in
                self?.titlesCollectionView.reloadData()
            }
        }
    }
    
    //MARK: - View
    
    private lazy var titlesCollectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .horizontal
//        collectionViewLayout.itemSize = CGSize(width: 140, height: 240)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        
        collectionView.register(TitlesListCell.self, forCellWithReuseIdentifier: TitlesListCell.identifier)
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    //MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(titlesCollectionView)
        titlesCollectionView.dataSource = self
        titlesCollectionView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titlesCollectionView.frame = contentView.bounds
    }
}

//MARK: - UICollectionViewDataSource

extension TitleGroupCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfTitles
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitlesListCell.identifier, for: indexPath) as? TitlesListCell else {
            return UICollectionViewCell()
        }
        cell.titleID = self.viewModel.titleIDForCell(at: indexPath)
        cell.viewModel = self.viewModel.viewModelForCell(at: indexPath)
        return cell
    }
}

//MARK: - UICollectionViewDelegate

extension TitleGroupCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        viewModel.showTitlePage(for: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let titleInteractions = TitleCellContextMenuBuilder(viewModel: self.viewModel)
        return titleInteractions.configureContextMenuForCell(at: indexPath)
    }
}

extension TitleGroupCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableHeight = collectionView.bounds.height
        return CGSize(width: availableHeight / 1.5, height: availableHeight)
    }
}
