//
//  ObserverPatternExample.swift
//  
//
//  Created by Ferhan Akkan on 11.09.2022.
//

import Foundation

final class ObserverPatternExample {
    
    private var viewModel: ObserverPatternExampleViewModel
    
    init(_ viewModel: ObserverPatternExampleViewModel = .init()) {
        self.viewModel = viewModel
        observeTestObject()
    }
    
    private func observeTestObject() {
        //Observe value when changes after initalization
        viewModel.observableObject.observe(on: self) { value in
            print(value)
        }
        
        //Observe value when initilized (default value will observed)
        viewModel.observableObject.observeAndFire(on: self) { value in
            print(value)
        }
        
        //Get observable objects current value
        _ = viewModel.observableObject.value
        
        //Remove spesific observer
        viewModel.observableObject.remove(observer: self)
        
        //Remove All Observers
        viewModel.observableObject.removeAllObservers()
        
        
        //Set value as treditional way instead of send
        viewModel.observableObject.value = false
    }
}

final class ObserverPatternExampleViewModel {
    var observableObject: Observable<Bool> = .init(false)
}
