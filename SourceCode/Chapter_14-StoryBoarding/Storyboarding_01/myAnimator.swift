//
//  myAnimator.swift
//  Storyboarding_01
//
//  Created by Jayant Varma on 1/02/2015.
//  Copyright (c) 2015 OZ Apps. All rights reserved.
//
// Code : Chapter_14
// Book: More iOS Development with Swift, Apress 2015
//


import UIKit

class myAnimator: NSObject, UIViewControllerAnimatedTransitioning{ //, UINavigationControllerDelegate {

    var presenting: Bool = false

    // This is used for percent driven interactive transitions, as well as for container controllers that have companion animations that might need to
    // synchronize with the main animation.

    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval{
        return 0.5
    }
    // This method can only  be a nop if the transition is interactive and not a percentDriven interactive transition.

    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning){
        var fromView = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        var toView = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        var endFrame = UIScreen.mainScreen().bounds
        
        var theView = transitionContext.containerView()

    var toStartFrame = transitionContext.initialFrameForViewController(toView!)
    var fromStartFrame = transitionContext.initialFrameForViewController(fromView!)
    
    var toEndFrame = transitionContext.finalFrameForViewController(toView!)
    var fromEndFrame = transitionContext.finalFrameForViewController(fromView!)
        
        if self.presenting{
            fromView?.view.userInteractionEnabled = false
            
            transitionContext.containerView().addSubview(fromView!.view)
            transitionContext.containerView().addSubview(toView!.view)
            
            var startFrame = endFrame
            startFrame.origin.x += 320
            
            toView?.view.frame = startFrame
            
            UIView.animateWithDuration(self.transitionDuration(transitionContext),
                animations: {
                    fromView?.view.tintAdjustmentMode = .Dimmed
                    toView?.view.frame = endFrame
                    fromView?.view.alpha = 0
                    },
                completion: {
                    _ in
                    transitionContext.completeTransition(true)
            })
        } else {
            toView?.view.userInteractionEnabled = true
            
            transitionContext.containerView().addSubview(toView!.view)
            transitionContext.containerView().addSubview(fromView!.view)
            
            //var startFrame = endFrame
            endFrame.origin.x += 320
           
            UIView.animateWithDuration(self.transitionDuration(transitionContext),
                animations: {
                    toView?.view.tintAdjustmentMode = .Automatic
                    fromView?.view.frame = endFrame
                    //toView?.view.frame = startFrame
                    toView?.view.alpha = 1
                },
                completion: {
                    _ in
                    transitionContext.completeTransition(true)
            })
        }
    }
    // This is a convenience and if implemented will be invoked by the system when the transition context's completeTransition: method is invoked.
    func animationEnded(transitionCompleted: Bool){
        
    }

    
//    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        //
//        println(">>  \(operation.rawValue) <<")
//        return self
//    }
    
    
    
    
    
    
}
