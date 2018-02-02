//
//  GreenCoordinator.swift
//  SampleArchitecture
//
//  Created by Eli Kohen on 02/02/2018.
//  Copyright © 2018 Metropolis:Lab. All rights reserved.
//

import Foundation
import UIKit

class GreenCoordinator: Coordinator {
    
    var child: Coordinator?
    weak var parent: Coordinator?
    weak var presentedAlertController: UIViewController?
    var viewController: UIViewController? { return mainNavController }
    
    private let mainNavController: UINavigationController
    
    init() {
        let viewModel = GreenViewModel()
        let viewController = GreenViewController(viewModel: viewModel)
        mainNavController = UINavigationController(rootViewController: viewController)
        
        viewModel.navigator = self
    }
    
    func presentViewController(parent: UIViewController, animated: Bool, completion: (() -> Void)?) {
        guard mainNavController.parent == nil else { return }
        parent.present(mainNavController, animated: animated, completion: completion)
    }
    
    func dismissViewController(animated: Bool, completion: (() -> Void)?) {
        mainNavController.dismissWithPresented(animated: animated, completion: completion)
    }
}


extension GreenCoordinator: GreenNavigator {
    func greenFinished() {
        closeCoordinator(animated: true, completion: nil)
    }
}

