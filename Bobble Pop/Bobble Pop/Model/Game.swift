//
//  Game.swift
//  Bobble Pop
//
//  Created by Christopher Averkos on 5/4/2023.
//

import Foundation

class Game {
    var playerName: String
    var numberOfBubbles: Int
    var timerSet: Int
    
    init(playerName: String, numberOfBubbles: Int, timerSet: Int) {
        self.playerName = playerName
        self.numberOfBubbles = numberOfBubbles
        self.timerSet = timerSet
    }
    
}
