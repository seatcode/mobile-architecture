//
//  ViewControllerLifeCycle.swift
//  SampleArchitecture
//
//  Created by Eli Kohen on 08/02/2018.
//  Copyright © 2018 Metropolis:Lab. All rights reserved.
//

import Foundation
import UIKit

protocol ViewControllerExtended: class {
    var active: Bool { get set }
    
    func viewWillFirstAppear(_ animated: Bool)
    func viewDidFirstAppear(_ animated: Bool)
    func viewDidFirstLayoutSubviews()
    
    func viewWillAppear(fromBackground: Bool)
    func viewWillDisappear(toBackground: Bool)
}

class ViewControllerLifeCycle {
    private var firstAppear: Bool = true
    private var firstWillAppear: Bool = true
    private var firstLayout: Bool = true
    
    weak var viewController: ViewControllerExtended?
    weak var viewModel: ViewModel?
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private var active: Bool = false {
        didSet {
            viewController?.active = active
            viewModel?.active = active
        }
    }
    
    func viewWillAppear(_ animated: Bool) {
        viewWillAppear(fromBackground: false)
        if firstWillAppear {
            viewController?.viewWillFirstAppear(animated)
            firstWillAppear = false
        }
    }
    
    func viewWillDisappear(_ animated: Bool) {
        viewWillDisappear(toBackground: false)
    }
    
    func viewDidAppear(_ animated: Bool) {
        if firstAppear {
            viewController?.viewDidFirstAppear(animated)
            firstAppear = false
        }
    }
    
    func viewDidLayoutSubviews() {
        if firstLayout {
            viewController?.viewDidFirstLayoutSubviews()
            firstLayout = false
        }
    }
    
    
    // MARK: > Extended lifecycle
    
    private func viewWillAppear(fromBackground: Bool) {
        if !fromBackground {
            NotificationCenter.default.addObserver(self, selector: #selector(applicationDidEnterBackground(_:)), name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(applicationWillEnterForeground(_:)), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        }
        
        viewController?.viewWillAppear(fromBackground: fromBackground)
        active = true
    }
    
    private func viewWillDisappear(toBackground: Bool) {
        if !toBackground {
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        }
        
        viewController?.viewWillDisappear(toBackground: toBackground)
        active = false
    }
    
    // MARK: Private methods
    
    // MARK: > NSNotificationCenter
    
    @objc private func applicationDidEnterBackground(_ notification: Notification) {
        viewWillDisappear(toBackground: true)
    }
    
    @objc private func applicationWillEnterForeground(_ notification: Notification) {
        viewWillAppear(fromBackground: true)
    }
}
