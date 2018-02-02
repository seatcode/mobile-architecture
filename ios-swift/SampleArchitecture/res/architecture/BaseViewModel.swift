//
//  BaseViewModel.swift
//  SampleArchitecture
//
//  Created by Eli Kohen on 02/02/2018.
//  Copyright © 2018 Metropolis Lab. All rights reserved.
//

class BaseViewModel {
    
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
        
    }
    
    func didBecomeInactive() {
        
    }
}

