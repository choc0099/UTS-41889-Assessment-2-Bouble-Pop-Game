//
//  Game.swift
//  Bobble Pop
//
//  Created by Christopher Averkos on 5/4/2023.
//

import Foundation

class Game {  
    var players: [Player] = []
    var highScores: [String: Double] = [:]
    
    let gameSettings = GameSettings()
    
    func addHighScore(player: Player, highScore: Double) {
        highScores[player.getPlayerName()!] = highScore
    }
    
    func addPlayers(player: Player)
    {
        players.append(player)
    }
    
    func getPlayers() -> [Player]
    {
        var gamePlayers: [Player] = []
        
        for player in players {
            gamePlayers.append(player)
        }
        return gamePlayers
    }
    
    func getGameSettings() -> GameSettings {
        return gameSettings
    }
}
    
    
