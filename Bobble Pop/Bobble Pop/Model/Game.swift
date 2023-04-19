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
    
    static let KEY_HIGH_SCORE = "highScore"
    
    func addHighScore(player: Player, highScore: Double) {
        highScores[player.getPlayerName()!] = highScore
    }
    
    func addPlayer(player: Player)
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
    
    func clearAllPlayers() {
        players.removeAll()
    }
    
    func getGameSettings() -> GameSettings {
        return gameSettings
    }
    
}
    
    
