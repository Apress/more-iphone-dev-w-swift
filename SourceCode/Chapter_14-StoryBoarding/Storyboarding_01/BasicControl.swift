//
//  BasicControl.swift
//  Storyboarding_01
//
//  Created by Jayant Varma on 30/01/2015.
//  Copyright (c) 2015 OZ Apps. All rights reserved.
//
// Code : Chapter_14
// Book: More iOS Development with Swift, Apress 2015
//


import UIKit

@IBDesignable class BasicControl: UIView {
    
    private var shape: CAShapeLayer!
    private var gradient: CAGradientLayer!
    
    @IBInspectable var value: CGFloat = 0 {
        didSet {
            layoutSubviews()
            //layoutIfNeeded()
        }
    }
    
    @IBInspectable var useFlatColor: Bool = true {
        didSet {
                gradient.hidden = useFlatColor
        }
    }
    
    @IBInspectable var theColor:UIColor! = UIColor.greenColor() {
        didSet {
            shape.fillColor = theColor.CGColor
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if shape == nil {
            shape = CAShapeLayer()
            shape.fillColor = theColor.CGColor
            shape.cornerRadius = self.frame.height/2
            shape.masksToBounds = true
            
            self.layer.addSublayer(shape)
            self.clipsToBounds = true
        }
        if gradient == nil {
            gradient = CAGradientLayer()
            gradient.colors = [UIColor.redColor().CGColor, UIColor.blueColor().CGColor]
            gradient.locations = [0.0, 1.0]
            gradient.cornerRadius = self.frame.height/2
            gradient.masksToBounds = true
            
            gradient.hidden = useFlatColor
            self.layer.addSublayer(gradient)
        }

        var frame = self.bounds

        let x:CGFloat = max(shape.frame.midX, frame.size.width - shape.frame.midX)
        let y:CGFloat = max(shape.frame.midY, frame.size.height - shape.frame.midY)
        //var _radius = Int(sqrt(x*x + y*y) * value)
        //var radius = CGFloat(_radius + 8)
        var radius = sqrt(x*x + y*y) * value
        
        CATransaction.begin()
        CATransaction.setAnimationDuration(0.0)
        CATransaction.setDisableActions(true)
        
        if value == 0 {
            shape.hidden = true
            gradient.hidden = true
        } else {
            shape.hidden = false
            gradient.hidden = useFlatColor
            
            shape.path = UIBezierPath(ovalInRect: CGRectMake(0, 0, radius*2, radius*2)).CGPath
            shape.frame = CGRectMake(frame.midX - radius, frame.midY - radius, radius * 2, radius * 2)
            shape.position = CGPointMake(frame.midX, frame.midY)
            
            shape.anchorPoint = CGPointMake(0.5, 0.5)
            
            shape.cornerRadius = radius
            //shape.masksToBounds = true
            
            gradient.frame = shape.frame
            gradient.cornerRadius = radius
            //gradient.masksToBounds = true
            
            //gradient.borderWidth = 6 * value
            //gradient.borderColor = UIColor.whiteColor().CGColor
        }
        CATransaction.commit()
    }
    
}



