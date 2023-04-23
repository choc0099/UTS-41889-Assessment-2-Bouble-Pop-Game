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
    @IBOutlet weak var gamePlayStack: UIStackView!
    
    var gameStartCountDownLabel = CountDownLabel()
    
    var bubbleId = 0

    var currentScore: Double = 0
    var playerHighScore = 0
    var gamePlayTimer = Timer()
    var gameStartTimer = Timer()
    var game = Game()
    var currentPlayer = Player()
    
    //stores all the bubble attributes into an array to mark xPositions and yPositions when the bubble is added onto the screen.
    //var storedBubbles: [Bubble] = []
    
    var gameStartRemainingTime = 3
    var gamePlayRemainingTime = 0
    var numberOfBubbles = 0
    var bubbleCounter = 0
    
    var previousBubblePoints = 0
    
    //var score: Score = Score()
    
    override func viewDidLoad() {
        
        // the game play stack is hidden when there is a countdown before the game starts.
        gamePlayStack.isHidden = true
        
        super.viewDidLoad()
        let gameSettings = game.getGameSettings()
        gamePlayRemainingTime = gameSettings.getTimer()
        numberOfBubbles = gameSettings.getNumberOfBubbles()
        
        //print("Numbers of bubbles set:  \(numberOfBubbles)")
        
        let currentViewWidth: Int = Int(self.view.bounds.width)
        let currentViewHeight: Int = Int(self.view.bounds.height)
               
        self.generateCountDownLabel()
        gameStartTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {
            gameStarttimer in
            self.gameStartCountDown(screenWidth: currentViewWidth, screenHeight: currentViewHeight)
        }
    }
    
    func initiateGamePlay(screenViewHeight currentViewHeight: Int, screenViewWidth currentViewWidth: Int) {
        self.renderBubbles(numberOfBubbles: numberOfBubbles, viewHeight: currentViewHeight, viewWidth: currentViewWidth)
        gamePlayTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {
            gamePlayerTimer in
            //self.bubbleCounter = 0
            //self.resetScore()
            self.renderBubbles(numberOfBubbles: self.numberOfBubbles, viewHeight: currentViewHeight, viewWidth: currentViewWidth)
            self.gamePlayCountDown()
            print("Number of bubbles on screen: \(self.bubbleCounter)")
        }
    }

    @objc func gamePlayCountDown() {
        gamePlayRemainingTime -= 1
        remainingTimeLabel.text = String(gamePlayRemainingTime)
        
        if gamePlayRemainingTime == 0 {
            gamePlayTimer.invalidate()
            // writes the game score to the userDefaults database
            HighScoreManager.writeHighScore(gameSession: self.game)
            self.game.removeAllBubbles()
            //this is used to go to the high score view
            let VC = storyboard?.instantiateViewController(identifier: "HighScoreViewController") as! HighScoreViewController
            self.navigationController?.pushViewController(VC, animated: true)
            VC.navigationItem.setHidesBackButton(true, animated: true)
            //Pass the game object with data stored.
            //VC.game = game
        }
    }
    
    func generateCountDownLabel() {
        remainingTimeLabel.text = String(gamePlayRemainingTime)
        gameStartCountDownLabel.setNumber(number: gameStartRemainingTime)
        gameStartCountDownLabel.center = self.view.center
        self.view.addSubview(gameStartCountDownLabel)
        gameStartCountDownLabel.flash()
    }
    
    @objc func gameStartCountDown(screenWidth: Int, screenHeight: Int) {
        print(gameStartRemainingTime)
        gameStartRemainingTime -= 1
        gameStartCountDownLabel.setNumber(number: gameStartRemainingTime)
        gameStartCountDownLabel.flash()
        
        if gameStartRemainingTime == 0 {
            gameStartTimer.invalidate()
            gameStartCountDownLabel.removeFromSuperview()
            gamePlayStack.isHidden = false
            self.initiateGamePlay(screenViewHeight: screenHeight, screenViewWidth: screenWidth)
        }
    }
    
    func renderBubbles(numberOfBubbles: Int, viewHeight: Int, viewWidth: Int) {
        if bubbleCounter > 0 {
            removeSomeBubbles()
        }
        addSomeBubbles(numberOfBubbles: numberOfBubbles, viewWidth: viewWidth, viewHeight: viewHeight)
    }
        
    func removeSomeBubbles() {
        
        let randomBubblesToRemove = Int.random(in: 0...bubbleCounter)
       
        //let bubbleIndex = getBubbleIndexById(bubbleId: randomBubble)
        for _ in 0...randomBubblesToRemove {
            let storedBubbles = game.getAllBubbles()
            let randomBubble = storedBubbles.randomElement()
            if let unwrappedRandomBubble = randomBubble {
                handleRemove(bubble: unwrappedRandomBubble)
            }
        }
        //print("Bubbles removed: \(randomToRemove) with \(bubbleCounter) left.")
       
    }
    
    func addSomeBubbles(numberOfBubbles: Int, viewWidth: Int, viewHeight: Int)
    {
        let randomBubblesToAdd = Int.random(in: 0...numberOfBubbles - bubbleCounter)
        
        //print(numberOfBubbles)
        var numbersOfOverlaps = 0 //counts the number of times the bubbles overlaps during a loop
        var numberOfBubblesGenerated = 0
        while numberOfBubblesGenerated < randomBubblesToAdd && numbersOfOverlaps < 100 {
            //print(numbersOfOverlaps)
            //sets the x and y positions of the bubble.
            let xPosition = Int.random(in: 20...viewWidth - 60)
            let yPosition = Int.random(in: 170...viewHeight - 100)
            //bubbles will be generated and added on screen if there are no overlaps.
            if !BubbleManager.isOverlap(storedBubbles: game.getAllBubbles(), newXPosition: xPosition, newYPosition: yPosition) {
                generateBubble(xPosition: xPosition, yPosition: yPosition)
                numberOfBubblesGenerated += 1
                numbersOfOverlaps = 0
            }
            numbersOfOverlaps += 1
        }
        
        //print("Bubbles added: \(randomBubblesToAdd)")
        //print("Total: \(bubbleCounter)")
    }
    
    func generateBubble(xPosition: Int, yPosition: Int) {
        let bubble = Bubble()
        let gameSettings = game.getGameSettings()
        bubble.setPosition(randomNumberToHeightBounds: yPosition, randomNumberToWidthBounds: xPosition)
        bubbleId += 1
           
        bubble.setBubbleId(bubbleId: bubbleId)
        //this will add labels to the button if the user has enabled it or not.
        bubble.enableColorBlindnessLabels(isColorBlind: gameSettings.getIsColorBlind())
        //bubble.moveBubblePos()
        bubble.scaleIn()
        bubble.addTarget(self, action: #selector(bubblePressed), for: .touchUpInside)
        //print("yPos: \(bubble.getStoredYPos()), xPos: \(bubble.getStoredXPos())")
                  
        self.view.addSubview(bubble)
   
        //bubble.moveBubblePos()
        game.storeBubble(bubble: bubble)
        bubbleCounter += 1
     
        //print("Current X Pos: \(currentXPositionMarker), current Y Pos: \(currentYPositionMarker)") //debug
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
        // current score at the time of the bubble been tapped.
        let currentPlayerScore = currentPlayer.getScore()
     
        //print("pressed points \(bubble.getPoints())")
        // if the same bubble colour is pressed after another, the score will increase by 1.5
        if previousBubblePoints == bubble.getPoints() {
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
    
    func handleRemove(bubble: Bubble) {
        bubbleCounter -= 1
        bubble.scaleOut()
        //unmark the x and y positions
        //let bubbleIndex = getBubbleIndexById(bubbleId: bubble.getBubbleId())
        game.removeBubble(bubbleId: bubble.getBubbleId())
        //print(bubbleIndex)
       
        bubble.removeFromSuperview()
      
      
    }
    
    func resetScore() {
        currentScore = 0
        previousBubblePoints = 0
        //set timer for current score to be displayed in the UI.
        //updateUI()
    }
}
