//
//  Bubble.swift
//  Bobble Pop
//
//  Created by Christopher Averkos on 5/4/2023.
//

import Foundation
import UIKit

enum animationDirection {
    case left
    case right
    case up
    case down
}

class Bubble: UIButton {
    
    //let xPosition = Int.random(in: 20...310)
    //let yPosition = Int.random(in: 170...700)
    var storedXPos = 0
    var storedYPos = 0
    var bubbleId = 0
    var points = 0
    var deviceWidth = 0
    var deviceHeight = 0
    let animationDirectionArray = [animationDirection.left, animationDirection.right, animationDirection.up, animationDirection.down]
    
    override init(frame: CGRect){
        super.init(frame: frame)
        let randomNumber = Int.random(in: 0...1000)
        //print(randomNumber) // debug
        self.selectAttributes(randomOnly: randomNumber)
        self.titleLabel?.font = .boldSystemFont(ofSize: 14)
    }
    
    required init?(coder: NSCoder)
    {
        fatalError("Init(coder: ) has not been implemented")
    }
    
    func setPosition(randomNumberToHeightBounds superViewHeight: Int, randomNumberToWidthBounds superViewWidth: Int) {
        self.frame = CGRect(x: superViewWidth, y: superViewHeight, width: 50, height: 50)
        self.layer.cornerRadius = 0.50 * self.bounds.size.width
        storedXPos = superViewWidth
        storedYPos = superViewHeight
    }
    
    func setDeviceWidthAndHeight(deviceWidth: Int, deviceHeight: Int) {
        self.deviceWidth = deviceWidth
        self.deviceHeight = deviceHeight
    }
    
    func animation() {
        let springAnimation = CASpringAnimation(keyPath: "transform.scale")
        springAnimation.duration = 0.6
        springAnimation.fromValue = 0.1
        springAnimation.toValue = 0.8
        springAnimation.repeatCount = 1
        springAnimation.initialVelocity = 0.5
        //springAnimation.damping = 1
        
        layer.add(springAnimation, forKey: nil)
    }
    
    func scaleIn() {
        let scaleInAnnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleInAnnimation.fromValue = 0
        scaleInAnnimation.toValue = 1
        scaleInAnnimation.duration = 0.2
        
        layer.add(scaleInAnnimation, forKey: nil)
    }
    
    func scaleOut() {
        let scaleOUtAnnimation = CABasicAnimation(keyPath: "transform.scale")
        
        scaleOUtAnnimation.fromValue = 1
        scaleOUtAnnimation.toValue = 0
        scaleOUtAnnimation.duration = 1
        scaleOUtAnnimation.speed = 0.5
        scaleOUtAnnimation.isRemovedOnCompletion = true
        layer.add(scaleOUtAnnimation, forKey: nil)
        //self.removeFromSuperview()
    }

    
    func flash() {
        let flash = CABasicAnimation(keyPath: "opacity")
        flash.duration = 0.2
        flash.fromValue = 1
        flash.toValue = 0.1
        flash.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        flash.autoreverses = true
        flash.repeatCount = 3
        
        layer.add(flash, forKey: nil)
    }
    
    func toValueXYPos() -> [Int] {
        let randomDirection = animationDirectionArray.randomElement()
        
        var newXPos = storedXPos
        var newYPos = storedYPos
        
        switch randomDirection {
        case .left:
            newXPos -= 150
        case .right:
            newXPos += 150
        case .up:
            newYPos -= 200
        case .down:
            newYPos += 200
        default:
            newXPos = 0
            newYPos = 0
        }
        return [newXPos, newYPos]
    }
    
    func moveBubblePos() {
        let moveAnimation = CABasicAnimation(keyPath: "position")
        
        let currentXPos = getStoredXPos()
        let currentYPos = getStoredYPos()
        
        moveAnimation.fromValue = [currentXPos, currentYPos]
        moveAnimation.toValue = toValueXYPos()
        moveAnimation.speed = 0.05
        
        //moveAnimation.initialVelocity = 0.5
        layer.add(moveAnimation, forKey: nil)
        self.frame = CGRect(x: toValueXYPos()[0], y: toValueXYPos()[1], width: 50, height: 50)
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
}
