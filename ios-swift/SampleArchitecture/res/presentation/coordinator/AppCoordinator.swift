//
//  MainCoordinator.swift
//  SampleArchitecture
//
//  Created by Eli Kohen on 02/02/2018.
//  Copyright © 2018 Metropolis:Lab. All rights reserved.
//

import Foundation
import UIKit

class AppCoordinator: Coordinator {
    var child: Coordinator?
    var viewController: UIViewController? { return mainNavigationController }
    weak var parent: Coordinator? = nil // Will never have a parent
    weak var presentedAlertController: UIViewController?
    
    fileprivate let mainViewController: MainViewController
    fileprivate let mainNavigationController: UINavigationController
    
    fileprivate var topNavController: UINavigationController {
        return mainNavigationController.presentedViewController as? UINavigationController ?? mainNavigationController
    }
    
    init() {
        let viewModel = MainViewModel()
        self.mainViewController = MainViewController(viewModel: viewModel)
        self.mainNavigationController = UINavigationController(rootViewController: mainViewController)
        viewModel.navigator = self
    }
    
    func openOn(window: UIWindow) {
        window.rootViewController = mainNavigationController
        window.makeKeyAndVisible()
    }
    
    // App coordinator doesn't present nor dismisses as it will be always present.
    func presentViewController(parent: UIViewController, animated: Bool, completion: (() -> Void)?) {}
    func dismissViewController(animated: Bool, completion: (() -> Void)?) {}
}


// MARK: - MainMapNavigator

extension AppCoordinator: MainNavigator {
    func openYellowProcess() {
        
    }
    
    func openGreenProcess() {
        
    }
}
