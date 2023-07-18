//
//  LaunchsListViewController.swift
//  SpaceX
//
//  Created by Helia Fathi on 7/13/23.
//

import UIKit

class LaunchsListViewController: UIViewController {
    
    var viewModel = LaunchViewModel()
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(launchsListTableView)
        view.backgroundColor = UIColor(named: "DarkNight")
        launchsListTableView.delegate = self
        launchsListTableView.dataSource = self
        launchsListTableView.backgroundColor = UIColor(named: "DarkNight")
        refreshControl.addTarget(self, action: #selector(refreshPage(_:)), for: .valueChanged)
        
        self.viewModel.fetchData() { resual in
            switch resual {
            case .success(_):
                break
            case .failure(_):
                break
            }
        }
        launchsListTableView.refreshControl = refreshControl
        viewModel.$isLoading
            .filter { !$0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.launchsListTableView.reloadData()
            }
            .store(in: &viewModel.cancellables)
        
        viewModel.$launchData
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.launchsListTableView.reloadData()
            }
            .store(in: &viewModel.cancellables)
        launchsListTableView.reloadData()
        configUIElements()
    }
    
    @objc func refreshPage(_: AnyObject) {
        self.refreshControl.endRefreshing()
    }
    
    private lazy var launchsListTableView: UITableView = {
        let table = UITableView()
        table.showsHorizontalScrollIndicator = false
        table.translatesAutoresizingMaskIntoConstraints = false
        table.scrollIndicatorInsets = UIEdgeInsets(top: 30, left: 0, bottom: 0, right: -3)
        table.register(LaunchTableViewCell.self, forCellReuseIdentifier: LaunchTableViewCell.identifier)
        return table
    }()
    
    func configUIElements() {
        NSLayoutConstraint.activate([
            launchsListTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            launchsListTableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            launchsListTableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            launchsListTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension LaunchsListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.launchData.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: LaunchTableViewCell = tableView.dequeueReusableCell(withIdentifier: LaunchTableViewCell.identifier) as? LaunchTableViewCell else { fatalError("LaunchTableViewCell is invalid") }
        let launch = viewModel.launchData[indexPath.row]
        let photoInteractor = PhotoInteractorImpl(createDate: launch.dateUTC!, thumbUrl: URL(string: launch.smallImageURL!)!, filename: launch.flightNumber)
        cell.alpha = 0
        UIView.animate(withDuration: 0.5, delay: 0.05 * Double(indexPath.row), animations: { cell.alpha = 1 })
        cell.currentIndexPath = indexPath
        cell.configure(with: launch)
        cell.updateImage(with: photoInteractor, for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let launch = viewModel.launchData[indexPath.row]
        let photoInteractor = PhotoInteractorImpl(createDate: launch.dateUTC!,
                                                  thumbUrl: URL(string: launch.mainImage!)!,
                                                  filename: "\(launch.flightNumber)-main")
        let launchDetailsViewController = LaunchDetailsViewController()
        launchDetailsViewController.details = LaunchDetailsModel(name: launch.name,
                                                                 details: launch.details,
                                                                 mainImage: launch.mainImage,
                                                                 dateUTC: launch.dateUTC,
                                                                 isMarked: launch.isMarked,
                                                                 wikiLink: launch.wikipedia)
        launchDetailsViewController.updateImage(with: photoInteractor)
        let navigationController = UINavigationController(rootViewController: launchDetailsViewController)
        present(navigationController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.launchData.count - 1 {
            viewModel.fetchData { resualt in
                switch resualt {
                case .success(_):
                    break
                case .failure(_):
                    break
                }
            }
        }
    }
}
