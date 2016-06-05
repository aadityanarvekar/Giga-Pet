//
//  DragImage.swift
//  My Giga Pet
//
//  Created by AADITYA NARVEKAR on 6/3/16.
//  Copyright © 2016 Aaditya Narvekar. All rights reserved.
//

import Foundation
import UIKit

class DragImage: UIImageView {
    
    var originalPosition: CGPoint?
    var endPosition: CGPoint?
    var dropTarget: UIView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.originalPosition = self.center
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            let position = touch.locationInView(self.superview)
            self.center = CGPointMake(position.x, position.y)
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first, let target = dropTarget {
            let touchPosition = touch.locationInView(self.superview)
            if CGRectContainsPoint(target.frame, touchPosition) {
                NSNotificationCenter.defaultCenter().postNotificationName("onTargetDropped", object: "\(self.tag)")
            }
        }
        self.center = self.originalPosition!
    }
    
    
}