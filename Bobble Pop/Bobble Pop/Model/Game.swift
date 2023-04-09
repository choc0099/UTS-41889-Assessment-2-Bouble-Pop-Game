//
//  Game.swift
//  Bobble Pop
//
//  Created by Christopher Averkos on 5/4/2023.
//

import Foundation

class Game {

    //let score: Score
    
    var players: [Player] = []
    var highScores: [String: Double] = [:]
      
    

    
    func addHighScore(player: Player, highScore: Double) {
        highScores[player.getPlayerName()!] = highScore
    }
  
    
    func addPlayers(player: Player)
    {
        players.append(player)
    }
 
    
    func getPlayers()
    {
        for player in players {
            print("\(player.getPlayerName()!)")
        }
    }
}
