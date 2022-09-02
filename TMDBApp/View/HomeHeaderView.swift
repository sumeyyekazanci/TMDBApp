//
//  HomeHeaderView.swift
//  TMDBApp
//
//  Created by Sümeyye Kazancı on 1.09.2022.
//

import UIKit

class HomeHeaderView: UIView {
    private var nowPlayingMovies: [Movie] = [Movie]()
    
    static let identifier = "CollectionViewCell"
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        //layout.minimumLineSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: MovieCollectionViewCell.identifier)
        return collectionView
    }()
    
    private let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = 5
        return pageControl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        pageControl.addTarget(self, action: #selector(pageControlDidChange(_:)), for: .valueChanged)
        
        addSubview(collectionView)
        addSubview(pageControl)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        
        pageControl.frame = CGRect(x: 0, y: frame.size.height - 60, width: 70, height: 70)
        fetchNowPlayingMovies()
    }
    
    @objc func pageControlDidChange(_ sender: UIPageControl) {
        let current = sender.currentPage
        let indexPath = IndexPath(item: current, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    private func fetchNowPlayingMovies() {
        Task {
            let result = await MovieAPI.shared.getNowPlayingMovies()
            switch result {
            case .success(let movies):
                nowPlayingMovies = movies
                print("now playing movies \(nowPlayingMovies)")
                DispatchQueue.main.async {
                    self.pageControl.numberOfPages = self.nowPlayingMovies.count
                    self.collectionView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HomeHeaderView: UICollectionViewDelegate,UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.identifier, for: indexPath) as? MovieCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let movie = nowPlayingMovies[indexPath.row]
        cell.configure(with: MovieViewModel(title: (movie.originalTitle ?? movie.originalName) ?? "Unknown title", posterURL: movie.posterPath ?? "", overview: movie.overview ?? "", releaseDate: movie.releaseDate ?? "", rate: String(movie.voteAverage ?? 0)))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return nowPlayingMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = nowPlayingMovies[indexPath.row]
        
        guard let id = movie.id else {
            return
        }
        
        Task {
            let result = await MovieAPI.shared.getMovieDetail(id: id)
            switch result {
            case .success(let movie):
                DispatchQueue.main.async {
                    let vc = DetailViewController()
                    vc.title = movie.title ?? ""
                    vc.configure(with: MovieViewModel(title: movie.title ?? "", posterURL: movie.posterPath ?? "", overview: movie.overview ?? "", releaseDate: movie.releaseDate ?? "", rate: String(movie.voteAverage ?? 0)))
                    self.findViewController()?.navigationController?.pushViewController(vc, animated: true)
                    
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        pageControl.currentPage = indexPath.row
    }
}

extension HomeHeaderView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension UIView {
    func findViewController() -> UIViewController? {
        if let nextResponder = self.next as? UIViewController {
            return nextResponder
        } else if let nextResponder = self.next as? UIView {
            return nextResponder.findViewController()
        } else {
            return nil
        }
    }
}
