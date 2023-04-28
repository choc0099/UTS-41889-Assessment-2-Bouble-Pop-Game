//
//  GamePlayViewController.swift
//  Bobble Pop
//
//  Created by Christopher Averkos on 4/4/2023.
//

import Foundation
import UIKit

class GamePlayViewController: UIViewController {
    //variables to pass the game and player sessions.
    var game = Game()
    var currentPlayer = Player()
    
    //IBOutlets for the UI elements
    @IBOutlet weak var highScoreLabel: UILabel!
    @IBOutlet weak var currentScoreLabel: UILabel!
    @IBOutlet weak var gamePlayStack: UIStackView!
    @IBOutlet weak var timerProgress: UIProgressView!
    
    //Progamaticaly creates a countdown label
    var gameStartCountDownLabel = CountDownLabel()
    
    var bubbleId = 0 //unique bubble identifier
    // stores the player scores into a variable
    var currentScore: Double = 0
    var playerHighScore = 0
    
    //timers
    var gamePlayTimer = Timer()
    var gameStartTimer = Timer()
    //game configuration
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
        //loads configured game settings.
        initiateGameData()
        startGame() // starts the game timers, intiates countdown and generates bubbles.
    }
    
    func initiateGameData() {
        let gameSettings = game.getGameSettings()
        gamePlayRemainingTime = gameSettings.getTimer()
        numberOfBubbles = gameSettings.getNumberOfBubbles()
        // sets the inital timer progress to the maximum value before the timer kicks in.
        updateTimerProgress()
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
            self.renderBubbles(numberOfBubbles: self.numberOfBubbles)
            self.gamePlayCountDown()
        }
    }
    //A helper function that updates the timerProgress based on current remaining time.
    func updateTimerProgress() {
        let remainingTimeFloat: Float = Float(gamePlayRemainingTime)
        let gameSettings = game.getGameSettings()
        let gamePlayTimerSet: Float = Float(gameSettings.getTimer())
        let remainingTimePercantage: Float = remainingTimeFloat / gamePlayTimerSet
        timerProgress.setProgress(remainingTimePercantage, animated: true)
    }
    //This is used for the gamePlay timer to work.
    @objc func gamePlayCountDown() {
        gamePlayRemainingTime -= 1
        updateTimerProgress() //updates the timer progress view.
        if gamePlayRemainingTime == 0 {
            gamePlayTimer.invalidate()
            // writes the game score to the userDefaults database
            HighScoreManager.writeHighScore(gameSession: self.game)
            self.game.removeAllBubbles() //clears all the bubbles stored in the array so it is ready for another game session.
            self.generateGameOverAlert()
        }
    }
    
    func generateGameOverAlert() {
        let gameOverAlert = UIAlertController(title: "Game Over!", message: nil, preferredStyle: .alert)
        //add an alert action
        let okButton = UIAlertAction(title: "OK", style: .default, handler: {
            (action) -> Void in
            self.goToHighScoreView()
        })
        gameOverAlert.addAction(okButton)
        self.present(gameOverAlert, animated: true)
    }
    
    //helper function to go to the HighScore view
    func goToHighScoreView() {
        //this is used to go to the high score view
        let VC = storyboard?.instantiateViewController(identifier: "HighScoreViewController") as! HighScoreViewController
        self.navigationController?.pushViewController(VC, animated: true)
        VC.navigationItem.setHidesBackButton(true, animated: true)
    }
    
    // A helper function used to generate the game countdown label attributes.
    func generateCountDownLabel() {
        gameStartCountDownLabel.setNumber(number: gameStartRemainingTime)
        gameStartCountDownLabel.center = self.view.center
        self.view.addSubview(gameStartCountDownLabel)
        gameStartCountDownLabel.flash()
    }
    
    //Initiates the 3 2 1 gameStart countdown and updates the countDownLabel.
    @objc func gameStartCountDown() {
        gameStartRemainingTime -= 1
        gameStartCountDownLabel.setNumber(number: gameStartRemainingTime)
        gameStartCountDownLabel.flash()
        //The gamePlay will begin once this timer ends.
        if gameStartRemainingTime == 0 {
            gameStartTimer.invalidate()
            gameStartCountDownLabel.removeFromSuperview()
            gamePlayStack.isHidden = false
            self.initiateGamePlay()
        }
    }
    
    func renderBubbles(numberOfBubbles: Int) {
        if game.getAllBubbles().count > 0 { //this will only call the removeSomeBubbles function if there is elements on the bubble array.
            removeSomeBubbles()
        }
        addSomeBubbles(numberOfBubbles: numberOfBubbles)
    }
    
    // A helper function that randomly decides how many bubbles to remove.
    func removeSomeBubbles() {
        let randomBubblesToRemove = Int.random(in: 0...game.getAllBubbles().count)
        while game.getAllBubbles().count > randomBubblesToRemove {
            let storedBubbles = game.getAllBubbles()
            let randomBubble = storedBubbles.randomElement()
            if let unwrappedRandomBubble = randomBubble {
                handleRemove(isPressed: false, bubble: unwrappedRandomBubble)
            }
        }
    }
    
    func addSomeBubbles(numberOfBubbles: Int) {
        let randomBubblesToAdd = Int.random(in: 0...numberOfBubbles)
        overlapCounter = 0 //resets the overlap counter when a new set of bubbles needs to be added each second.
        var numberOfBubblesGenerated = 0
        while game.getAllBubbles().count < randomBubblesToAdd && overlapCounter < 100 {
            generateBubble()
            numberOfBubblesGenerated += 1
        }
    }
    
    //generates a bubble
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
        //determines right and bottom screen bounds based on bubble sizes.
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
        
        //generates a random position.
        let xPosition = Int.random(in: 20...screenWidth - rightBounds)
        let yPosition = Int.random(in: 170...screenHeight - bottomBounds)
        //due to init does not work on the bubble class, I had to create a seperate function to set the position and bubble size.
        bubble.setPositionAndSize(randomNumberToHeightBounds: yPosition, randomNumberToWidthBounds: xPosition, bubbleSize: bubbleSize)
        
        //this will add labels to the button if the user has enabled it.
        let isColorBlind = gameSettings.getIsColorBlind()
        bubble.enableColorBlindnessLabels(isColorBlind: isColorBlind)
        //determines if the animation settings are turned on.
        let isAnimated = gameSettings.getIsAnimated()
        if isAnimated {
            //scale in bubble animation
            bubble.scaleIn()
        }
        // programatically adds a button press listener.
        bubble.addTarget(self, action: #selector(bubblePressed), for: .touchUpInside)
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
        else {
            overlapCounter += 1 //the overlap counter prevents infinite loops.
        }
    }
    //updates the current score and high score.
    func updateUI() {
        currentScoreLabel.text = String(Int(currentScore))
        highScoreLabel.text = String(playerHighScore)
        self.currentScoreAnimation()
        self.highScoreAnnimation()
    }
    
    @IBAction func bubblePressed(_ sender: Bubble) {
        handleScore(bubble: sender) // assigns the scores from the bubble and computes a highScore
        updateUI() //updates the scores diplayed via the stackview.
        handleRemove(isPressed: true, bubble: sender)
        previousRemoveBubbleId = sender.getBubbleId()
        print("Number of elements: \(game.getAllBubbles().count)")
    }
    
    func handleScore(bubble: Bubble) {
        // current score at the time of the bubble been tapped.
        let currentPlayerScore = currentPlayer.getScore()
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
            }
            else {
                bubble.moveAwayAnimation(remainingTimePercent: Int(gamePlayRemainingTimePercent))
            }
        }
        else {
            bubble.removeFromSuperview()
        }
    }
    
    //creates the animation for the scores during gampley.
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
}
