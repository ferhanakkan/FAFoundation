//
//  HomeController.swift
//  FAFoundation_Example
//
//  Created by Ferhan Akkan on 13.09.2022.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit

final class HomeController: UIViewController {

    var titles: [ExampleType] {
        ExampleType.allCases
    }

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(HomeTableViewCell.self, forCellReuseIdentifier: HomeTableViewCell.description())
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setLayout()
    }

    private func setLayout() {
        title = "FAFoundation"
        view.backgroundColor = .white
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}

extension HomeController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        switch titles[indexPath.row] {
        case .userDefaults:
            navigationController?.show(UserDefaultsController.init(), sender: nil)
        case .location:
            navigationController?.show(LocationController.init(), sender: nil)
        case .networkLayer:
            break
        case .observerPattern:
            navigationController?.show(ObserverController.init(), sender: nil)
        case .reachability:
            navigationController?.show(ReachabilityController.init(), sender: nil)
        case .phoneNumberFormater:
            break
        case .usefulExtensions:
            break
        }
        navigationController?.viewControllers.last?.title = titles[indexPath.row].rawValue
    }
}

extension HomeController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        titles.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.description(), for: indexPath) as! HomeTableViewCell
        cell.configure(with: titles[indexPath.row].rawValue)
        return cell
    }
}
