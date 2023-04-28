//
//  BubbleManager.swift
//  Bobble Pop
//
//  Created by Christopher Averkos on 22/4/2023.
//  This is a class to help manage the overlaps of the bubbles so it can be used accross different classes.

import Foundation

class BubbleManager {
    
    let game: Game
    
    init(game: Game)
    {
        self.game = game
    }
    
    func isOverlap(newBubble: Bubble) -> Bool {
        let storedBubbles = game.getAllBubbles()
        for bubble in storedBubbles {
            if newBubble.frame.intersects(bubble.frame) {
                return true
            }
        }
        return false
    }
}
