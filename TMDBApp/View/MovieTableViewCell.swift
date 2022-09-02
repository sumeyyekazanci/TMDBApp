//
//  MovieTableViewCell.swift
//  TMDBApp
//
//  Created by Sümeyye Kazancı on 1.09.2022.
//

import UIKit

class MovieTableViewCell: UITableViewCell {
    static let identifier = "MovieTableViewCell"
    
    private let chevron: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "chevron.right", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20))
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .systemGray
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let overviewLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .semibold)
//        label.lineBreakMode = .byWordWrapping
        label.textColor = .systemGray
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(posterImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(overviewLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(chevron)
        
        applyConstraints()
        
    }
    
    
    private func applyConstraints() {
        let titlesPosterUIImageViewConstraints = [
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 10),
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            posterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            posterImageView.widthAnchor.constraint(equalToConstant: 120)
        ]
        
        
        let titleLabelConstraints = [
            titleLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 30)
        ]
        
        let overviewLabelConstraints = [
            overviewLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 20),
            overviewLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
            overviewLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10)
        ]
        
        let dateLabelConstraints = [
            dateLabel.trailingAnchor.constraint(equalTo: chevron.leadingAnchor, constant: -10),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ]
        
        let chevronConstraints = [
            chevron.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            chevron.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ]
        
        NSLayoutConstraint.activate(titlesPosterUIImageViewConstraints)
        NSLayoutConstraint.activate(titleLabelConstraints)
        NSLayoutConstraint.activate(overviewLabelConstraints)
        NSLayoutConstraint.activate(chevronConstraints)
        NSLayoutConstraint.activate(dateLabelConstraints)
    }
    
    
    
    public func configure(with model: MovieViewModel) {
        
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model.posterURL)") else {
            return
        }
        posterImageView.sd_setImage(with: url, completed: nil)
        titleLabel.text = model.title
        overviewLabel.text = model.overview
        let date = model.releaseDate.formatDate
        dateLabel.text = date
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
