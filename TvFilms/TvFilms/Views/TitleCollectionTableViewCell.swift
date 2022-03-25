//
//  TitleCollectionTableViewCell.swift
//  TvFilms
//
//  Created by Малиль Дугулюбгов on 16.03.2022.
//

import UIKit

protocol TitleCollectionTableViewCellDelegate: AnyObject {
    func cellDidSelect(with title: TitleModel) -> Void
}

class TitleCollectionTableViewCell: UITableViewCell {
    
    static let identifier = "TitleCollectionCell"
    
    //MARK: Properties
    
    private var titles: [TitleModel] = []
    weak var delegate: TitleCollectionTableViewCellDelegate?
    
    //MARK: - View
    
    private lazy var titlesCollectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .horizontal
        collectionViewLayout.itemSize = CGSize(width: 140, height: 240)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
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
    
    //MARK: - Methods
    
    func configure(with titles: [TitleModel]) {
        self.titles = titles
        DispatchQueue.main.async { [weak self] in
            self?.titlesCollectionView.reloadData()
        }
    }
}

//MARK: - UICollectionViewDataSource

extension TitleCollectionTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as? TitleCollectionViewCell else {
            return UICollectionViewCell()
        }
        let title = titles[indexPath.item]
        let titleModel = TitleViewModel(of: title)
        cell.configure(with: titleModel)
        return cell
    }
}

//MARK: - UICollectionViewDelegate

extension TitleCollectionTableViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        delegate?.cellDidSelect(with: titles[indexPath.item])
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let title = titles[indexPath.row]
        let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { [weak self] _ in
            let addToBookmarks = UIAction(title: "Add to bookmarks", image: UIImage(systemName: "bookmark")) { _ in
                StorageManager.shared.save(title, completion: nil)
            }
            let learnMore = UIAction(title: "Learn more", image: UIImage(systemName: "ellipsis.circle")) { _ in
                Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { _ in
                    self?.delegate?.cellDidSelect(with: title)
                }
            }
            return UIMenu(title: (title.original_name ?? title.original_title) ?? "", image: nil, children: [addToBookmarks, learnMore])
        }
        return configuration
    }
}
