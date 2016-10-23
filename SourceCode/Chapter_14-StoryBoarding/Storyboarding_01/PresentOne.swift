//
//  PresentOne.swift
//  Storyboarding_01
//
//  Created by Jayant Varma on 1/02/2015.
//  Copyright (c) 2015 OZ Apps. All rights reserved.
//
// Code : Chapter_14
// Book: More iOS Development with Swift, Apress 2015
//

import UIKit

class PresentOne: UIPresentationController {
   
    var source: UIView!
    lazy var _dimmingView: UIView = {
        var theView:UIView = UIView(frame: self.presentedViewController.view.bounds)
        
        theView.backgroundColor = UIColor.blackColor()
        
        return theView
    }()
    
    override func presentationTransitionWillBegin() {
        println("Started")
        // Add a custom view
        
        self.containerView.addSubview(_dimmingView)
        _dimmingView.addSubview(self.presentedViewController.view)
        
        var transitionCoordinator = self.presentedViewController.transitionCoordinator()
        _dimmingView.alpha = 0.0
        
        transitionCoordinator?.animateAlongsideTransition({
            _ in
            self._dimmingView.alpha = 1.0
            }, completion: nil)
    }
    
    override func presentationTransitionDidEnd(completed: Bool) {
        println("Done yay!?")
        
        //Remove if the transition was aborted
        if !completed {
            _dimmingView.removeFromSuperview()
        }
    }
    
    override func presentedView() -> UIView! {
        //<#code#>
        return self.presentedViewController.view
    }
    
    override func prepareForInterfaceBuilder() {
        //<#code#>
        println("What can this one do???")
    }
    
}
