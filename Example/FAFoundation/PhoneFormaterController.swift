//
//  PhoneFormaterController.swift
//  FAFoundation_Example
//
//  Created by Ferhan Akkan on 17.09.2022.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import FAFoundation
import UIKit

final class PhoneFormaterController: BaseViewController {
    // MARK:  Properties
    private let label: UILabel = {
       let label = UILabel()
        label.text = "05551234567"
        label.numberOfLines = 5
        label.textAlignment = .center
        label.layer.cornerRadius = 8
        label.layer.borderColor = UIColor.blue.cgColor
        label.layer.borderWidth  = 2
       return label
    }()
    
    private lazy var formatButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        button.setTitle("Format Number", for: .normal)
        button.addTarget(self, action: #selector(didTapFormatNumber), for: .touchUpInside)
        return button
    }()
    
    private lazy var clearButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        button.setTitle("Set Not Formated Number", for: .normal)
        button.addTarget(self, action: #selector(didTapClear), for: .touchUpInside)
        return button
    }()
    
    private let phoneFormater: FAPhoneNumberFormater
    
    // MARK:  Initilizer
    public init(with phoneFormater: FAPhoneNumberFormater = .init(textFormat: .second, isInitialZeroEnabled: false)) {
        self.phoneFormater = phoneFormater
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
        stackView.addArrangedSubview(formatButton)
        stackView.addArrangedSubview(clearButton)
        stackView.addArrangedSubview(UIView())
    }
}

// MARK:  Actions
private extension PhoneFormaterController {
    @objc func didTapFormatNumber() {
        label.text = phoneFormater.format(replacementString: label.text.orEmptyString)
    }
    
    @objc func didTapClear() {
        label.text = "05551234567"
    }
}
