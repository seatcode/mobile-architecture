//
//  Coordinator.swift
//  SampleArchitecture
//
//  Created by Eli Kohen on 02/02/2018.
//  Copyright © 2018 Metropolis Lab. All rights reserved.
//

import UIKit
import SafariServices

protocol Coordinator: class {
    
    /// Possible child coordinator. Will be automatically set on `openChild` method
    var child: Coordinator? { get set }
    /// Delegate for parent coordinators, to notify when this has finished. Will be automatically set on `openChild` method
    weak var parent: Coordinator? { get set }
    /// main view controller
    var viewController: UIViewController? { get }
    /// Possible presented alert controller
    weak var presentedAlertController: UIViewController? { get set }
    
    
    /**
     Once a coordinator is created this method will be called to present/show the main viewController. Each
     implementation is responsible to do so.
     
     - Parameters:
     - parent: parent view controller, can be used to present the new controller.
     - animated: whether or not the action to present/show should be animated
     - completion: completion closure
     */
    func presentViewController(parent: UIViewController, animated: Bool, completion: (() -> Void)?)
    
    
    /**
     Method that will remove/dismiss the main view controller. It should ALWAYS call completion block, even if
     viewController isn't presented or is already dismissed. When a coordinator is closed it will call this method
     during the process.
     - Parameters:
     - animated: whether or not the action should be animated
     - completion: completion closure
     */
    func dismissViewController(animated: Bool, completion: (() -> Void)?)
}


// MARK: - Child delegation

extension Coordinator {
    func coordinatorDidClose(_ coordinator: Coordinator) {
        child = nil
    }
}


// MARK: - Helpers

extension Coordinator {
    func openChild(coordinator: Coordinator, parent: UIViewController, animated: Bool, forceCloseChild: Bool,
                         completion: (() -> Void)?) {
        let presentBlock = {
            self.child?.parent = nil
            self.child = coordinator
            coordinator.parent = self
            coordinator.presentViewController(parent: parent, animated: animated, completion: completion)
        }
        
        if let child = child {
            if forceCloseChild {
                child.closeCoordinator(animated: false, completion: presentBlock)
            }
        } else {
            presentBlock()
        }
    }
    
    func closeCoordinator(animated: Bool, completion: (() -> Void)?) {
        let dismiss: () -> Void = { [weak self] in
            self?.dismissViewController(animated: animated) {
                guard let strongSelf = self else { return }
                strongSelf.parent?.coordinatorDidClose(strongSelf)
                completion?()
            }
        }
        
        if let child = child {
            child.closeCoordinator(animated: animated, completion: dismiss)
        } else {
            dismiss()
        }
    }
}


// MARK: - Loading

extension Coordinator {
    func openLoading(message: String,
                     animated: Bool = true,
                     completion: (() -> Void)? = nil) {
        let finalMessage = (message) + "\n\n\n"
        let alert = UIAlertController(title: finalMessage, message: nil, preferredStyle: .alert)
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        activityIndicator.color = UIColor.black
        activityIndicator.center = CGPoint(x: 130.5, y: 85.5)
        alert.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        openAlertController(alert, animated: animated, completion: completion)
    }
    
    func closeLoading(animated: Bool = true,
                      completion: (() -> Void)? = nil) {
        closePresentedAlertController(animated: animated, completion: completion)
    }
    
    func closeLoading(animated: Bool = true,
                      withAutocloseMessage message: String,
                      autocloseMessageCompletion: (() -> Void)? = nil) {
        closeLoading(animated: animated) { [weak self] in
            self?.openAutocloseMessage(animated: animated, message: message, completion: autocloseMessageCompletion)
        }
    }
}


// MARK: - Autoclose message

private let autocloseMessageDefaultTime: Double = 2.5

extension Coordinator {
    func openAutocloseMessage(animated: Bool = true,
                              message: String,
                              time: Double = autocloseMessageDefaultTime,
                              completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        openAlertController(alert)
        delay(time) { [weak self] in
            self?.closePresentedAlertController(animated: animated, completion: completion)
        }
    }
}


// MARK: - Alerts w UIAction

extension Coordinator {
    func openAlert(animated: Bool = true, title: String?, message: String?, actions: [UIAlertAction], completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        actions.forEach { uiAction in
            alert.addAction(uiAction)
        }
        openAlertController(alert, animated: animated, completion: completion)
    }
    
    func openAlert(animated: Bool = true, title: String?, message: String?, cancelLabel: String, actions: [UIAlertAction], completion: (() -> Void)? = nil) {
        let cancelAction = UIAlertAction(title: cancelLabel, style: .cancel, handler: nil)
        let actualActions = [cancelAction] + actions
        openAlert(animated: animated, title: title, message: message, actions: actualActions, completion: completion)
    }
}


// MARK: - Private methods

extension Coordinator {
    
    func openAlertController(_ alert: UIViewController, animated: Bool = true, completion: (() -> Void)? = nil) {
        guard let viewController = self.viewController else { return }
        presentedAlertController?.dismissWithPresented(animated: false, completion: nil)
        
        presentedAlertController = alert
        viewController.present(alert, animated: animated, completion: completion)
    }
    
    func closePresentedAlertController(animated: Bool = true,
                                       completion: (() -> Void)? = nil) {
        guard let presentedAlertController = presentedAlertController else { return }
        
        presentedAlertController.dismiss(animated: animated) { [weak self] in
            self?.presentedAlertController = nil
            completion?()
        }
    }
}

