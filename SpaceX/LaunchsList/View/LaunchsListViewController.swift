//
//  LaunchsListViewController.swift
//  SpaceX
//
//  Created by Helia Fathi on 7/13/23.
//

import UIKit

class LaunchsListViewController: UIViewController {

    lazy var viewModel = {
        LaunchViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(launchsListTableView)
        
        launchsListTableView.delegate = self
        launchsListTableView.dataSource = self
        
        viewModel.fetchLaunchesFromDB()
//        viewModel.fetchAndSaveLaunches(pageNumber: 1)
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
            launchsListTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 48),
            launchsListTableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24),
            launchsListTableView.rightAnchor.constraint(equalTo: view.rightAnchor,  constant: -24),
            launchsListTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 48)
        ])
    }
}

extension LaunchsListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.isLoading ? 0 : viewModel.launchData.count
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
}
