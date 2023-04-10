//
//  Bubble.swift
//  Bobble Pop
//
//  Created by Christopher Averkos on 5/4/2023.
//

import Foundation
import UIKit

class Bubble: UIButton {
    
    let xPosition = Int.random(in: 20...310)
    let yPosition = Int.random(in: 170...700)
    //let points: Int?
    
    var points = 0
    
    override init(frame: CGRect){
        super.init(frame: frame)
        let randomNumber = Int.random(in: 0...1000)
        print(randomNumber) // debug
        self.backgroundColor = selectBubbleColor(randomOnly: randomNumber)
        self.frame = CGRect(x: xPosition, y: yPosition, width: 50, height: 50 )
        self.layer.cornerRadius = 0.5 * self.bounds.size.width
        
        //assign the points to the bubble.
        points = selectPoints(randomOnly: randomNumber)
    }
    
    required init?(coder: NSCoder)
    {
        fatalError("Init(coder: ) has not been implemented")
    }
    
    func animation() {
        let springAnimation = CASpringAnimation(keyPath: "transform.scale")
        springAnimation.duration = 0.6
        springAnimation.fromValue = 1
        springAnimation.toValue = 0.8
        springAnimation.repeatCount = 1
        springAnimation.initialVelocity = 0.5
        springAnimation.damping = 1
        
        layer.add(springAnimation, forKey: nil)
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
    
    //random colour helper function
    func selectBubbleColor(randomOnly randomNumber: Int) -> UIColor {
        //
        
        switch randomNumber {
        case 0...50:
            print("Black bubble added")
            return .black
        case 51...150:
            print("Blue bubble added")
            return .blue
        case 151...300:
            print("Green button added")
            return .green
        case 301...600:
            print("Pink button added.")
            return .systemPink
        default:
            print("Red button added")
            return .red
        }
    }
    
    //helper function to select the points based on button color
    func selectPoints(randomOnly randomNumber: Int) -> Int
    {
        switch randomNumber {
        case 0...50:
            return 10
        case 51...150:
            return 8
        case 151...300:
            return 5
        case 301...600:
            return 2
        default:
            return 1
        }
    }
    
    func getPoints() -> Int
    {
        return points
    }
}
