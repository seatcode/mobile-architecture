//
//  BaseView.swift
//  SampleArchitecture
//
//  Created by Eli Kohen on 02/02/2018.
//  Copyright © 2018 Metropolis Lab. All rights reserved.
//

import UIKit

class BaseView: UIView {
    
    private var viewModel: BaseViewModel
    
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
    
    init(viewModel: BaseViewModel, frame: CGRect) {
        self.viewModel = viewModel
        super.init(frame: frame)
    }
    
    init?(viewModel: BaseViewModel, coder aDecoder: NSCoder) {
        self.viewModel = viewModel
        super.init(coder: aDecoder)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func switchViewModel(_ viewModel: BaseViewModel) {
        self.viewModel.active = false
        self.viewModel = viewModel
        self.viewModel.active = self.active
    }
    
    // MARK: - Internal methods
    
    internal func didBecomeActive(firstTime: Bool) {
        
    }
    
    internal func didBecomeInactive() {
        
    }
    
    
    // MARK: - Helper methods
    
    func loadNibNamed(_ nibName: String, contentView: () -> UIView?) {
        Bundle.main.loadNibNamed(nibName, owner: self, options: nil)
        guard let view = contentView() else { return }
        view.frame = bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        addSubview(view)
    }
}

