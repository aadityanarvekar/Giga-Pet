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
    
    var audio: AVAudioPlayer!
    var numOfAvailableLives: Int!
    var timer: NSTimer!
    
    var monsterFed: Bool = false
    var monsterLoved: Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeGame()
    }
    
    func itemDroppedonCharacter(notification: NSNotification) {
        if let obj = notification.object {
            if obj as! String  == "1" { // Heart fed to the giant
                let heartAudioURL = NSURL.fileURLWithPath(NSBundle.mainBundle().pathForResource("heart", ofType: "wav")!)
                playAudioFile(heartAudioURL, numOfLoops: 0)
                monsterLoved = true
            } else if obj as! NSObject == "2" { // Food fed to the giant
                let foodAudioURL = NSURL.fileURLWithPath(NSBundle.mainBundle().pathForResource("bite", ofType: "wav")!)
                playAudioFile(foodAudioURL, numOfLoops: 0)
                monsterFed = true
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func playAudioFile(fileURL: NSURL, numOfLoops: Int) {
        
        do {
            try audio = AVAudioPlayer(contentsOfURL: fileURL)
        } catch let error as NSError {
            print(error.description)
        }
        
        audio.prepareToPlay()
        audio.numberOfLoops = numOfLoops
        audio.volume = 0.1
        audio.play()
    }
    
    func initializeGame() {
        audio = AVAudioPlayer()
        numOfAvailableLives = MAXIMUM_PENALTIES
        
        penaltyImages.append(penalty1Img)
        penaltyImages.append(penalty2Img)
        penaltyImages.append(penalty3Img)
        
        penalty1Img.alpha = DIM_ALPHA
        penalty2Img.alpha = DIM_ALPHA
        penalty3Img.alpha = DIM_ALPHA
        
        monsterHeartImg.userInteractionEnabled = true
        monsterFoodImg.userInteractionEnabled = true
        
        monsterFoodImg.dropTarget = monsterImg
        monsterHeartImg.dropTarget = monsterImg
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.itemDroppedonCharacter(_:)), name: "onTargetDropped", object: nil)
        
        startTimer()
    }
    
    func startTimer() {
        if timer != nil {
            timer.invalidate()
        }
        timer = NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: #selector(ViewController.changeGameState), userInfo: nil, repeats: true)
    }
    
    func changeGameState() {
        if !monsterFed && !monsterLoved && numOfAvailableLives > 0 {
            let deathAudioURL = NSURL.fileURLWithPath(NSBundle.mainBundle().pathForResource("death", ofType: "wav")!)
            playAudioFile(deathAudioURL, numOfLoops: 0)
            
            penaltyImages[MAXIMUM_PENALTIES - numOfAvailableLives].alpha = OPAQUE
            numOfAvailableLives = numOfAvailableLives - 1
            
            if numOfAvailableLives == 0 {
                terminateGame()
            }
        }
        monsterFed = false
        monsterLoved = false
    }
    
    func terminateGame() {
        timer.invalidate()
        monsterImg.playDeathAnimation()
        monsterFoodImg.userInteractionEnabled = false
        monsterHeartImg.userInteractionEnabled = false
        NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(ViewController.playDeathMusic), userInfo: nil, repeats: false)
    }
    
    func playDeathMusic() {
        let caveMusicURL = NSURL.fileURLWithPath(NSBundle.mainBundle().pathForResource("cave-music", ofType: "mp3")!)
        playAudioFile(caveMusicURL, numOfLoops: -1)
    }
    

}

