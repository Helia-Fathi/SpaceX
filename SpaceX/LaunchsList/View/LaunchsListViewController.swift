//
//  LaunchsListViewController.swift
//  SpaceX
//
//  Created by Helia Fathi on 7/13/23.
//

import UIKit

class LaunchsListViewController: UIViewController {

    var viewModel = LaunchViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(launchsListTableView)
        
        launchsListTableView.delegate = self
        launchsListTableView.dataSource = self

        self.viewModel.fetchAndSaveLaunches(pageNumber: 4) { resual in
            switch resual {
            case .success(let data):
                print(data.docs)
            case .failure(_):
                print("helia")
            }
        }
        
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
        guard let cell: LaunchTableViewCell = tableView.dequeueReusableCell(withIdentifier: LaunchTableViewCell.identifier) as? LaunchTableViewCell else {
            fatalError("LaunchTableViewCell is invalid")
        }
        let launch = viewModel.launchData[indexPath.row]
        cell.configure(with: launch)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let launch = viewModel.launchData[indexPath.row]
        let launchDetailsViewController = LaunchDetailsViewController()
        launchDetailsViewController.details = LaunchDetailsViewModel(name: launch.flightNumber, details: launch.details, mainImage: launch.smallImageURL, dateUTC: launch.dateUTC, isMarked: launch.isMarked, wikiLink: nil)
        let navigationController = UINavigationController(rootViewController: self)
        present(navigationController, animated: true, completion: nil)
        
    }
}
