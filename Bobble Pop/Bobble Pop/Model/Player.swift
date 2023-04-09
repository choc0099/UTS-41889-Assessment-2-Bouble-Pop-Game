//
//  Player.swift
//  Bobble Pop
//
//  Created by Christopher Averkos on 6/4/2023.
//

import Foundation

class Player {
    let playerName: String?
    let playerId: Int?
    let score = Score()
    
    init(playerName: String, playerId: Int)
    {
        self.playerId = playerId
        self.playerName = playerName 
    }
    
    //empty initializer for the game view controllers
    init() {
        playerName = nil
        playerId = nil
    }
    
    func getPlayerName() -> String? {
        if playerName != nil {
            return playerName
        }
        else {
            return nil
        }
    }
    
    func getPlayerId() -> Int? {
        return playerId
    }
    
    func getScore() -> Score {
        return score
    }
}
