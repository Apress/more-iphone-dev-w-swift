//
//  ViewController.swift
//  Storyboarding_01
//
//  Created by Jayant Varma on 30/01/2015.
//  Copyright (c) 2015 OZ Apps. All rights reserved.
//
// Code : Chapter_14
// Book: More iOS Development with Swift, Apress 2015
//


import UIKit

class ViewController: UIViewController, UIViewControllerTransitioningDelegate, UINavigationControllerDelegate{
  
    @IBOutlet weak var theControl: BasicControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        theControl.value = 0.6
        
        //self.transitioningDelegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        
        println("\(segue.identifier)")
        let _dest = segue.destinationViewController as! DetailViewController
        //_dest.theLabel?.text = "OK, set the text from here"
        _dest.theText = "This is not sparta mate!"
        _dest.hideButton = true
        
        //self.navigationController?.pushViewController(_dest, animated: true)
        
        //_dest.modalPresentationStyle = UIModalPresentationStyle.Custom
        //_dest.transitioningDelegate = self
    }
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        //
        var animator = myAnimator()
        animator.presenting = true
        return animator
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        var animator = myAnimator()
        return animator
    }


    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        var animator = myAnimator()
        animator.presenting = true
        return animator
    }
    
    
    @IBAction func pressed(sender: UIStepper){
        //var theVal = theControl.value
        //println("")
        theControl.value = CGFloat(sender.value)
    }

    @IBAction func displayAnimated(sender: AnyObject) {
        let story = UIStoryboard(name: "Main", bundle: nil)
        let newVC = story.instantiateViewControllerWithIdentifier("sparta") as! DetailViewController
        
        newVC.transitioningDelegate = self
        newVC.modalPresentationStyle = .Custom
        
        self.modalPresentationStyle = .CurrentContext
        newVC.modalPresentationStyle = .CurrentContext
        
        self.presentViewController(newVC, animated: true, completion: nil)
    }
    
    @IBAction func pushView(sender: AnyObject) {
        var story = UIStoryboard(name: "Main", bundle: nil)
        var _dest:DetailViewController = story.instantiateViewControllerWithIdentifier("sparta") as! DetailViewController
        
        _dest.hideButton = true
        _dest.theText = "Hello, this isn't working"
        
        _dest.transitioningDelegate = self
        //_dest.modalPresentationStyle = .Custom
        
        self.modalPresentationStyle = .CurrentContext
        
        self.navigationController!.pushViewController(_dest, animated: true)
    }
        
}

