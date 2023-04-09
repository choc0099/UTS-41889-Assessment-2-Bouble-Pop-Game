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
    
    init(playerName: String, playerId: Int)
    {
        self.playerId = playerId
        self.playerName = playerName 
    }
    
    func getPlayerName() -> String? {
        if playerName != nil {
            return playerName
        }
        else {
            return nil
        }
    }
}
