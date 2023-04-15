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
    
    
    var numberOfBubbles = 0
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
            //self.bubbleCounter = 0
            self.countingDown()
            self.renderBubbles(numberOfBubbles: self.numberOfBubbles, viewHeight: currentViewHeight, viewWidth: currentViewWidth)
            self.resetScore()
            //print("Number of bubbles on screen: \(self.bubbleCounter)")
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
        
        if bubbleCounter > 0 {
            removeSomeBubbles()
        }
        addSomeBubbles(numberOfBubbles: numberOfBubbles, viewWidth: viewWidth, viewHeight: viewHeight)
        
    }
    
    func removeSomeBubbles() {
        
        let randomToRemove = Int.random(in: 0...bubbleCounter)
       
        //let bubbleIndex = getBubbleIndexById(bubbleId: randomBubble)
        for _ in 0...randomToRemove {
            let randomBubble = storedBubbles.randomElement()
            if let unwrappedRandomBubble = randomBubble {
        
                handleRemove(bubble: unwrappedRandomBubble)
            }
        }
        //print("Bubbles removed: \(randomToRemove) with \(bubbleCounter) left.")
       
    }
    
    
    func addSomeBubbles(numberOfBubbles: Int, viewWidth: Int, viewHeight: Int)
    {
        let randomBubblesToAdd = Int.random(in: 1...numberOfBubbles - bubbleCounter)
        
        //print(numberOfBubbles)
        
        var numberOfBubblesGenerated = 0
        while numberOfBubblesGenerated < randomBubblesToAdd {
            let xPosition = Int.random(in: 50...viewWidth - 80)
            let yPosition = Int.random(in: 160...viewHeight - 100)
            if !checkAllXYPosOverlap(newXPosition: xPosition, newYPosition: yPosition) {
                generateBubble(xPosition: xPosition, yPosition: yPosition)
                numberOfBubblesGenerated += 1
            }
        }
        print("Bubbles added: \(randomBubblesToAdd)")
        print("Total: \(bubbleCounter)")
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
        updateUI()
        handleRemove(bubble: sender)
      
    }
    
    func handleScore(bubble: Bubble) {
        
        let currentPlayerScore = currentPlayer.getScore()
     
        //print("pressed points \(bubble.getPoints())")
        if previousBubblePoints == bubble.getPoints()
        {
            currentScore += 1.5 * currentScore
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
        storedBubbles.remove(at: bubbleIndex)
        //print(bubbleIndex)
        bubble.removeFromSuperview()
      
        bubbleCounter -= 1
    }
    
    func resetScore() {
        currentScore = 0
        previousBubblePoints = 0
        //set timer for current score to be displayed in the UI.
        
        //updateUI()
    }
    
    func removeAllBubbles() {
        //loop through the stored bubbles
        for bubble in storedBubbles {
            bubble.removeFromSuperview()
        }
        storedBubbles.removeAll()
        bubbleCounter = 0
    }
    
    func getBubbleIndexById(bubbleId: Int) -> Int {
        var bubbleIndex = 0
        var indexCounter = 0
        for bubble in storedBubbles {
            if bubble.getBubbleId() == bubbleId {
                //print("bubble \(bubble.getBubbleId()) is pressed.")
                bubbleIndex = indexCounter
            }
            indexCounter += 1
        }
        //print("\(bubbleId) is pressed at index \(bubbleIndex)")
        return bubbleIndex
    }
    
    
}


