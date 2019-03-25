//
//  tranitionController.swift
//  transition
//
//  Created by Bhavin Suthar on 20/03/19.
//  Copyright © 2019 cazzy. All rights reserved.
//

import Foundation
import UIKit

class TransitionController: NSObject,UIViewControllerAnimatedTransitioning {
    
    private let originFrame: CGRect
    var selectedImage:UIImage?
    var present = false
    
    init(originFrame: CGRect,imageName:UIImage,present:Bool = true) {
        self.originFrame = originFrame
        self.selectedImage = imageName
        self.present = present
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.2
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let fromVC = transitionContext.viewController(forKey: .from)!
        
        let toVC  = transitionContext.viewController(forKey: .to)!
        
        let containerView = transitionContext.containerView
        
        let tpView:UIImageView = present ? toVC.view.viewWithTag(123) as! UIImageView : fromVC.view.viewWithTag(123) as! UIImageView
        
        tpView.alpha = 0
        
        let newView = UIImageView.init(frame:
            present ? originFrame: tpView.frame)
        
        newView.contentMode = .scaleAspectFit
        
        newView.image = selectedImage!
        newView.clipsToBounds = true
        
        
        containerView.addSubview(toVC.view)
        containerView.addSubview(newView)
        
        toVC.view.alpha = present ? 0 : 0
        
        newView.alpha = 1
        
        
        
        UIView.animate(withDuration: 0.2, animations: {
            newView.frame = self.present ? tpView.frame : self.originFrame
            toVC.view.alpha = 1
            
            newView.alpha = self.present ? 1 : 0
            
        }, completion: { success in
            
            tpView.alpha = 1
            newView.removeFromSuperview()
            
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            
            
        })
    }
    
    
}


//
// MARK:- Handle back swipe
// UIPercentDrivenInteractiveTransition controls all the interaction

class CustomInteractor: UIPercentDrivenInteractiveTransition {
    
    var navigationController : UINavigationController
    
    /// This flag will make sure what action to perform
    /// if user stops swiping in half or swiping is done
    var shouldCompleteTransition = false
    
    /// This flag will indicate the progress of transiton
    var transitionInProgress = false
    
    init?(attachTo viewController : UIViewController) {
        if let nav = viewController.navigationController {
            self.navigationController = nav
            super.init()
            self.setupBackGesture(view: viewController.view)
            
        } else {
            return nil
        }
    }
    
    //Init swipe
    private func setupBackGesture(view : UIView) {
        let swipeBackGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleBackGesture(_:)))
        swipeBackGesture.edges = .left
        view.addGestureRecognizer(swipeBackGesture)
    }
    
    @objc private func handleBackGesture(_ gesture : UIScreenEdgePanGestureRecognizer) {
        
        // Here we have all control over transition
        // through edge swipe
        
        let viewTranslation = gesture.translation(in: gesture.view?.superview)
        
        let progress = viewTranslation.x / self.navigationController.view.frame.width
        
        switch gesture.state {
            
        case .began:
            
            // user  started swiping back so transition is in progress
            // so operation to perform is pop
            transitionInProgress = true
            navigationController.popViewController(animated: true)
            break
            
        case .changed:
            
            // If swipe progress is more then half complete the transition
            shouldCompleteTransition = progress > 0.5
            // Update is system method to call for each progress
            update(progress)
            break
            
        case .cancelled:
            
            // User picked up his fingers and transiton
            // is cancelled reset inprogress flag
            transitionInProgress = false
            cancel()
            break
            
        case .ended:
            
            // Based on progress status finish events
            transitionInProgress = false
            shouldCompleteTransition ? finish() : cancel()
            break
            
        default:
            return
        }
    }
    
}
