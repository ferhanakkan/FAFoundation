//
//  ObserverController.swift
//  FAFoundation_Example
//
//  Created by Ferhan Akkan on 14.09.2022.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import FAFoundation
import UIKit

final class ObserverController: BaseViewController {
    // MARK:  Properties
    private lazy var addObserverButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        button.setTitle("Add Observer", for: .normal)
        button.addTarget(self, action: #selector(didTapAddObserver), for: .touchUpInside)
        return button
    }()
    
    private lazy var addOnFireObserverButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        button.setTitle("Add Observer On Fire", for: .normal)
        button.addTarget(self, action: #selector(didTapAddOnFireObserver), for: .touchUpInside)
        return button
    }()
    
    private lazy var removeObserverButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        button.setTitle("Remove Observer", for: .normal)
        button.addTarget(self, action: #selector(didTapRemoveObserver), for: .touchUpInside)
        return button
    }()
    
    private lazy var generateColorButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        button.setTitle("Generate Color", for: .normal)
        button.addTarget(self, action: #selector(didTapGenerateColor), for: .touchUpInside)
        return button
    }()
    
    private let viewModel: ObserverViewModelProtocol
    
    // MARK:  Initilizer
    init(with viewModel: ObserverViewModelProtocol = ObserverViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:  Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .orange
        stackView.distribution = .equalSpacing
        stackView.addArrangedSubview(UIView())
        stackView.addArrangedSubview(addObserverButton)
        stackView.addArrangedSubview(addOnFireObserverButton)
        stackView.addArrangedSubview(removeObserverButton)
        stackView.addArrangedSubview(generateColorButton)
        stackView.addArrangedSubview(UIView())
    }
}

// MARK:  Actions
private extension ObserverController {
    @objc func didTapAddObserver() {
        viewModel.backgroundColor.observe(on: self, queue: .main) { [weak self] value in
            self?.view.backgroundColor = value
        }
    }
    
    @objc func didTapAddOnFireObserver() {
        viewModel.backgroundColor.observeAndFire(on: self, queue: .main) { [weak self] value in
            self?.view.backgroundColor = value
        }
    }
    
    @objc func didTapRemoveObserver() {
        viewModel.backgroundColor.remove(observer: self)
    }
    
    @objc func didTapGenerateColor() {
        viewModel.generateRandomBackgroundColor()
    }
}
