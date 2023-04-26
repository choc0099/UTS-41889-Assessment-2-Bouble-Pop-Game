//
//  GamePlayViewController.swift
//  Bobble Pop
//
//  Created by Christopher Averkos on 4/4/2023.
//

import Foundation
import UIKit

class GamePlayViewController: UIViewController {
    
    var game = Game()
    var currentPlayer = Player()
    
    @IBOutlet weak var remainingTimeLabel: UILabel!
    @IBOutlet weak var highScoreLabel: UILabel!
    @IBOutlet weak var currentScoreLabel: UILabel!
    @IBOutlet weak var gamePlayStack: UIStackView!
    
    var gameStartCountDownLabel = CountDownLabel()
    
    var bubbleId = 0

    var currentScore: Double = 0
    var playerHighScore = 0
    
    //timers
    var gamePlayTimer = Timer()
    var gameStartTimer = Timer()
    
    var gameStartRemainingTime = 3
    var gamePlayRemainingTime = 0
    var numberOfBubbles = 0
    var bubbleCounter = 0
    
    var previousBubblePoints = 0
    var previousRemoveBubbleId = 0
    
    override func viewDidLoad() {
        
        // the game play stack is hidden when there is a countdown before the game starts.
        gamePlayStack.isHidden = true
       
        super.viewDidLoad()
        let gameSettings = game.getGameSettings()
        gamePlayRemainingTime = gameSettings.getTimer()
        numberOfBubbles = gameSettings.getNumberOfBubbles()
        remainingTimeLabel.text = String(gamePlayRemainingTime)
        //print("Numbers of bubbles set:  \(numberOfBubbles)")
        
        //gets the view heights and widths when adding bubbles so it can work accross different screen sizes.
        let currentViewWidth: Int = Int(self.view.bounds.width)
        let currentViewHeight: Int = Int(self.view.bounds.height)
        
        gameSettings.setDeviceWdihAndHeight(deviceWidth: currentViewWidth, deviceHeight: currentViewHeight)
        //needed to display the first sequence of the countdown before the timer initiates.
        self.generateCountDownLabel()
        gameStartTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {
            gameStarttimer in
            self.gameStartCountDown()
        }
    }
    
    func initiateGamePlay() {
        self.renderBubbles(numberOfBubbles: numberOfBubbles)
        gamePlayTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {
            gamePlayerTimer in
            //self.bubbleCounter = 0
            //self.resetScore()
            self.renderBubbles(numberOfBubbles: self.numberOfBubbles)
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
        }
    }
    // A helper function used to generate the game countdown label attributes.
    func generateCountDownLabel() {
        
        gameStartCountDownLabel.setNumber(number: gameStartRemainingTime)
        gameStartCountDownLabel.center = self.view.center
        self.view.addSubview(gameStartCountDownLabel)
        gameStartCountDownLabel.flash()
    }
    
    @objc func gameStartCountDown() {
        print(gameStartRemainingTime)
        gameStartRemainingTime -= 1
        gameStartCountDownLabel.setNumber(number: gameStartRemainingTime)
        gameStartCountDownLabel.flash()
        
        if gameStartRemainingTime == 0 {
            gameStartTimer.invalidate()
            gameStartCountDownLabel.removeFromSuperview()
            gamePlayStack.isHidden = false
            self.initiateGamePlay()
        }
    }
    
    func renderBubbles(numberOfBubbles: Int) {
        if bubbleCounter > 0 {
            removeSomeBubbles()
        }
        addSomeBubbles(numberOfBubbles: numberOfBubbles)
    }
        
    func removeSomeBubbles() {
        
        let randomBubblesToRemove = Int.random(in: 0...bubbleCounter)
       
        //let bubbleIndex = getBubbleIndexById(bubbleId: randomBubble)
        for _ in 0...randomBubblesToRemove {
            let storedBubbles = game.getAllBubbles()
            let randomBubble = storedBubbles.randomElement()
            if let unwrappedRandomBubble = randomBubble {
                //This will help prevent the bubble that is already clicked removed.
                /*if unwrappedRandomBubble.getBubbleId() == previousRemoveBubbleId {
                    continue
                }*/
                handleRemove(isPressed: false, bubble: unwrappedRandomBubble)
            }
        }
        //print("Bubbles removed: \(randomToRemove) with \(bubbleCounter) left.")
       
    }
    
    func addSomeBubbles(numberOfBubbles: Int) {
        
        
        let randomBubblesToAdd = Int.random(in: 0...numberOfBubbles - bubbleCounter)
        
        //print(numberOfBubbles)
        var numbersOfOverlaps = 0 //counts the number of times the bubbles overlaps during a loop
        var numberOfBubblesGenerated = 0
        while self.bubbleCounter < randomBubblesToAdd && numbersOfOverlaps < 100 {
            //print(numbersOfOverlaps)
            //sets the x and y positions of the bubble.
            
            //bubbles will be generated and added on screen if there are no overlaps.
            //if !bubbleManager.isOverlap(newBubble: <#T##Bubble#>){
                generateBubble()
                numberOfBubblesGenerated += 1
                //numbersOfOverlaps = 0
            //}
            numbersOfOverlaps += 1
        }
        
        //print("Bubbles added: \(randomBubblesToAdd)")
        //print("Total: \(bubbleCounter)")
    }
    
    func generateBubble() {
        let bubbleManager = BubbleManager(game: game)
        
        let bubble = Bubble()
        let gameSettings = game.getGameSettings()
        
        let screenWidth = gameSettings.getDeviceWidth()
        let screenHeight = gameSettings.getDeviceHeight()
        bubble.initiateGameSession(gameSession: game)
        let xPosition = Int.random(in: 20...screenWidth - 60)
        let yPosition = Int.random(in: 170...screenHeight - 100)
        bubble.setPosition(randomNumberToHeightBounds: yPosition, randomNumberToWidthBounds: xPosition)
        bubbleId += 1
           
        bubble.setBubbleId(bubbleId: bubbleId)
        //this will add labels to the button if the user has enabled it or not.
        bubble.enableColorBlindnessLabels(isColorBlind: gameSettings.getIsColorBlind())
      
        bubble.scaleIn()
        //bubble.moveBubblePos()
        bubble.addTarget(self, action: #selector(bubblePressed), for: .touchUpInside)
        //print("yPos: \(bubble.getStoredYPos()), xPos: \(bubble.getStoredXPos())")
        if !bubbleManager.isOverlap(newBubble: bubble) {
            self.view.addSubview(bubble)
            //bubble.moveBubblePos()
            game.storeBubble(bubble: bubble)
            bubbleCounter += 1
        }
        
     
        //print("Current X Pos: \(currentXPositionMarker), current Y Pos: \(currentYPositionMarker)") //debug
    }
      
    func updateUI() {
        currentScoreLabel.text = String(Int(currentScore))
        highScoreLabel.text = String(playerHighScore)
        self.currentScoreAnimation()
        self.highScoreAnnimation()
    }
    
    @IBAction func bubblePressed(_ sender: Bubble) {
        handleScore(bubble: sender)
        updateUI()
        handleRemove(isPressed: true, bubble: sender)
        previousRemoveBubbleId = sender.getBubbleId()
        print("Number of elements: \(game.getAllBubbles().count)")
    }
    
    
    
    func handleScore(bubble: Bubble) {
        // current score at the time of the bubble been tapped.
        let currentPlayerScore = currentPlayer.getScore()
     
        //print("pressed points \(bubble.getPoints())")
        // if the same bubble colour is pressed after another, the score will increase by 1.5
        if previousBubblePoints == bubble.getPoints() {
            currentScore += 1.5 * currentScore
            print("Same color clicked! \(currentScore)")
        }
        else{
            currentScore = Double(bubble.getPoints())
            previousBubblePoints = bubble.getPoints()
        }
       
        currentPlayerScore.computeHighScore(currentScore: Int(currentScore))
        playerHighScore = currentPlayerScore.getHighScore()
    }
    
    func handleRemove(isPressed: Bool, bubble: Bubble) {
        bubbleCounter -= 1
       
        //game.removeBubble(bubbleId: bubble.getBubbleId())
        
        if isPressed {
            bubble.flyOutAndRemove()
        }
        else {
            //bubble.scaleOutAndRemove()
            game.removeBubble(bubbleId: bubble.getBubbleId())
            bubble.removeFromSuperview()            
        }
    
        
        //unmark the x and y positions
        //let bubbleIndex = getBubbleIndexById(bubbleId: bubble.getBubbleId())
      
        //print(bubbleIndex)
        
        //bubble.removeFromSuperview()
    }
    
    func currentScoreAnimation() {
        let bloopingAnimation = CASpringAnimation(keyPath: "transform.scale")
        
        bloopingAnimation.fromValue = 1
        bloopingAnimation.toValue = 2
        bloopingAnimation.speed = 1
        bloopingAnimation.autoreverses = true
        currentScoreLabel.layer.add(bloopingAnimation, forKey: nil)
        
    }
    
    func highScoreAnnimation() {
        let flash = CABasicAnimation(keyPath: "opacity")
        flash.fromValue = 1
        flash.toValue = 0
        flash.autoreverses = true
        flash.speed = 0.8
        
        highScoreLabel.layer.add(flash, forKey: nil)
    }
    
    func resetScore() {
        currentScore = 0
        previousBubblePoints = 0
        //set timer for current score to be displayed in the UI.
        //updateUI()
    }
}
