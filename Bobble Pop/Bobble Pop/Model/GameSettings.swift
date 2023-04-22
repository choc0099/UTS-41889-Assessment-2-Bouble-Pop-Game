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
    var deviceWidth: Int = 0
    var deviceHeight: Int = 0
    var isColorBlind: Bool = false
    //init(deviceWidth: Int, deviceHeight: )
    
    
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
    
    func setDeviceWdihAndHeight(deviceWidth: Int, deviceHeight: Int) {
        self.deviceWidth = deviceWidth
        self.deviceHeight = deviceHeight
    }
    
    func getDeviceWidth() -> Int {
        return deviceWidth
    }
    
    func getDeviceHeight() -> Int {
        return deviceHeight
    }
    
    func setColorBlind(isColorBlind: Bool)
    {
        self.isColorBlind = isColorBlind
    }
    
    func getIsColorBlind() -> Bool {
        return isColorBlind
    }
}
