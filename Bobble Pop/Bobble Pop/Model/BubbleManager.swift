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
    
    //helper functions to check for overlap
   private func checkBubbleOverlap(currentXPosition: Int, newXPosition: Int, currentYPosition: Int, newYPosition: Int) -> Bool {
        let positionFrame = 55 // defines an square area of the position bounds.
        
        //determines the bounderies of each direction
        let currentXPositionMaxLeftBounds = currentXPosition - positionFrame // X pos left bounds
        let currentXPositionMaxRightBounds = currentXPosition + positionFrame
        let currentYPositionMaxTopBounds = currentYPosition - positionFrame
        let currentYPositionMaxBottomBounds = currentYPosition + positionFrame
                
        guard newXPosition > currentXPositionMaxLeftBounds && newXPosition < currentXPositionMaxRightBounds else {
            return false
        }
        
        guard newYPosition > currentYPositionMaxTopBounds && newYPosition < currentYPositionMaxBottomBounds else {
            return false
        }
        return true
        
    }
    
    func isOverlap(newXPosition: Int, newYPosition: Int) -> Bool
    {
        let storedBubbles = game.getAllBubbles()
        
        for bubble in storedBubbles {
            //let currentBubbleId = bubble.getBubbleId()
            let currentXPos = bubble.getStoredXPos()
            let currentYPos = bubble.getStoredYPos()
            //print("xPos test: bubbleId: \(currentBubbleId) xPos: \(currentXPos), yPos: \(currentYPos)")
            if checkBubbleOverlap(currentXPosition: currentXPos, newXPosition: newXPosition, currentYPosition: currentYPos, newYPosition: newYPosition)
            {
                //print("\(currentBubbleId) is overlapped")
                return true
            }
        }
        return false
    }
}
