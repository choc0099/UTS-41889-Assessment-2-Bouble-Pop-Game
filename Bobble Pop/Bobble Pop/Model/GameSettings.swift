//
//  GameSettings.swift
//  Bobble Pop
//
//  Created by Christopher Averkos on 15/4/2023.
//

import Foundation

class GameSettings {
    var timer: Int = 60
    var numberOfBubbles: Int = 15
    
    func setTimer(howLong newTimerSet: Int)
    {
        self.timer = newTimerSet
    }
    
    func getTimer() -> Int {
        return timer
    }
    
    func setNumberOfBubbles(howMany numberOfBubblesSet: Int)
    {
        self.numberOfBubbles = numberOfBubblesSet
    }
    
    func getNumberOfBubbles() -> Int {
        return numberOfBubbles
    }
}
