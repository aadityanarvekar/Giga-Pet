//
//  ViewController.swift
//  My Giga Pet
//
//  Created by AADITYA NARVEKAR on 5/31/16.
//  Copyright © 2016 Aaditya Narvekar. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    let DIM_ALPHA: CGFloat = 0.4
    let OPAQUE: CGFloat = 1.0
    let MAXIMUM_PENALTIES: Int = 3
    
    @IBOutlet weak var monsterImg: MonsterImg!
    @IBOutlet weak var monsterHeartImg: DragImage!
    @IBOutlet weak var monsterFoodImg: DragImage!
    
    @IBOutlet weak var penalty1Img: UIImageView!
    @IBOutlet weak var penalty2Img: UIImageView!
    @IBOutlet weak var penalty3Img: UIImageView!
    var penaltyImages = [UIImageView]()
    
    var numOfAvailableLives: Int!
    var timer: NSTimer!
    
    var monsterFed: Bool = false
    var monsterLoved: Bool = false
    
    var musicPlayer: AVAudioPlayer!
    var sfxBite: AVAudioPlayer!
    var sfxHeart: AVAudioPlayer!
    var sfxDeath: AVAudioPlayer!
    var sfxSkull: AVAudioPlayer!
    
    @IBOutlet weak var RespawnBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeGame()
    }
    
    func itemDroppedonCharacter(notification: NSNotification) {
        if let obj = notification.object {
            if obj as! String  == "1" { // Heart fed to the giant
                sfxHeart.volume = 0.1
                sfxHeart.play()
                monsterLoved = true
                disableMonsterHeartAndFood()
                startTimer(3.0)
            } else if obj as! NSObject == "2" { // Food fed to the giant
                sfxBite.volume = 0.1
                sfxBite.play()
                monsterFed = true
                disableMonsterHeartAndFood()
                startTimer(3.0)
            }
        }
    }
    
    func disableMonsterHeartAndFood() {
        monsterFoodImg.alpha = DIM_ALPHA
        monsterHeartImg.alpha = DIM_ALPHA
        
        monsterFoodImg.userInteractionEnabled = false
        monsterHeartImg.userInteractionEnabled = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initializeGame() {
        monsterImg.respawnMonster()
        
        do {
            try musicPlayer = AVAudioPlayer(contentsOfURL: NSURL.fileURLWithPath(NSBundle.mainBundle().pathForResource("cave-music", ofType: "mp3")!))
            try sfxBite = AVAudioPlayer(contentsOfURL: NSURL.fileURLWithPath(NSBundle.mainBundle().pathForResource("bite", ofType: "wav")!))
            try sfxHeart = AVAudioPlayer(contentsOfURL: NSURL.fileURLWithPath(NSBundle.mainBundle().pathForResource("heart", ofType: "wav")!))
            try sfxSkull = AVAudioPlayer(contentsOfURL: NSURL.fileURLWithPath(NSBundle.mainBundle().pathForResource("skull", ofType: "wav")!))
            try sfxDeath = AVAudioPlayer(contentsOfURL: NSURL.fileURLWithPath(NSBundle.mainBundle().pathForResource("death", ofType: "wav")!))
            
            musicPlayer.prepareToPlay()
            musicPlayer.numberOfLoops = -1
            musicPlayer.volume = 0.05
            musicPlayer.play()
            
            sfxBite.prepareToPlay()
            sfxHeart.prepareToPlay()
            sfxSkull.prepareToPlay()
            sfxDeath.prepareToPlay()
            
        } catch let error as NSError {
            print("\(error.description)")
        }
        
        numOfAvailableLives = MAXIMUM_PENALTIES
        
        penaltyImages.append(penalty1Img)
        penaltyImages.append(penalty2Img)
        penaltyImages.append(penalty3Img)
        
        penalty1Img.alpha = DIM_ALPHA
        penalty2Img.alpha = DIM_ALPHA
        penalty3Img.alpha = DIM_ALPHA
        
        monsterHeartImg.alpha = OPAQUE
        monsterFoodImg.alpha = OPAQUE
        
        monsterHeartImg.userInteractionEnabled = true
        monsterFoodImg.userInteractionEnabled = true
        
        monsterFoodImg.dropTarget = monsterImg
        monsterHeartImg.dropTarget = monsterImg
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.itemDroppedonCharacter(_:)), name: "onTargetDropped", object: nil)
        
        RespawnBtn.hidden = true
        
        generateRandomNeed()
        startTimer(3.0)
    }
    
    func startTimer(duration: Double) {
        if timer != nil {
            timer.invalidate()
        }
        timer = NSTimer.scheduledTimerWithTimeInterval(duration, target: self, selector: #selector(ViewController.changeGameState), userInfo: nil, repeats: true)
    }
    
    func changeGameState() {
        if !monsterFed && !monsterLoved {
            sfxSkull.volume = 0.1
            sfxSkull.play()
            
            if numOfAvailableLives > 0 {
                penaltyImages[MAXIMUM_PENALTIES - numOfAvailableLives].alpha = OPAQUE
                numOfAvailableLives = numOfAvailableLives - 1
            }
            
            if numOfAvailableLives == 0 {
                terminateGame()
            }
        }
        
        monsterFed = false
        monsterLoved = false
        
        generateRandomNeed()
    }
    
    func generateRandomNeed() {
        let rand = arc4random_uniform(2)
        
        if numOfAvailableLives > 0 {
            if rand == 0 {
                monsterHeartImg.userInteractionEnabled = false
                monsterFoodImg.userInteractionEnabled = true
                
                monsterHeartImg.alpha = DIM_ALPHA
                monsterFoodImg.alpha = OPAQUE
                
            } else if rand == 1 {
                monsterFoodImg.userInteractionEnabled = false
                monsterHeartImg.userInteractionEnabled = true
                
                monsterFoodImg.alpha = DIM_ALPHA
                monsterHeartImg.alpha = OPAQUE
            }
            
        }

    }
    
    func terminateGame() {
        timer.invalidate()
        sfxDeath.volume = 0.1
        sfxDeath.play()
        monsterImg.playDeathAnimation()
        
        monsterFoodImg.userInteractionEnabled = false
        monsterHeartImg.userInteractionEnabled = false
        
        monsterFoodImg.alpha = DIM_ALPHA
        monsterHeartImg.alpha = DIM_ALPHA
        
        RespawnBtn.hidden = false
    }
    
    
    @IBAction func respawnBtnPressed(sender: AnyObject) {
        initializeGame()
    }
    
}

