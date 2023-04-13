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
    var bubbleId = 0
    var remainingTime = 0
    var currentScore: Double = 0
    var playerHighScore = 0
    var timer = Timer()
    var game = Game()
    var currentPlayer = Player()
    
    
    //stores all the bubble attributes into an array to mark xPositions and yPositions when the bubble is added onto the screen.
    var storedBubbles: [Bubble] = []
    
    
    var bubbleCounterSet = 0
    var bubbleCounter = 0
    
    var previousBubblePoints = 0
    
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
            self.removeAllBubbles()
            
            self.renderBubbles(numberOfBubbles: 15, viewHeight: currentViewHeight, viewWidth: currentViewWidth)
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
    
    func renderBubbles(numberOfBubbles: Int, viewHeight: Int, viewWidth: Int) {
        let randomBubbleNumbers = Int.random(in: 1...numberOfBubbles)
        print("Random number input: \(randomBubbleNumbers)")
        var numberOfBubblesGenerated = 0
        var loopCounter = 0
        while numberOfBubblesGenerated < randomBubbleNumbers {
            let xPosition = Int.random(in: 50...viewWidth - 60)
            let yPosition = Int.random(in: 160...viewHeight - 80)
            if !checkAllXYPosOverlap(newXPosition: xPosition, newYPosition: yPosition) {
                generateBubble(xPosition: xPosition, yPosition: yPosition)
                numberOfBubblesGenerated += 1
            }
            loopCounter += 1
        }
        print("Number of loops: \(loopCounter)")
        //print("Numbers of bubbles on screen: \(bubbleCounter)")
        
    }
    
    func generateBubble(xPosition: Int, yPosition: Int) {
      
        //if !checkAllXYPosOverlap(newXPosition: xPosition, newYPosition: yPosition) {
          
            let bubble = Bubble()
            bubble.changePosition(randomNumberToHeightBounds: yPosition, randomNumberToWidthBounds: xPosition)
            bubbleId += 1
           
            bubble.setBubbleId(bubbleId: bubbleId)
            bubble.addTarget(self, action: #selector(bubblePressed), for: .touchUpInside)
            //print("yPos: \(bubble.getStoredYPos()), xPos: \(bubble.getStoredXPos())")
                  
            self.view.addSubview(bubble)
            storedBubbles.append(bubble)
            bubbleCounter += 1
        //}
     
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
    
    func isOverlap(newXPosition: Int, newYPosition: Int) -> Bool
    {
        let xyPos: Bool = checkAllXYPosOverlap(newXPosition: newXPosition, newYPosition: newYPosition)
        //let yPos: Bool = checkOverlapYPositions(newYPosition: newYPosition)
        
        if xyPos == true {
            //print("overlapped")
            return true
        }
        else
        {
            //print("Not overlapped")
            return false
        }
    }
    
    func checkAllXYPosOverlap(newXPosition: Int, newYPosition: Int) -> Bool
    {
        for bubble in storedBubbles {
            //let currentBubbleId = bubble.getBubbleId()
            let currentXPos = bubble.getStoredXPos()
            let currentYPos = bubble.getStoredYPos()
            //print("xPos test: bubbleId: \(currentBubbleId) xPos: \(currentXPos), yPos: \(currentYPos)")
            if isXYPosOverlap(currentXPosition: currentXPos, newXPosition: newXPosition, currentYPosition: currentYPos, newYPosition: newYPosition)
            {
                //print("\(currentBubbleId) is overlapped")
                return true
            }
        }
        return false
    }
        
    func updateUI() {
        currentScoreLabel.text = String(Int(currentScore))
        highScoreLabel.text = String(playerHighScore)
    }
    
    @IBAction func bubblePressed(_ sender: Bubble) {
              
        handleScore(bubble: sender)
        handleRemove(bubble: sender)
        updateUI()
    }
    
    func handleScore(bubble: Bubble) {
        
        let currentPlayerScore = currentPlayer.getScore()
     
        print("pressed points \(previousBubblePoints)")
        if previousBubblePoints == bubble.getPoints()
        {
            currentScore *= 1.5
            //sameColourClicked += 1
            print("Same color clicked! \(currentScore)")
        }
        else{
            currentScore = Double(bubble.getPoints())
            previousBubblePoints = bubble.getPoints()
        }
       
        currentPlayerScore.computeHighScore(currentScore: Int(currentScore))
        playerHighScore = currentPlayerScore.getHighScore()
    }
    
    func handleRemove(bubble: Bubble)
    {
        //unmark the x and y positions
        let bubbleIndex = getBubbleIndexById(bubbleId: bubble.getBubbleId())
        
        //print(bubbleIndex)
        bubble.removeFromSuperview()
        storedBubbles.remove(at: bubbleIndex)
    }
    
    func removeAllBubbles() {
        //loop through the stored bubbles
        for bubble in storedBubbles {
            bubble.removeFromSuperview()
        }
        storedBubbles.removeAll()
    }
    
    func getBubbleIndexById(bubbleId: Int) -> Int {
        var bubbleIndex = 0
        var indexCounter = 0
        for bubble in storedBubbles {
            indexCounter += 1
            if bubble.getBubbleId() == bubbleId {
                //print("bubble \(bubble.getBubbleId()) is pressed.")
                bubbleIndex = indexCounter
            }
        }
        return bubbleIndex - 1
    }
    
    
}


