//
//  Bubble.swift
//  Bobble Pop
//
//  Created by Christopher Averkos on 5/4/2023.
//

import Foundation
import UIKit


class Bubble: UIButton {
    var storedXPos = 0
    var storedYPos = 0
    var bubbleId = 0
    var points = 0
    var deviceWidth = 0
    var deviceHeight = 0
   
    var animationRemainingTime = 1
    var removeBubbleTimer = Timer()
    
    //stores the game session to the Bubble class
    var game = Game()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let randomNumber = Int.random(in: 0...1000)
        self.selectAttributes(randomOnly: randomNumber)
        self.titleLabel?.font = .boldSystemFont(ofSize: 21)
        self.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Init(coder: ) has not been implemented")
    }
    
    func setPositionAndSize(randomNumberToHeightBounds superViewHeight: Int, randomNumberToWidthBounds superViewWidth: Int, bubbleSize: Int) {
        self.frame = CGRect(x: superViewWidth, y: superViewHeight, width: bubbleSize, height: bubbleSize)
        self.layer.cornerRadius = 0.50 * self.bounds.size.width
        storedXPos = superViewWidth
        storedYPos = superViewHeight
        
        //adjusts the colour label text sizes
        switch bubbleSize {
        case 65...76:
            self.titleLabel?.font = .boldSystemFont(ofSize: 26)
        case 77...100:
            self.titleLabel?.font = .boldSystemFont(ofSize: 34)
        case 25...40:
            self.titleLabel?.font = .boldSystemFont(ofSize: 16)
        default:
            self.titleLabel?.font = .boldSystemFont(ofSize: 21)
        }
        
        
    }
    
    func setDeviceWidthAndHeight(deviceWidth: Int, deviceHeight: Int) {
        self.deviceWidth = deviceWidth
        self.deviceHeight = deviceHeight
    }
    
    func scaleIn() {
        let scaleInAnnimation = CASpringAnimation(keyPath: "transform.scale")
        scaleInAnnimation.fromValue = 0
        scaleInAnnimation.toValue = 1
        scaleInAnnimation.duration = 0.15
        scaleInAnnimation.speed = 1
        scaleInAnnimation.initialVelocity = 0.2
        scaleInAnnimation.damping = 1
        layer.add(scaleInAnnimation, forKey: nil)
    }
    
    func scaleOutAndRemove() {
        let scaleOutAnnimation = CASpringAnimation(keyPath: "transform.scale")
        scaleOutAnnimation.fromValue = 1
        scaleOutAnnimation.toValue = 0
        scaleOutAnnimation.duration = 0.5
        scaleOutAnnimation.speed = 1
        scaleOutAnnimation.initialVelocity = 0.2
        //scaleOutAnnimation.damping = 1
        layer.add(scaleOutAnnimation, forKey: nil)
        removeAfterAnimation(timeInterval: 0.5)
    }
    
    func flyOutAndRemove() {
        let flyOutAnimation = CABasicAnimation(keyPath: "position.y")
        
        flyOutAnimation.fromValue = getStoredYPos()
        flyOutAnimation.toValue = -50
        flyOutAnimation.duration = 1
        flyOutAnimation.speed = 1
        
        layer.add(flyOutAnimation, forKey: nil)
        //self.frame = CGRect(x: 0, y: 0, width: 0, height: 0) //this is used to prevent bubbles stuck on the top of the screen after is animated
        removeAfterAnimation(timeInterval: 1)
        //game.removeBubble(bubbleId: self.getBubbleId())
    }
    
    func moveAwayAnimation(remainingTimePercent: Int) {
        let gameSettings = game.gameSettings
        let screenHeight = gameSettings.getDeviceHeight()
        let screenWidth = gameSettings.getDeviceWidth()
        
        //this is used to determin where the nearest edge is for the bubble to be removed.
        var toValueXPos: Int = 0
        var toValueYPos: Int = 0
        
        if storedXPos > screenWidth / 2 {
            toValueXPos = screenWidth + 50
        }
        
        if storedYPos > screenHeight / 2 {
            toValueYPos = screenHeight + 100
        }
        
        var movingDuration: Float = 0
        var movingSpeed: Double = 0
        
        switch remainingTimePercent {
        case 51...75:
            print("Less than 75% triggered.")
            movingSpeed = 1.7
            movingDuration = 0.8
        case 26...50:
            print("Less than 50% triggered.")
            movingSpeed = 2
            movingDuration = 0.6
        case 0...25:
            print("Less than 25% trigered.")
            movingSpeed = 2.75
            movingDuration = 0.6
        default:
            movingSpeed = 1.3
            movingDuration = 0.8
        }
        
        let moveAway = CABasicAnimation(keyPath: "position")
        moveAway.fromValue = [storedXPos, storedYPos]
        moveAway.toValue = [toValueXPos, toValueYPos]
        moveAway.duration = movingSpeed
        moveAway.speed = movingDuration
        layer.add(moveAway, forKey: nil)
        removeAfterAnimation(timeInterval: Double(movingDuration))
        
    }
    
    func removeAfterAnimation(timeInterval: Double) {
        removeBubbleTimer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: false)  {
            removeBubbleTimer in
            self.timeToRemove()
        }
    }

    @objc func timeToRemove() {
        animationRemainingTime -= 1
        if animationRemainingTime == 0 {
            removeBubbleTimer.invalidate()
            self.removeFromSuperview()
        }
    }
    
    //random colour helper function
    //is used to cater for problability of appearance
    func selectAttributes(randomOnly randomNumber: Int) {
        switch randomNumber {
        case 0...50:
            self.backgroundColor = .black
            self.points = 10
            self.setTitle("BK", for: .normal)
        case 51...150:
            self.backgroundColor = .blue
            self.points = 8
            self.setTitle("B", for: .normal)
            self.setTitleColor(.black, for: .normal)
        case 151...300:
            self.backgroundColor = .green
            self.points = 5
            self.setTitle("G", for: .normal)
            self.setTitleColor(.black, for: .normal)
        case 301...600:
            self.backgroundColor = .systemPink
            self.points = 2
            self.setTitle("P", for: .normal)
        default:
            self.backgroundColor = .red
            self.points = 1
            self.setTitle("R", for: .normal)
        }
    }
    
    
    //accessibility features
    //function to clear the text labels if the user is not colour blind.
    func enableColorBlindnessLabels(isColorBlind: Bool) {
        if !isColorBlind {
            self.setTitle(nil, for: .normal)
        }
    }
    
    func getPoints() -> Int {
        return points
    }
    
    func getStoredXPos() -> Int {
        return storedXPos
    }
    
    func getStoredYPos() -> Int {
        return storedYPos
    }
    
    func setBubbleId(bubbleId: Int) {
        self.bubbleId = bubbleId
    }
    
    func getBubbleId() -> Int {
        return bubbleId
    }
    
    //passes the game class object to the bubble class.
    func initiateGameSession(gameSession game: Game)
    {
        self.game = game
    }
}
