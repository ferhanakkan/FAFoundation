//
//  NetworkLayerController.swift
//  FAFoundation_Example
//
//  Created by Ferhan Akkan on 17.09.2022.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import FAFoundation
import UIKit

final class NetworkLayerController: BaseViewController {
    // MARK:  Properties
    private lazy var getExampleButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        button.setTitle("Get Example", for: .normal)
        button.addTarget(self, action: #selector(didTapGetExample), for: .touchUpInside)
        return button
    }()
    
    private lazy var postExampleButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        button.setTitle("Post Example", for: .normal)
        button.addTarget(self, action: #selector(didTapPostExample), for: .touchUpInside)
        return button
    }()
    
    private lazy var uploadExampleButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        button.setTitle("Upload Example", for: .normal)
        button.addTarget(self, action: #selector(didTapUploadExample), for: .touchUpInside)
        return button
    }()
    
    private let networkManager: FANetworkManagerProtocol
    
    // MARK:  Initilizer
    public init(with networkManager: FANetworkManagerProtocol = FANetwork.shared) {
        self.networkManager = networkManager
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
        stackView.addArrangedSubview(getExampleButton)
        stackView.addArrangedSubview(postExampleButton)
        stackView.addArrangedSubview(uploadExampleButton)
        stackView.addArrangedSubview(UIView())
    }
}

// MARK:  Logic
private extension NetworkLayerController {
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(.init(title: "Ok", style: .default))
        present(alertController, animated: true)
    }
}

// MARK:  Actions
private extension NetworkLayerController {
    @objc func didTapGetExample() {
       
    }
    
    @objc func didTapPostExample() {
      
    }
    
    @objc func didTapUploadExample() {
       
    }
}
