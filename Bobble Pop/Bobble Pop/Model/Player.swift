//
//  Player.swift
//  Bobble Pop
//
//  Created by Christopher Averkos on 6/4/2023.
//

import Foundation

class Player {
    let playerName: String?
    
    init(playerName: String)
    {
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
