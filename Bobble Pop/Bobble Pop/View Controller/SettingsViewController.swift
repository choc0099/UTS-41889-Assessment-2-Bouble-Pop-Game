//
//  SettingsViewController.swift
//  Bobble Pop
//
//  Created by Christopher Averkos on 15/4/2023.
//

import Foundation
import UIKit

class SettingsViewController: UIViewController {

    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var numberOfBubblesLabel: UILabel!
    @IBOutlet weak var timerSlider: UISlider!
    @IBOutlet weak var bubblesSlider: UISlider!
    
    var game = Game()
   
    @IBOutlet weak var clearScoresButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        clearScoresButton.setTitle("Clear score", for: .normal)
        //clearScoresButton.high
        updateUI()
    }
    
    
    @IBAction func onTimerChanged(_ sender: UISlider) {
        let gameSettings = game.getGameSettings()
        gameSettings.setTimer(howLong: Int(timerSlider.value))
        updateUI()
    }
    
   
    
    @IBAction func onBubblesChanged(_ sender: Any) {
        let gameSettings = game.getGameSettings()
        gameSettings.setNumberOfBubbles(howMany: Int(bubblesSlider.value))
        updateUI()
    }
    
    @IBAction func onClearScoresPressed(_ sender: UIButton) {
        HighScoreManager.clearScores()
        game.clearAllPlayers()
        clearScoresButton.setTitle("Score cleard.", for: .normal)
    }
    
    func updateUI() {
        //display the bubbles and timer value that has been set.
        let timerSet: Int = Int(timerSlider.value)
        let bubbleSet: Int = Int(bubblesSlider.value)
        timerLabel.text = String(timerSet)
        numberOfBubblesLabel.text = String(bubbleSet)
    }
}
