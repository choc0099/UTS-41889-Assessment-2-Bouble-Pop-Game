//
//  GamePlayViewController.swift
//  Bobble Pop
//
//  Created by Christopher Averkos on 4/4/2023.
//

import Foundation
import UIKit

class GamePlayViewController: UIViewController {
    
    @IBOutlet weak var remainingTimeLabel: UILabel!
    @IBOutlet weak var highScoreLabel: UILabel!
    @IBOutlet weak var currentScoreLabel: UILabel!
    
    var remainingTime = 0
    var currentScore = 0
    var playerHighScore = 0
    var timer = Timer()
    var game = Game()
    var currentPlayer = Player()
    //var currentYPositionMarker = 0
    //var currentXPositionMarker = 0
    
    var storedYPositions: [Int: Int] = [:]
    var storedXPositions: [Int: Int] = [:]
    
    var bubbleCounterSet = 0
    var bubbleCounter = 0
    
    var bubbleId = 0
    
    //var score: Score = Score()
    
    /*init(game: Game)
     {
     self.game = game
     super.init(nibName: nil, bundle: nil)
     }
     
     required init?(coder: NSCoder) {
     fatalError("Failed to implement \(coder) class.")
     }*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //var bubbleView = UIView()
        
        let currentViewWidth: Int = Int(self.view.bounds.width)
        let currentViewHeight: Int = Int(self.view.bounds.height)
        
        print(currentViewHeight)
        
        // Do any additional setup after loading the view.
        remainingTimeLabel.text = String(remainingTime)
        //game.getPlayers()
        //let currentPlayerId = currentPlayer.getPlayerId()
        //print(currentPlayer.getPlayerName()!)
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {
            timer in
            self.countingDown()
            self.generateBubble(viewHeight: currentViewHeight, viewWidth: currentViewWidth)
        }
    }

    @objc func countingDown() {
        remainingTime -= 1
        remainingTimeLabel.text = String(remainingTime)
        
        if remainingTime == 0 {
            timer.invalidate()
            let VC = storyboard?.instantiateViewController(identifier: "HighScoreViewController") as! HighScoreViewController
            self.navigationController?.pushViewController(VC, animated: true)
            VC.navigationItem.setHidesBackButton(true, animated: true)
        }
    }
    
    func generateBubble(viewHeight: Int, viewWidth: Int) {
        let bubble = Bubble()
        let xPosition = Int.random(in: 30...viewWidth - 60)
        let yPosition = Int.random(in: 160...viewHeight - 80)
        
        bubble.changePosition(randomNumberToHeightBounds: yPosition, randomNumberToWidthBounds: xPosition)
        bubble.addTarget(self, action: #selector(bubblePressed), for: .touchUpInside)
        print("yPos: \(yPosition), xPos: \(xPosition)")
        if !isOverlap(newXPosition: xPosition, newYPosition: yPosition)
        {
            self.view.addSubview(bubble)
            bubbleId += 1
            storedXPositions[bubbleId] = xPosition
            storedYPositions[bubbleId] = yPosition
        }
     
        //print(isOverlap(newXPosition: xPosition, newYPosition: yPosition)) //debug
        //print("Current X Pos: \(currentXPositionMarker), current Y Pos: \(currentYPositionMarker)") //debug
    }
    
    //helper functions to check for overlap
    func isXPosOverlap(currentXPosition: Int, newXPosition: Int) -> Bool {
        //let positionFrame = 10
        
        let currentXPositionLeftBounds = currentXPosition - 60
        let currentXPositionRightBounds = currentXPosition + 60
        //let newXPositionLeftBounds = newXPosition - positionFrame
        //let newXPositionRightBounds = newXPosition + positionFrame
        
        print("old: \(currentXPosition), new: \(newXPosition) left: \(currentXPositionLeftBounds), right: \(currentXPositionRightBounds)")
        if newXPosition >= currentXPositionLeftBounds && newXPosition <= currentXPosition {
            print("The bubble overlapped to the left at \(currentXPositionLeftBounds) of \(currentXPosition) from \(newXPosition).")
            return true
        }
        else if newXPosition <= currentXPositionRightBounds && newXPosition >= currentXPosition
        {
            print("The bubble has been overlapped to the right at \(currentXPositionRightBounds) of \(currentXPosition) from \(newXPosition).")
            return true
        }
        else
        {
            print("xPos not overlapped.")
           
            return false
        }
    }
    
    func isYPosOverlap(currentYPosition: Int, newYPosition: Int) -> Bool
    {
        let currentYPositionTopBounds = currentYPosition - 15
        let currentYPositionBottomBounds = currentYPosition + 15
        
        if newYPosition >= currentYPositionTopBounds && newYPosition <= currentYPosition {
            print("The bubble overlapped to the top.")
            return true
        }
        if newYPosition <= currentYPositionBottomBounds && newYPosition >= currentYPosition
        {
            print("The bubble has been overlapped to the bottom.")
            return true
        }
        else
        {
            print("yPos is not overlapped.")
            return false
        }
    }
    
    func isOverlap(newXPosition: Int, newYPosition: Int) -> Bool
    {
        let xPos: Bool = checkOverlapXPositions(newXPosition: newXPosition)
        //let yPos: Bool = checkOverlapYPositions(newYPosition: newYPosition)
        
        if xPos == true { //|| yPos == true {
            print("overlapped")
            return true
        }
        else
        {
            print("Not overlapped")
            return false
        }
    }
    
    
    func checkOverlapXPositions(newXPosition: Int) -> Bool
    {
        for (key, value) in storedXPositions {
            print("xPos test: bubbleId: \(key), xPos: \(value)")
            if isXPosOverlap(currentXPosition: value, newXPosition: newXPosition)
            {
                return true
            }
        }
        return false
    }
    
    func checkOverlapYPositions(newYPosition: Int) -> Bool
    {
        for (key, value) in storedYPositions {
            print("yPos test: bubbleId: \(key), yPos: \(value)")
            if isYPosOverlap(currentYPosition: value, newYPosition: newYPosition)
            {
                return true
            }
        }
        return false
    }
    
    /*
    func overlapDiaginal(currentXPos: Int, currentYPos: Int, newXPos: Int, newYPos: Int) {
        let boundsFrame = 20
        
        let newPos: [Int] = [newXPos, newYPos]
        let currentPos: [Int] = [currentXPos, currentYPos]
        
        let currentXPosLeftBounds = currentXPos - boundsFrame
        let currentXPosRightBounds = currentXPos + boundsFrame
        let currentYPosTopBounds = currentYPos - boundsFrame
        let currentYPosBottomBounds = currentYPos + boundsFrame
        
        let currentPosBottomLeftBounds: [Int] = [currentXPosLeftBounds, currentYPosBottomBounds]
        let currentPosBottomRightBounds: [Int] = [currentXPosRightBounds, currentYPosBottomBounds]
        let currentPosTopLeftBounds: [Int] = [currentXPosLeftBounds, currentYPosTopBounds]
        let currentPosTopRightBounds: [Int] = [currentXPosRightBounds, currentYPosTopBounds]
        
        //if (newXPos >= )
        
    }
     */
        
    func updateUI() {
        currentScoreLabel.text = String(currentScore)
        highScoreLabel.text = String(playerHighScore)
    }
    
    @IBAction func bubblePressed(_ sender: Bubble) {
        let currentPlayerScore = currentPlayer.getScore()        
        sender.removeFromSuperview()
        currentScore = sender.getPoints()
        currentPlayerScore.computeHighScore(currentScore: currentScore)
        playerHighScore = currentPlayerScore.getHighScore()
        updateUI()
    }
}
