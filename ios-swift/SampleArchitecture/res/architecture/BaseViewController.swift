//
//  BaseViewController.swift
//  SampleArchitecture
//
//  Created by Eli Kohen on 02/02/2018.
//  Copyright © 2018 Metropolis Lab. All rights reserved.
//

import UIKit

// MARK: - BaseViewController

class BaseViewController<V>: UIViewController where V: BaseViewModel {
    
    // VM & active
    private(set) var viewModel: V
    private var subviews: [BaseView]
    private var firstAppear: Bool = true
    private var firstWillAppear: Bool = true
    private var firstLayout: Bool = true
    
    var active: Bool = false {
        didSet {
            // Notify the VM & the views
            viewModel.active = active
            
            subviews.forEach { $0.active = active }
        }
    }
    
    
    // MARK: Lifecycle
    
    init(viewModel: V, nibName: String? = nil) {
        self.viewModel = viewModel
        self.subviews = []
        super.init(nibName: nibName, bundle: nil)
        
        // Setup
        hidesBottomBarWhenPushed = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewWillAppear(fromBackground: false)
        if firstWillAppear {
            viewWillFirstAppear(animated)
            firstWillAppear = false
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewWillDisappear(toBackground: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if firstAppear {
            viewDidFirstAppear(animated)
            firstAppear = false
        }
        navigationController?.interactivePopGestureRecognizer?.delegate = self as? UIGestureRecognizerDelegate
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if firstLayout {
            viewDidFirstLayoutSubviews()
            firstLayout = false
        }
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
    
    // MARK: Internal methods
    
    // MARK: > Extended lifecycle
    
    internal func viewWillAppear(fromBackground: Bool) {
        if !fromBackground {
            NotificationCenter.default.addObserver(self, selector: #selector(applicationDidEnterBackground(_:)), name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(applicationWillEnterForeground(_:)), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        }
        
        active = true
    }
    
    internal func viewWillDisappear(toBackground: Bool) {
        if !toBackground {
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        }
        
        active = false
    }
    
    // MARK: > Subview handling
    
    func add<T>(subview: T) where T: BaseView {
        //Adding visually
        if !view.subviews.contains(subview) {
            view.addSubview(subview)
        }
        
        //Adding to managed subviews
        if !subviews.contains(subview) {
            subviews.append(subview)
            
            //Set current state to subview
            subview.active = self.active
        }
    }
    
    func remove<T>(subview: T) where T: BaseView {
        // Removing visually
        if view.subviews.contains(subview) {
            subview.removeFromSuperview()
        }
        
        if subviews.contains(subview) {
            subviews = subviews.filter { return $0 !== subview }
            
            //Set inactive state to subview
            subview.active = false
        }
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
