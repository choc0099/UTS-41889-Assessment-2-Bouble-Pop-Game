//
//  HighScoreManager.swift
//  Bobble Pop
//
//  Created by Christopher Averkos on 19/4/2023.
//

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
    
    func writeHighScore(gameSession game: Game) {
        // Write high scores to User Defautls
        let defaults = UserDefaults.standard;
        // get the current data from current game state.
        let updatedGameScores = retrieveGameScores(gameSession: game)
    
        defaults.set(try? PropertyListEncoder().encode(updatedGameScores), forKey: Game.KEY_HIGH_SCORE)
    }
    
    func retrieveGameScores(gameSession game: Game) -> [GameScore]
    {
        var gameScores: [GameScore] = []
        
        for player in game.getPlayers()
        {
            let currentPlayerName = player.getPlayerName()
            let currentPlayerHightScore = player.getScore().getHighScore()
            //convert the class objects to the struct object
            let currentGameScore: GameScore = GameScore(name: currentPlayerName!, score: currentPlayerHightScore)
            gameScores.append(currentGameScore)
            
        }
        //print(gameScores) //debug
        return gameScores
    }
    

}
