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
    
    //stores all the bubble attributes into an array to mark xPositions and yPositions when the bubble is added onto the screen.
    var storedBubbles: [Bubble] = []
    
    //var storedYPositions: [Int: Int] = [:]
    //var storedXPositions: [Int: Int] = [:]
    
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
        
        //print(currentViewHeight)
        
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
        
        let xPosition = Int.random(in: 50...viewWidth - 60)
        let yPosition = Int.random(in: 160...viewHeight - 80)
        if !checkAllXYPosOverlap(newXPosition: xPosition, newYPosition: yPosition) {
            let bubble = Bubble()
            bubble.changePosition(randomNumberToHeightBounds: yPosition, randomNumberToWidthBounds: xPosition)
            bubble.addTarget(self, action: #selector(bubblePressed), for: .touchUpInside)
            print("yPos: \(bubble.getStoredYPos()), xPos: \(bubble.getStoredXPos())")
                  
            self.view.addSubview(bubble)
            bubbleId += 1
            bubble.setBubbleId(bubbleId: bubbleId)
            storedBubbles.append(bubble)
            //storedXPositions[bubbleId] = xPosition
            //storedYPositions[bubbleId] = yPosition
        }
     
        //print(isOverlap(newXPosition: xPosition, newYPosition: yPosition)) //debug
        //print("Current X Pos: \(currentXPositionMarker), current Y Pos: \(currentYPositionMarker)") //debug
    }
    
    //helper functions to check for overlap
    func isXYPosOverlap(currentXPosition: Int, newXPosition: Int, currentYPosition: Int, newYPosition: Int) -> Bool {
        let positionFrame = 55
        
        //determines the bounderies of each direction
        let currentXPositionMaxLeftBounds = currentXPosition - positionFrame
        let currentXPositionMaxRightBounds = currentXPosition + positionFrame
        let currentYPositionMaxTopBounds = currentYPosition - positionFrame
        let currentYPositionMaxBottomBounds = currentYPosition + positionFrame
        
        //print("xPos info, old: \(currentXPosition), new: \(newXPosition) left: \(currentXPositionMaxLeftBounds), right: \(currentXPositionMaxRightBounds)")
        //print("yPos info, old: \(currentYPosition), new: \(newYPosition) top: \(currentYPositionMaxTopBounds), bottom: \(currentYPositionMaxBottomBounds)")
        
       
        if newXPosition > currentXPositionMaxLeftBounds && newXPosition <= currentXPositionMaxRightBounds {
            //print("xPos is overlapped ")
            if newYPosition > currentYPositionMaxTopBounds && newYPosition < currentYPositionMaxBottomBounds
            {
                //print("yPos is overlapped")
                return true
            }
            return false
            
        }
        //print("there was no overlap in both xpos and ypos")
        return false
        
    }
    /*
    func isYPosOverlap(currentYPosition: Int, newYPosition: Int) -> Bool
    {
        let currentYPositionTopBounds = currentYPosition - 15
        let currentYPositionBottomBounds = currentYPosition + 15
        
        if newYPosition >= currentYPositionTopBounds || newYPosition <= currentYPositionBottomBounds {
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
    }*/
    
    func isOverlap(newXPosition: Int, newYPosition: Int) -> Bool
    {
        let xyPos: Bool = checkAllXYPosOverlap(newXPosition: newXPosition, newYPosition: newYPosition)
        //let yPos: Bool = checkOverlapYPositions(newYPosition: newYPosition)
        
        if xyPos == true {
            print("overlapped")
            return true
        }
        else
        {
            print("Not overlapped")
            return false
        }
    }
    
    
    func checkAllXYPosOverlap(newXPosition: Int, newYPosition: Int) -> Bool
    {
        for bubble in storedBubbles {
            let currentBubbleId = bubble.getBubbleId()
            let currentXPos = bubble.getStoredXPos()
            let currentYPos = bubble.getStoredYPos()
            print("xPos test: bubbleId: \(currentBubbleId) xPos: \(currentXPos), yPos: \(currentYPos)")
            if isXYPosOverlap(currentXPosition: currentXPos, newXPosition: newXPosition, currentYPosition: currentYPos, newYPosition: newYPosition)
            {
                print("\(currentBubbleId) is overlapped")
                return true
            }
        }
        return false
    }
    /*
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
