//
//  ObserverViewModel.swift
//  FAFoundation_Example
//
//  Created by Ferhan Akkan on 14.09.2022.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import FAFoundation

protocol ObserverViewModelProtocol {
    var backgroundColor: Observable<UIColor> { get set }
    func generateRandomBackgroundColor()
}

final class ObserverViewModel: ObserverViewModelProtocol {
    // MARK:  Properties
    var backgroundColor: Observable<UIColor> = .init(UIColor.white)
    
    func generateRandomBackgroundColor() {
        let color = UIColor(red: CGFloat(drand48()), green: CGFloat(drand48()), blue: CGFloat(drand48()), alpha: 1)
        backgroundColor.value = color
    }
}
