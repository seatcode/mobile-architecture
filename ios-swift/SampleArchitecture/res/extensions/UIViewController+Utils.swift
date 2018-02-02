//
//  UIViewController+Utils.swift
//  AbitApp
//
//  Created by Eli Kohen on 15/06/2017.
//  Copyright © 2017 Metropolis Lab. All rights reserved.
//

import UIKit

// MARK: - UINavigationBar helpers

extension UIViewController {
    
    func isRoot() -> Bool  {
        guard let navigationController = navigationController else { return false }
        guard navigationController.viewControllers.count > 0 else { return false }
        return navigationController.viewControllers[0] == self
    }
}


// MARK: - Present/pop

extension UIViewController {
    
    // gets back one VC from the stack.
    @objc func popBackViewController() {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    /**
     Helper to present a view controller using the main thread
     */
    func present(viewController: UIViewController, animated: Bool, onMainThread: Bool, completion: (() -> Void)?) {
        if onMainThread {
            DispatchQueue.main.async { [weak self] in
                self?.present(viewController, animated: animated, completion: completion)
            }
        }
        else {
            self.present(viewController, animated: animated, completion: completion)
        }
    }
    
    /**
     Helper to provide a callback to the popViewController action
     
     - parameter animated:   whether to animate or not
     - parameter completion: completion callback
     */
    func popViewController(animated: Bool, completion: (() -> Void)?) {
        guard let navigationController = navigationController else { return }
        if animated {
            CATransaction.begin()
            CATransaction.setCompletionBlock(completion)
            navigationController.popViewController(animated: true)
            CATransaction.commit()
        } else {
            navigationController.popViewController(animated: false)
            completion?()
        }
    }
    
    /**
     Helper to provide a callback to the pushViewController action
     
     - parameter animated:   whether to animate or not
     - parameter completion: completion callback
     */
    func push(viewController: UIViewController, animated: Bool, completion: (() -> Void)?) {
        guard let navigationController = navigationController else { return }
        if animated {
            CATransaction.begin()
            CATransaction.setCompletionBlock(completion)
            navigationController.pushViewController(viewController, animated: true)
            CATransaction.commit()
        } else {
            navigationController.pushViewController(viewController, animated: false)
            completion?()
        }
    }
    
    /**
     Helper to dismiss vc and all presented view controllers
     */
    func dismissWithPresented(animated: Bool, completion: (() -> Void)?) {
        guard presentingViewController != nil else {
            completion?()
            return
        }
        dismissAllPresented() { [weak self] in
            self?.dismiss(animated: animated, completion: completion)
        }
    }
    
    /**
     Helper to recursively dismiss all presented view controllers
     */
    func dismissAllPresented(_ completion: (() -> ())?) {
        guard let presented = presentedViewController else {
            completion?()
            return
        }
        presented.dismissAllPresented() {
            presented.dismiss(animated: false, completion: completion)
        }
    }
    
    static weak var presentingView: UIView? = nil
    static var presentingRect: CGRect? = nil
}
