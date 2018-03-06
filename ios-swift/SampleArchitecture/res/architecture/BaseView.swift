//
//  BaseView.swift
//  SampleArchitecture
//
//  Created by Eli Kohen on 02/02/2018.
//  Copyright © 2018 Metropolis Lab. All rights reserved.
//

import UIKit

protocol SubView: class  {
    var active: Bool { get set }
}

class BaseView<V>: UIView, SubView where V: BaseViewModel {
    
    private(set) var viewModel: V
    
    var active: Bool = false {
        didSet {
            guard oldValue != active else { return }
            viewModel.active = active
            
            if active {
                didBecomeActive(firstTime: activeFirstTime)
                activeFirstTime = false
            } else {
                didBecomeInactive()
            }
        }
    }
    private var activeFirstTime = true
    
    
    // MARK: - Lifecycle
    
    init(viewModel: V, frame: CGRect) {
        self.viewModel = viewModel
        super.init(frame: frame)
        viewDidInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func switchViewModel(_ viewModel: V) {
        self.viewModel.active = false
        self.viewModel = viewModel
        self.viewModel.active = self.active
    }
    
    // MARK: - Internal methods

    func viewDidInit() {
        // implement in subclasses
    }
    
    func didBecomeActive(firstTime: Bool) {
        // implement in subclasses
    }
    
    func didBecomeInactive() {
        // implement in subclasses
    }
}

