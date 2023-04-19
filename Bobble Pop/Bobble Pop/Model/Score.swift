//
//  Score.swift
//  Bobble Pop
//
//  Created by Christopher Averkos on 5/4/2023.
//

import Foundation

class Score {
    
    //let player: Player?
    var highScore: Int = 0
    //let playerId: Int
    
    /*init(_ playerId: Int)
    {
        self.playerId = playerId
    }*/
    
    func computeHighScore(currentScore: Int)
    {
        highScore += currentScore
    }
    
    func setScore(currentScore: Int)
    {
        highScore = currentScore
    }
    
    func getHighScore() -> Int
    {
        return highScore
    }

    /*
    func addHighScore(player: Player, highScore: Double) {
        highScores[player.getPlayerName()!] = highScore
    }*/

}
