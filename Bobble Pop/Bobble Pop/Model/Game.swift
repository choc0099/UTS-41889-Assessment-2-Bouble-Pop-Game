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
    var storedBubbles: [Bubble] = [] //stores the bubbles onto an array to help with checking for positions overlaps.
    let gameSettings = GameSettings()
    
    static let KEY_HIGH_SCORE = "highScore"
    
    func addHighScore(player: Player, highScore: Double) {
        highScores[player.getPlayerName()!] = highScore
    }
    
    func addPlayer(player: Player) {
        players.append(player)
    }
    
    //gets the game players.
    func getPlayers() -> [Player] {
        var gamePlayers: [Player] = []
        //adds all the gamePlayers and returns it as an array.
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
    
    func storeBubble(bubble: Bubble) {
        storedBubbles.append(bubble)
    }
    
    func removeBubble(bubbleId: Int) {
        var indexCounter = 0
        for bubble in storedBubbles {
            if bubble.getBubbleId() == bubbleId {
                storedBubbles.remove(at: indexCounter)
                break
            }
            indexCounter += 1
        }
    }
    
    func getAllBubbles() -> [Bubble] {
        return storedBubbles
    }
    
    func removeAllBubbles() {
        storedBubbles.removeAll()
    }
}
