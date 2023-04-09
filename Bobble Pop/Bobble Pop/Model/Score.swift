//
//  Score.swift
//  Bobble Pop
//
//  Created by Christopher Averkos on 5/4/2023.
//

import Foundation

class Score {
    
    var highScores: [String: Double] = [:]

    
    func addHighScore(player: Player, highScore: Double) {
        highScores[player.getPlayerName()!] = highScore
    }

}
