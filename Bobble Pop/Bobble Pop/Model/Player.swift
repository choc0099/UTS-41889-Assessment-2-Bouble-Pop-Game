//
//  Player.swift
//  Bobble Pop
//
//  Created by Christopher Averkos on 6/4/2023.
//

import Foundation

class Player {
    let playerName: String?
    let score = Score()
    
    init(playerName: String)  {
        self.playerName = playerName 
    }
    
    //empty initializer for the game view controllers
    init() {
        playerName = nil
    }
    
    func getPlayerName() -> String? {
        if playerName != nil {
            return playerName
        }
        else {
            return nil
        }
    }
  
    func getScore() -> Score {
        return score
    }
}
