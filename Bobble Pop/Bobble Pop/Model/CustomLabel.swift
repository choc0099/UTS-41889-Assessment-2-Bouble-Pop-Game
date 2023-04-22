//
//  CustomLabel.swift
//  Bobble Pop
//
//  Created by Christopher Averkos on 22/4/2023.
//

import Foundation
import UIKit

class CountDownLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.font = .boldSystemFont(ofSize: 72)
        self.textAlignment = .center
    }
    
    required init?(coder: NSCoder) {
        fatalError("Init(coder: ) has not been implemented")
    }
    
    func setNumber(number: Int)
    {
        self.text = String(number)
    }
    
    func setPosition(screenHeight: Int, screenWidth: Int)
    {
        self.frame = CGRect(x: screenHeight / 2, y: screenWidth / 2, width: 150, height: 150)
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
}
