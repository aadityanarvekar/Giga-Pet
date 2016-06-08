//
//  MonsterImg.swift
//  My Giga Pet
//
//  Created by AADITYA NARVEKAR on 6/3/16.
//  Copyright © 2016 Aaditya Narvekar. All rights reserved.
//

import Foundation
import UIKit

class MonsterImg: UIImageView {
    
    var monsterImages: [UIImage]!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        monsterImages = [UIImage]()
        playIdleAnimation()
    }
    
    
    func playIdleAnimation() {
        self.animationImages = nil
        self.image = UIImage(named: "idle1.png")
        for var i in 1...4 {
            let image = UIImage(named: "idle\(i).png")
            monsterImages.append(image!)
        }
        
        self.animationImages = monsterImages
        self.animationDuration = 0.85
        self.animationRepeatCount = 0
        self.startAnimating()
    }
    
    func playDeathAnimation() {
        self.animationImages = nil
        self.image = UIImage(named: "dead5.png")
        for var i in 1...5 {
            let image = UIImage(named: "dead\(i).png")
            monsterImages.append(image!)
        }
        
        self.animationImages = monsterImages
        self.animationRepeatCount = 1
        self.animationDuration = 0.8
        self.startAnimating()
    }
    
    func respawnMonster() {
        self.monsterImages = [UIImage]()
        playIdleAnimation()
    }
    
        
}
