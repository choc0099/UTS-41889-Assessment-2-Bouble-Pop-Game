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
    var currentYPositionMarker = 0
    var currentXPositionMarker = 0
    
    var storedYPositions: [Int] = []
    var storedXPositions: [Int] = []
    
    
    var bubbleCounterSet = 0
    var bubbleCounter = 0
    

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
        //if !isOverlap(newXPosition: xPosition, newYPosition: yPosition) {
            self.view.addSubview(bubble)
        storedXPositions.append(xPosition)
        storedYPositions.append(yPosition)
        //}
     
        print(isOverlap(newXPosition: xPosition, newYPosition: yPosition)) //debug
        print("Current X Pos: \(currentXPositionMarker), current Y Pos: \(currentYPositionMarker)") //debug
    }
    
    //helper functions to check for overlap
    func isXPosOverlap(newXPosition: Int) -> Bool {
        let currentXPositionOverlapLeft = currentXPositionMarker - 55
        let currentXPositionOverlapRight = currentXPositionMarker + 55
        
        if currentXPositionOverlapLeft <= newXPosition {
            print("The bubble overlapped to the left.")
            return true
        }
        else if currentXPositionOverlapRight >= newXPosition
        {
            print("The bubble has been overlapped to the right.")
            return true
        }
        else
        {
            print("There is no overlaps.")
            return false
        }
    }
    
    func isYPosOverlap(newYPosition: Int) -> Bool
    {
        let currentYPositionOverlapTop = currentYPositionMarker - 45
        let currentYPositionOverlapBottom = currentYPositionMarker + 45
        
        if currentYPositionOverlapTop <= newYPosition {
            print("The bubble overlapped to the top.")
            return true
        }
        else if currentYPositionOverlapBottom >= newYPosition
        {
            print("The bubble has been overlapped to the bottom.")
            return true
        }
        else
        {
            print("There is no overlaps.")
            return false
        }
    }
    
    func isOverlap(newXPosition: Int, newYPosition: Int) -> Bool
    {
        let xPos: Bool = isXPosOverlap(newXPosition: newXPosition)
        let yPos: Bool = isYPosOverlap(newYPosition: newYPosition)
        
        if xPos == true || yPos == true {
            return true
        }
        else
        {
            return false
        }
    }
    
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
