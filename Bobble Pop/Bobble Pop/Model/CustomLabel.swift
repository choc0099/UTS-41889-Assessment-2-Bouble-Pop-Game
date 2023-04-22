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
        self.frame = CGRect(x: 0, y: 0, width: 125 , height: 125)
        self.font = .boldSystemFont(ofSize: 96)
        self.textAlignment = .center
        //self.backgroundColor = .systemGray
    }
    
    required init?(coder: NSCoder) {
        fatalError("Init(coder: ) has not been implemented")
    }
    
    func setNumber(number: Int)
    {
        self.text = String(number)
    }
    
    func flash() {
        let flash = CABasicAnimation(keyPath: "opacity")
        flash.duration = 0.5
        flash.fromValue = 1
        flash.toValue = 0
        flash.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        //flash.autoreverses = true
        flash.repeatCount = 0
        
        layer.add(flash, forKey: nil)
    }
}
