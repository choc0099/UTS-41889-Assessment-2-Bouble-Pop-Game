//
//  Score.swift
//  Bobble Pop
//
//  Created by Christopher Averkos on 5/4/2023.
//

import Foundation

class Score {
    
  
  
    
    //let player: Player?
    var highScore: Int?
    let playerId: Int
    
    init(_ playerId: Int)
    {
        self.playerId = playerId
    }
    
    
    
    
    func computeHighScore(currentScore: Int)
    {
        if var unwrappedHighScore = highScore {
            unwrappedHighScore += currentScore
        }
        else
        {
            highScore = currentScore
        }
    }
    
    func getHighScore() -> Int?
    {
        if highScore != nil {
            return highScore!
        }
        else
        {
            return nil
        }
    }

    
    //var highScores: [String: Double] = [:]

    
    
    /*
    func addHighScore(player: Player, highScore: Double) {
        highScores[player.getPlayerName()!] = highScore
    }*/

}
