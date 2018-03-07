//
//  BaseViewModel.swift
//  SampleArchitecture
//
//  Created by Eli Kohen on 02/02/2018.
//  Copyright © 2018 Metropolis Lab. All rights reserved.
//

protocol ViewModel: class {
    var active: Bool { get set }
}

protocol Navigator: class { }

class BaseViewModel: ViewModel {
    
    private var activeFirstTime = true
    var active: Bool = false {
        didSet {
            guard oldValue != active else { return }
            if active {
                didBecomeActive(firstTime: activeFirstTime)
                activeFirstTime = false
            } else {
                didBecomeInactive()
            }
        }
    }
    
    // MARK: - Internal methods
    
    func didBecomeActive(firstTime: Bool) {
        // implement in subclasses
    }
    
    func didBecomeInactive() {
        // implement in subclasses
    }
}

