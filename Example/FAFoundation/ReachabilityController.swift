//
//  ReachabilityController.swift
//  FAFoundation_Example
//
//  Created by Ferhan Akkan on 16.09.2022.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import FAFoundation
import UIKit

final class ReachabilityController: BaseViewController {
    // MARK:  Properties
    private let label: UILabel = {
       let label = UILabel()
        label.text = "No Data"
        label.numberOfLines = 5
        label.textAlignment = .center
        label.layer.cornerRadius = 8
        label.layer.borderColor = UIColor.blue.cgColor
        label.layer.borderWidth  = 2
       return label
    }()
    
    private lazy var checkIsReachableButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        button.setTitle("Check Is Reachable", for: .normal)
        button.addTarget(self, action: #selector(didTapIsReachable), for: .touchUpInside)
        return button
    }()
    
    private lazy var listenReachability: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        button.setTitle("Listen Reachability Changes", for: .normal)
        button.addTarget(self, action: #selector(didTapListenReachability), for: .touchUpInside)
        return button
    }()
    
    private lazy var removeListenReachability: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        button.setTitle("Remove Reachability Changes", for: .normal)
        button.addTarget(self, action: #selector(didTapRemoveListenReachability), for: .touchUpInside)
        return button
    }()
    
    private lazy var continueListenReachability: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        button.setTitle("Continue Reachability Changes", for: .normal)
        button.addTarget(self, action: #selector(didTapContinueListenReachability), for: .touchUpInside)
        return button
    }()
    
    private let reachabilityManager: FAReachabilityManagerProtocol
    
    // MARK:  Initilizer
    public init(with reachabilityManager: FAReachabilityManagerProtocol = FAReachabilityManager()) {
        self.reachabilityManager = reachabilityManager
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:  Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        stackView.distribution = .equalSpacing
        stackView.addArrangedSubview(UIView())
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(checkIsReachableButton)
        stackView.addArrangedSubview(listenReachability)
        stackView.addArrangedSubview(removeListenReachability)
        stackView.addArrangedSubview(continueListenReachability)
        stackView.addArrangedSubview(UIView())
    }
}

// MARK:  Logic
private extension ReachabilityController {
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(.init(title: "Ok", style: .default))
        present(alertController, animated: true)
    }
}

// MARK:  Actions
private extension ReachabilityController {
//    @objc func didTapCheckWifi() {
//        label.text = "Wifi Enable = \(reachabilityManager.isWiFiEnabled())"
//    }
    
    @objc func didTapIsReachable() {
        label.text = "Connection is reachable  \(reachabilityManager.isReachable), connection Type \(reachabilityManager.connectionType)"
    }
    
    @objc func didTapListenReachability() {
        reachabilityManager.listenReachabilityChanges(.main) { [weak self] reachability in
            self?.showAlert(
                title: "Listen Reachability",
                message: "Reachability Changed Status  \(reachability.status), Type: \(reachability.type), Connection is reachable  \((self?.reachabilityManager.isReachable).orFalse)"
            )
        }
    }
    
    @objc func didTapRemoveListenReachability() {
        reachabilityManager.removeListenReachability()
    }
    
    @objc func didTapContinueListenReachability() {
        reachabilityManager.continueListenReachability()
    }
}
