//
//  UserDefaultsController.swift
//  FAFoundation_Example
//
//  Created by Ferhan Akkan on 13.09.2022.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import FAFoundation
import UIKit

final class UserDefaultsController: UIViewController {
    
    // MARK: Properties
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(textfield)
        stackView.addArrangedSubview(retrieveButton)
        stackView.addArrangedSubview(UIView())
        return stackView
    }()
    
    private let label: UILabel = {
       let label = UILabel()
        label.numberOfLines = 5
        label.textAlignment = .center
        label.layer.cornerRadius = 8
        label.layer.borderColor = UIColor.blue.cgColor
        label.layer.borderWidth  = 2
       return label
    }()
    
    private lazy var textfield: UITextField = {
        let textField = UITextField()
        textField.inputAccessoryView = toolbar
        textField.translatesAutoresizingMaskIntoConstraints  = false
        textField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private lazy var toolbar: UIToolbar = {
        let toolbar = UIToolbar(frame: .init(
            x: .zero,
            y: .zero,
            width: UIScreen.main.bounds.width,
            height: 50
        ))
        toolbar.barStyle = .default
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.didTapDoneButton))
        let saveButton = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(self.didTapSaveButton))
        toolbar.items = [saveButton, flexSpace, doneButton]
        toolbar.sizeToFit()
        return toolbar
    }()
    
    private lazy var retrieveButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.setTitle("Retrieve Saved Data", for: .normal)
        button.addTarget(self, action: #selector(didTapRetrieveButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints  = false
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return button
    }()
    
    private let userDefaulsManager: UserDefaultsManager
    
    init(userDefaulsManager: UserDefaultsManager = .init()) {
        self.userDefaulsManager = userDefaulsManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayout()
        label.text = retrieveFromUserDefaults()
    }
}

// MARK:  Logic
private extension UserDefaultsController {
    func retrieveFromUserDefaults() -> String {
        return userDefaulsManager.primitiveExample.isNullOrEmpty ? "Not Data Found" : "Retrieved Value = \(userDefaulsManager.primitiveExample.orEmptyString)"
    }
}

// MARK:  Layout
private extension UserDefaultsController {
    func setLayout() {
        view.backgroundColor = .white
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
        ])
    }
}

// MARK:  Private Actions
private extension UserDefaultsController {
    @objc func didTapDoneButton() {
        view.endEditing(true)
    }
    
    @objc func didTapSaveButton() {
        UserDefaultsManager().primitiveExample = textfield.text
    }
    
    @objc func didTapRetrieveButton() {
        label.text = retrieveFromUserDefaults()
    }
}
