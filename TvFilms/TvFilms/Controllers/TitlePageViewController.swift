//
//  TitlePageViewController.swift
//  TvFilms
//
//  Created by Малиль Дугулюбгов on 19.03.2022.
//

import UIKit
import WebKit

class TitlePageViewController: UIViewController {
    
    //MARK: Properties
    
    private var titleModel: TitleModel?
    
    //MARK: - View
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private lazy var posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .lightGray
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var backgroundView: TitlePageBackgroundView = {
        let titleBackgroundView = TitlePageBackgroundView()
        titleBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        return titleBackgroundView
    }()
    
    private lazy var titleVoteAverageLabel: UILabel = {
        let atributedString = NSMutableAttributedString()
        
        let starAttachment = NSTextAttachment()
        let starImage = UIImage(systemName: "star.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 25))?.withTintColor(.orange)
        starAttachment.image = starImage
        
        atributedString.append(NSAttributedString(attachment: starAttachment))
        
        if let voteAverageValue = titleModel?.vote_average, voteAverageValue != 0 {
            atributedString.append(NSAttributedString(string: " \(voteAverageValue) / 10"))
        } else {
            atributedString.append(NSAttributedString(string: " No ratings"))
        }
        
        let label = UILabel()
        label.attributedText = atributedString
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        
        return label
    }()
    
    private lazy var titleNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var titleOverviewLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 15)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var containerView: UIView = {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        return container
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "xmark", withConfiguration: UIImage.SymbolConfiguration(pointSize: 25))
        button.setImage(image, for: .normal)
        button.tintColor = .label
        button.addTarget(self, action: #selector(closeButtonDidTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var addToBookmarksButton: UIButton = {
        let button = UIButton()
        button.configuration = .tinted()
        button.configuration?.image = UIImage(systemName: "bookmark")
        button.configuration?.title = "Add to bookmarks"
        button.configuration?.imagePadding = 6
        button.configuration?.baseBackgroundColor = .systemOrange
        button.configuration?.baseForegroundColor = .orange
        button.addTarget(self, action: #selector(addToBookmarksButtonDidTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var webView: WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.backgroundColor = .systemBackground
        return webView
    }()
    
    //MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setScrollViewConstraints()
        configureContainerView()
        setContainerViewConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    //MARK: - Methods
    
    func configure(with title: TitleModel, canAddBookmarks: Bool = true) {
        
        addToBookmarksButton.isHidden = !canAddBookmarks
        
        let posterURL = SourceURL.imagePath + (title.poster_path ?? "")
        let backgroundURL = SourceURL.imagePath + (title.backdrop_path ?? "")
        
        DispatchQueue.main.async { [weak self] in
            self?.titleNameLabel.text = title.original_name ?? title.original_title
            self?.titleOverviewLabel.text = title.overview
        }
        
        DataProvider.shared.fetchData(from: posterURL) { [posterImageView] data in
            guard let imageData = data, let image = UIImage(data: imageData) else { return }
            DispatchQueue.main.async {
                posterImageView.image = image
            }
        }
        DataProvider.shared.fetchData(from: backgroundURL) { [backgroundView] data in
            guard let imageData = data, let image = UIImage(data: imageData) else { return }
            DispatchQueue.main.async {
                backgroundView.setImage(image)
            }
        }
        
        APICaller.shared.getYouTubeVideo(query: "\((title.original_name ?? title.original_title) ?? "") official trailer") { [webView] result in
            switch result {
            case .success(let videoComponents):
                guard let id = videoComponents.id?.videoId,
                      let url = URL(string: "https://www.youtube.com/embed/\(id)")
                else { return }
                DispatchQueue.main.async {
                    webView.load(URLRequest(url: url))
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        titleModel = title
    }
    
    //MARK: - Ations
    
    @objc private func closeButtonDidTapped() {
        dismiss(animated: true)
    }
    
    @objc private func addToBookmarksButtonDidTapped() {
        guard let title = titleModel else { return }
        StorageManager.shared.save(title)
        showAlert(title: "Page has been added", message: "You can go to it on the Bookmarks page")
    }
    
    //MARK: - Private methods
    
    private func setScrollViewConstraints() {
        view.addSubview(scrollView)
        let scrollViewConstraints = [
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ]
        NSLayoutConstraint.activate(scrollViewConstraints)
    }
    
    private func configureContainerView() {
        //Background poster view
        
        containerView.addSubview(backgroundView)
        let backgroundImageConstrains = [
            backgroundView.topAnchor.constraint(equalTo: containerView.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        ]
        
        //Close button
        
        containerView.addSubview(closeButton)
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            closeButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10)
        ])
        
        //Poster image
        
        containerView.addSubview(posterImageView)
        let posterImageConstraints = [
            posterImageView.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 10),
            posterImageView.widthAnchor.constraint(equalToConstant: 180),
            posterImageView.heightAnchor.constraint(equalToConstant: 280),
            posterImageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor)
        ]
        
        //Title name
        
        containerView.addSubview(titleNameLabel)
        let titleNameLabelConstraints = [
            titleNameLabel.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 10),
            titleNameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            titleNameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            titleNameLabel.bottomAnchor.constraint(lessThanOrEqualTo: backgroundView.bottomAnchor, constant: -10)
        ]
        
        //Title vote average
        
        containerView.addSubview(titleVoteAverageLabel)
        let titleVoteAverageLabelConstraints = [
            titleVoteAverageLabel.topAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: 10),
            titleVoteAverageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            titleVoteAverageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16)
        ]
        
        //Overview section label
        
        lazy var overviewSectionLabel = setupSectionLabel(text: "Overview")
        containerView.addSubview(overviewSectionLabel)
        let overviewSectionLabelConstraints = [
            overviewSectionLabel.topAnchor.constraint(equalTo: titleVoteAverageLabel.bottomAnchor, constant: 20),
            overviewSectionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16)
        ]
        
        //Title overview
        
        containerView.addSubview(titleOverviewLabel)
        let titleOverviewLabelConstraints = [
            titleOverviewLabel.topAnchor.constraint(equalTo: overviewSectionLabel.bottomAnchor, constant: 5),
            titleOverviewLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            titleOverviewLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
        ]
        
        //Trailer section label
        
        lazy var titleTrailerSectionLabel = setupSectionLabel(text: "Trailer")
        containerView.addSubview(titleTrailerSectionLabel)
        let titleTrailerSectionLabelConstraints = [
            titleTrailerSectionLabel.topAnchor.constraint(equalTo: titleOverviewLabel.bottomAnchor, constant: 20),
            titleTrailerSectionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
        ]
        
        //Web view
        
        containerView.addSubview(webView)
        let webViewConstraints = [
            webView.topAnchor.constraint(equalTo: titleTrailerSectionLabel.bottomAnchor, constant: 10),
            webView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
        ]
        
        //Add to bookmarks button
        
        containerView.addSubview(addToBookmarksButton)
        let addToBookmarksButtonConstraints = [
            addToBookmarksButton.topAnchor.constraint(equalTo: webView.bottomAnchor, constant: 20),
            addToBookmarksButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            addToBookmarksButton.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: -10),
        ]
        
        //Activate constraints
        
        NSLayoutConstraint.activate(backgroundImageConstrains)
        NSLayoutConstraint.activate(posterImageConstraints)
        NSLayoutConstraint.activate(titleNameLabelConstraints)
        NSLayoutConstraint.activate(titleVoteAverageLabelConstraints)
        NSLayoutConstraint.activate(overviewSectionLabelConstraints)
        NSLayoutConstraint.activate(titleOverviewLabelConstraints)
        NSLayoutConstraint.activate(titleTrailerSectionLabelConstraints)
        NSLayoutConstraint.activate(webViewConstraints)
        NSLayoutConstraint.activate(addToBookmarksButtonConstraints)
    }
    
    private func setContainerViewConstraints() {
        scrollView.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            containerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        webView.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.9).isActive = true
        webView.heightAnchor.constraint(equalTo: webView.widthAnchor, multiplier: 0.6).isActive = true
    }
    
    private func setupSectionLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = "\(text):"
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}

