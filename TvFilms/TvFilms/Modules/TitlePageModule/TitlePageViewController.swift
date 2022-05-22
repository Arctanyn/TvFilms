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
    
    var viewModel: TitlePageViewModelProtocol! {
        didSet {
            viewModel.viewModelDidChange = { [unowned self] changedModel in
                setupBookmarkButton()
            }
            updateUI()
        }
    }
    
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
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var backgroundView: TitlePageBackgroundView = {
        let titleBackgroundView = TitlePageBackgroundView()
        titleBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        return titleBackgroundView
    }()
    
    private lazy var titleVoteAverageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    
    private lazy var titleNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 25, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var titleOverviewLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
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
        let image = UIImage(
            systemName: "xmark",
            withConfiguration: UIImage.SymbolConfiguration(
                pointSize: 25,
                weight: .semibold
            )
        )
        button.setImage(image, for: .normal)
        button.tintColor = .label
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var bookmarkButton: UIButton = {
        let button = UIButton()
        button.tintColor = .orange
        button.backgroundColor = .black
        button.layer.borderColor = UIColor.orange.cgColor
        button.layer.borderWidth = 2
        button.clipsToBounds = true
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(bookmarksButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var webView: WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.backgroundColor = .systemBackground
        webView.clipsToBounds = true
        webView.layer.cornerRadius = 8
        return webView
    }()
    
    private lazy var starImageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(systemName: "star.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20))
        imageView.image = image
        imageView.tintColor = .orange
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var overviewBlockLabel = setupSectionLabel(text: "Overview")
    
    private lazy var trailerBlockLabel = setupSectionLabel(text: "Trailer")
    
    //MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setConstraints()
    }
    
    //MARK: - Ations
    
    @objc private func closeButtonTapped() {
        viewModel.closeTitlePage()
    }
    
    @objc private func bookmarksButtonTapped() {
        viewModel.toggleFavouriteStatus()
    }
    
    //MARK: - Private methods
    
    private func updateUI() {
        titleNameLabel.text = viewModel.titleName
        titleOverviewLabel.text = viewModel.overview
        titleVoteAverageLabel.text = viewModel.voteAverage
        setupBookmarkButton()
        fetchImages()
        loadWebView()
    }
    
    private func fetchImages() {
        viewModel.fetchPosterImage { [unowned self] imageData in
            guard
                let imageData = imageData,
                let posterImage = UIImage(data: imageData)
            else { return }
            posterImageView.image = posterImage
            backgroundView.setImage(posterImage)
        }
    }
    
    private func loadWebView() {
        viewModel.fetchTitleTrailer { [unowned self] videoURL in
            webView.load(URLRequest(url: videoURL))
        }
    }
    
    private func setupBookmarkButton() {
        let image = viewModel.isFavourite ? UIImage(systemName: "bookmark.fill") : UIImage(systemName: "bookmark")
        bookmarkButton.setImage(image, for: .normal)
    }
    
    private func setupSectionLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = "\(text):"
        label.font = .systemFont(ofSize: 19, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    //MARK: - Constraints
    
    private func setConstraints() {
        setScrollViewConstraints()
        setContainerViewConstraints()
        configureContainerView()
    }
    
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
    
    private func setContainerViewConstraints() {
        scrollView.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            containerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    private func configureContainerView() {
        //Posters
        setPostersConstraints()
        
        //Buttons
        setActionButtonsConstraints()
        
        //Title name
        containerView.addSubview(titleNameLabel)
        NSLayoutConstraint.activate([
            titleNameLabel.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 10),
            titleNameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            titleNameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            titleNameLabel.bottomAnchor.constraint(lessThanOrEqualTo: backgroundView.bottomAnchor, constant: -10)
        ])
        
        //Votes block
        setRatingBlockConstraints()
        
        //Overview block
        setOverviewBlockConstraints()
        
        //Trailer block
        setTrailerBlockConstraints()
    }
    
    private func setPostersConstraints() {
        //Background image
        containerView.addSubview(backgroundView)
        let backgroundImageConstrains = [
            backgroundView.topAnchor.constraint(equalTo: containerView.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        ]
        
        //Poster image
        containerView.addSubview(posterImageView)
        let posterImageConstraints = [
            posterImageView.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 10),
            posterImageView.widthAnchor.constraint(equalToConstant: 220),
            posterImageView.heightAnchor.constraint(equalTo: posterImageView.widthAnchor, multiplier: 1.5),
            posterImageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor)
        ]
        
        NSLayoutConstraint.activate(backgroundImageConstrains)
        NSLayoutConstraint.activate(posterImageConstraints)
    }
    
    private func setActionButtonsConstraints() {
        //Close button
        containerView.addSubview(closeButton)
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            closeButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10)
        ])
        
        //Bookmark button
        containerView.addSubview(bookmarkButton)
        NSLayoutConstraint.activate([
            bookmarkButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            bookmarkButton.widthAnchor.constraint(equalToConstant: 35),
            bookmarkButton.heightAnchor.constraint(equalToConstant: 35),
            bookmarkButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10)
        ])
    }
    
    private func setRatingBlockConstraints() {
        
        //Star image
        containerView.addSubview(starImageView)
        let starImageViewConstraints = [
            starImageView.topAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: 10),
            starImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16)
        ]
        
        //Vote label
        containerView.addSubview(titleVoteAverageLabel)
        let titleVoteAverageLabelConstraints = [
            titleVoteAverageLabel.leadingAnchor.constraint(equalTo: starImageView.trailingAnchor, constant: 5),
            titleVoteAverageLabel.centerYAnchor.constraint(equalTo: starImageView.centerYAnchor)
        ]
        
        NSLayoutConstraint.activate(starImageViewConstraints)
        NSLayoutConstraint.activate(titleVoteAverageLabelConstraints)
    }
    
    private func setOverviewBlockConstraints() {
        //Overview block label
        containerView.addSubview(overviewBlockLabel)
        let overviewBlockLabelConstraints = [
            overviewBlockLabel.topAnchor.constraint(equalTo: starImageView.bottomAnchor, constant: 20),
            overviewBlockLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16)
        ]
        
        //Title overview
        containerView.addSubview(titleOverviewLabel)
        let titleOverviewLabelConstraints = [
            titleOverviewLabel.topAnchor.constraint(equalTo: overviewBlockLabel.bottomAnchor, constant: 5),
            titleOverviewLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            titleOverviewLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
        ]
        
        NSLayoutConstraint.activate(overviewBlockLabelConstraints)
        NSLayoutConstraint.activate(titleOverviewLabelConstraints)
    }
    
    private func setTrailerBlockConstraints() {
        //Trailer block label
        containerView.addSubview(trailerBlockLabel)
        let trailerBlockLabelConstraints = [
            trailerBlockLabel.topAnchor.constraint(equalTo: titleOverviewLabel.bottomAnchor, constant: 20),
            trailerBlockLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
        ]
        
        //Web view
        containerView.addSubview(webView)
        let webViewConstraints = [
            webView.topAnchor.constraint(equalTo: trailerBlockLabel.bottomAnchor, constant: 10),
            webView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            webView.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: -10),
            webView.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.9),
            webView.heightAnchor.constraint(equalTo: webView.widthAnchor, multiplier: 0.6)
        ]
        
        NSLayoutConstraint.activate(trailerBlockLabelConstraints)
        NSLayoutConstraint.activate(webViewConstraints)
    }
}

