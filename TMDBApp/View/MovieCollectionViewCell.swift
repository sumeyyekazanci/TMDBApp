//
//  MovieCollectionViewCell.swift
//  TMDBApp
//
//  Created by Sümeyye Kazancı on 1.09.2022.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    static let identifier = "MovieCollectionViewCell"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let overviewLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.lineBreakMode = .byWordWrapping
        label.textColor = .white
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        return imageView
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(posterImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(overviewLabel)
        
        applyConstraints()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    private func applyConstraints() {
        let posterImageViewConstraints = [
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            posterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            posterImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ]
        
        
        let titleLabelConstraints = [
//            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.bottomAnchor.constraint(equalTo: overviewLabel.topAnchor, constant: -10),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
//            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ]
        
        let overviewLabelConstraints = [
//            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            overviewLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            overviewLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -50),
            overviewLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
//            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ]
        
        NSLayoutConstraint.activate(posterImageViewConstraints)
        NSLayoutConstraint.activate(titleLabelConstraints)
        NSLayoutConstraint.activate(overviewLabelConstraints)
    }
    
    
    
    public func configure(with model: MovieViewModel) {
        
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model.posterURL)") else {
            return
        }
        posterImageView.sd_setImage(with: url, completed: nil)
        titleLabel.text = model.title
        overviewLabel.text = model.overview
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
