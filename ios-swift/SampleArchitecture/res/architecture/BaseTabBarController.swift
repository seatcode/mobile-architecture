//
//  BaseTabBarViewController.swift
//  SampleArchitecture
//
//  Created by Eli Kohen on 08/02/2018.
//  Copyright © 2018 Metropolis:Lab. All rights reserved.
//

import Foundation
import UIKit

class BaseTabBarController<V>: UITabBarController, ViewControllerExtended where V: BaseViewModel {
    private(set) var viewModel: V
    private var vcLifeCycle = ViewControllerLifeCycle()
    var active: Bool = false
    
    init(viewModel: V, nibName: String? = nil) {
        self.viewModel = viewModel
        super.init(nibName: nibName, bundle: nil)
        vcLifeCycle.viewController = self
        vcLifeCycle.viewModel = viewModel
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        vcLifeCycle.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        vcLifeCycle.viewWillDisappear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        vcLifeCycle.viewDidAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        vcLifeCycle.viewDidLayoutSubviews()
    }
    
    func viewWillFirstAppear(_ animated: Bool) {
        // implement in subclasses
    }
    
    func viewDidFirstAppear(_ animated: Bool) {
        // implement in subclasses
    }
    
    func viewDidFirstLayoutSubviews() {
        // implement in subclasses
    }
    
    func viewWillAppear(fromBackground: Bool) {
        // implement in subclasses
    }
    
    func viewWillDisappear(toBackground: Bool) {
        // implement in subclasses
    }
}
