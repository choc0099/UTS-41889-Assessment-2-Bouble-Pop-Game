//
//  HighScoreManager.swift
//  Bobble Pop
//
//  Created by Christopher Averkos on 19/4/2023.
//
// This is a class containing static methods to manage the players scores that are stored on userDefaults.

import Foundation

class HighScoreManager {
  
    static func readHighScroes() -> [GameScore] {
        // Read from User Defaults
        // This should happen at the HighScrollViewController
        let defaults = UserDefaults.standard;
        if let savedArrayData = defaults.value(forKey:Game.KEY_HIGH_SCORE) as? Data {
            if let array = try? PropertyListDecoder().decode(Array<GameScore>.self, from: savedArrayData) {
                return array
            } else {
                return []
            }
        } else {
            return []
        }
    }
        
    static func writeHighScore(gameSession game: Game) {
        // Write high scores to User Defautls
        let defaults = UserDefaults.standard;
        // get the current data from current game state.
        let updatedGameScores = retrieveGameScores(gameSession: game)
        defaults.set(try? PropertyListEncoder().encode(updatedGameScores), forKey: Game.KEY_HIGH_SCORE)
    }
    
    //this is a function that retrieves the game scores taht is stored in memory so it can be written to userDefaults.
    private static func retrieveGameScores(gameSession game: Game) -> [GameScore] {
        var gameScores: [GameScore] = []
        //loops though the game players array
        for player in game.getPlayers() {
            //constansts for each player name and high score.
            let currentPlayerName = player.getPlayerName()
            let currentPlayerHightScore = player.getScore().getHighScore()
            //convert the class objects to the struct object
            let currentGameScore: GameScore = GameScore(name: currentPlayerName!, score: currentPlayerHightScore)
            gameScores.append(currentGameScore)
        }
        //print(gameScores) //debug
        return gameScores
    }
    
    //An additional feature
    //this is a function to clear the high scores and players from userDefaults.
    static func clearScores() {
        let defaults = UserDefaults.standard
        //clear from userDefaults using the specified key.
        defaults.removeObject(forKey: Game.KEY_HIGH_SCORE)
    }
}
