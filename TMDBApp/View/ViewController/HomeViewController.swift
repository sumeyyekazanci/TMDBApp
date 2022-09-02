//
//  HomeViewController.swift
//  TMDBApp
//
//  Created by Sümeyye Kazancı on 31.08.2022.
//

import UIKit
import SDWebImage

class HomeViewController: UIViewController {
    
    private var upcomingMovies: [Movie] = [Movie]()
    var currentPage: Int = 1
    //var totalResults: Int = 0
    var totalPages: Int = 0
    
    let tableView: UITableView = {
        let table = UITableView()
        table.contentInsetAdjustmentBehavior = .never
        table.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.identifier)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backButton = UIBarButtonItem()
        backButton.title = ""
        backButton.tintColor = .label
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let homeHeaderView = HomeHeaderView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height * 0.3))
        tableView.tableHeaderView = homeHeaderView
        
        //fetchUpcomingMovies()
        fetchUpcomingMoviesResult(page: currentPage)
        
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.frame = view.bounds
    }
    
    @objc private func didPullToRefresh() {
        currentPage = 1
        fetchUpcomingMovies()
    }
    
    private func fetchUpcomingMovies() {
        Task {
            let result = await MovieAPI.shared.getUpcomingMovies()
            switch result {
            case .success(let upcoming):
                upcomingMovies = upcoming
                print("upcoming movies \(upcomingMovies)")
                DispatchQueue.main.async {
                    self.tableView.refreshControl?.endRefreshing()
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func fetchUpcomingMoviesResult(page: Int) {
        
        Task {
            let result = await MovieAPI.shared.getUpcomingMoviesResult(page: page)
            switch result {
            case .success(let upcoming):
                totalPages = upcoming.totalPages
//                totalResults = upcoming.totalResults
                //currentPage = upcoming.page
                upcomingMovies += upcoming.results
                print("upcoming movies \(upcomingMovies)")
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension HomeViewController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        upcomingMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifier, for: indexPath) as? MovieTableViewCell else {
            return UITableViewCell()
        }
        
        let movie = upcomingMovies[indexPath.row]
        cell.configure(with: MovieViewModel(title: (movie.originalTitle ?? movie.originalName) ?? "Unknown title", posterURL: movie.posterPath ?? "", overview: movie.overview ?? "", releaseDate: movie.releaseDate ?? "", rate: String(movie.voteAverage ?? 0)))
        if currentPage < totalPages {
            if indexPath.row == upcomingMovies.count - 1 {
                currentPage += 1
                fetchUpcomingMoviesResult(page: currentPage)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let movie = upcomingMovies[indexPath.row]
        
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
                    vc.configure(with: MovieViewModel(title: movie.title ?? "", posterURL: movie.posterPath ?? "", overview: movie.overview ?? "", releaseDate: movie.releaseDate ?? "", rate: String(format: "%.1f", movie.voteAverage ?? 0)))
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
