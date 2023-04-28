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
    
    @IBOutlet weak var timerProgress: UIProgressView!
    
    
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
    var overlapCounter = 0
    var previousBubblePoints = 0
    var previousRemoveBubbleId = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // the game play stack is hidden when there is a countdown before the game starts.
        gamePlayStack.isHidden = true
        timerProgress.transform = timerProgress.transform.scaledBy(x: 1, y: 4)
        
        initiateGameData()
        startGame() // starts the game timers, intiates countdown and generates bubbles.
    }
    
    func initiateGameData() {
        let gameSettings = game.getGameSettings()
        gamePlayRemainingTime = gameSettings.getTimer()
        numberOfBubbles = gameSettings.getNumberOfBubbles()
      
        setTimerProgress()
    }
    
    func startGame() {
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
            //self.resetScore()
            self.renderBubbles(numberOfBubbles: self.numberOfBubbles)
            self.gamePlayCountDown()
           // print("Number of bubbles on screen: \(self.bubbleCounter)")
        }
    }
    
    func setTimerProgress() {
        let remainingTimeFloat: Float = Float(gamePlayRemainingTime)
        let gameSettings = game.getGameSettings()
        let gamePlayTimerSet: Float = Float(gameSettings.getTimer())
        let remainingTimePercantage: Float = remainingTimeFloat / gamePlayTimerSet
        timerProgress.setProgress(remainingTimePercantage, animated: true)
    }

    @objc func gamePlayCountDown() {
        gamePlayRemainingTime -= 1
        setTimerProgress()
      
        print("Number of stored bubbles \(game.getAllBubbles().count)")
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
        if game.getAllBubbles().count > 0 {
            removeSomeBubbles()
        }
        addSomeBubbles(numberOfBubbles: numberOfBubbles)
    }
        
    func removeSomeBubbles() {
        let randomBubblesToRemove = Int.random(in: 0...game.getAllBubbles().count)
       
        //let bubbleIndex = getBubbleIndexById(bubbleId: randomBubble)
        while game.getAllBubbles().count > randomBubblesToRemove {
            let storedBubbles = game.getAllBubbles()
            let randomBubble = storedBubbles.randomElement()
            if let unwrappedRandomBubble = randomBubble {
                handleRemove(isPressed: false, bubble: unwrappedRandomBubble)
            }
        }
        //print("Bubbles removed: \(randomToRemove) with \(bubbleCounter) left.")
       
    }
    
    func addSomeBubbles(numberOfBubbles: Int) {
        
        let randomBubblesToAdd = Int.random(in: 0...numberOfBubbles)
        
        overlapCounter = 0
        var numberOfBubblesGenerated = 0
        while game.getAllBubbles().count < randomBubblesToAdd && overlapCounter < 100 {
            generateBubble()
            numberOfBubblesGenerated += 1
        }
        
        //print("Bubbles added: \(randomBubblesToAdd)")
        //print("Total: \(bubbleCounter)")
    }
    
    func generateBubble() {
        //iniates the bubble manager class
        let bubbleManager = BubbleManager(game: game)
        //creates the bubble
        let bubble = Bubble()
        //retrieve the game settings to get device width and height.
        let gameSettings = game.getGameSettings()
        let screenWidth = gameSettings.getDeviceWidth()
        let screenHeight = gameSettings.getDeviceHeight()
        //passes the game session to the bubble class
        bubble.initiateGameSession(gameSession: game)
        //generates the random positions.
        let bubbleSize = gameSettings.getBubbleSize()
        var rightBounds = 60
        var bottomBounds = 100
        
        switch bubbleSize {
        case 55...64:
            rightBounds = 90
            bottomBounds = 140
        case 65...76:
            rightBounds = 110
            bottomBounds = 138
        case 77...100:
            rightBounds = 160
            bottomBounds = 190
        default:
            rightBounds = 60
            bottomBounds = 100
        }
        
  
   
        
        let xPosition = Int.random(in: 20...screenWidth - rightBounds)
        let yPosition = Int.random(in: 170...screenHeight - bottomBounds)
        //due to init does not work on the bubble class, I had to create a seperate function to set the position.
        bubble.setPositionAndSize(randomNumberToHeightBounds: yPosition, randomNumberToWidthBounds: xPosition, bubbleSize: bubbleSize)
        
        //this will add labels to the button if the user has enabled it or not.
        bubble.enableColorBlindnessLabels(isColorBlind: gameSettings.getIsColorBlind())
        let isAnimated = gameSettings.getIsAnimated()
        if isAnimated {
            //scale in bubble animation
            bubble.scaleIn()
        }
        
        bubble.addTarget(self, action: #selector(bubblePressed), for: .touchUpInside)
        //print("yPos: \(bubble.getStoredYPos()), xPos: \(bubble.getStoredXPos())")
        if !bubbleManager.isOverlap(newBubble: bubble) {
            overlapCounter = 0
            bubbleId += 1 // this is for the unique bubble identifier.
            //sets the bubble id in the bubble class.
            bubble.setBubbleId(bubbleId: bubbleId)
            //adds the vubble onto the gameplay view
            self.view.addSubview(bubble)
            //bubble.moveBubblePos()
            game.storeBubble(bubble: bubble)
            bubbleCounter += 1
        }
        else
        {
            overlapCounter += 1
            print("Number of overlaps: \(overlapCounter)")
        }
    }
      
    func updateUI() {
        currentScoreLabel.text = String(Int(currentScore))
        highScoreLabel.text = String(playerHighScore)
        self.currentScoreAnimation()
        self.highScoreAnnimation()
    }
    
    @IBAction func bubblePressed(_ sender: Bubble) {
        print("pressed")
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
        else {
            currentScore = Double(bubble.getPoints())
            previousBubblePoints = bubble.getPoints()
        }
       
        currentPlayerScore.computeHighScore(currentScore: Int(currentScore))
        playerHighScore = currentPlayerScore.getHighScore()
    }
    
    func handleRemove(isPressed: Bool, bubble: Bubble) {
        bubbleCounter -= 1
        game.removeBubble(bubbleId: bubble.getBubbleId())
        let gameSettings = game.getGameSettings()
        let timerSet = gameSettings.getTimer()
        let remainingTimeDouble: Double = Double(gamePlayRemainingTime)
        let timerSetDouble: Double =  Double(timerSet)
        let gamePlayRemainingTimePercent: Double = ((remainingTimeDouble / timerSetDouble) * 100)
        let isAnimated = gameSettings.getIsAnimated()
        
        if isAnimated {
            if isPressed {
                bubble.scaleOutAndRemove()
                game.removeBubble(bubbleId: bubble.getBubbleId())
                //game.removeBubble(bubbleId: bubble.getBubbleId())
                //bubble.removeFromSuperview()
            }
            else {
                bubble.moveAwayAnimation(remainingTimePercent: Int(gamePlayRemainingTimePercent))
            }
        }
        else {
            game.removeBubble(bubbleId: bubble.getBubbleId())
            //bubble.removeFromSuperview()
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
