//
//  Score.swift
//  Bobble Pop
//
//  Created by Christopher Averkos on 5/4/2023.
//

import Foundation

class Score {
    
    var highScore: Int = 0
    
    //computes the high score when the bubble is pressed by adding up the current score to the high scores.
    func computeHighScore(currentScore: Int)
    {
        highScore += currentScore
    }
    
    func setScore(currentScore: Int) {
        highScore = currentScore
    }
    
    func getHighScore() -> Int {
        return highScore
    }
}
