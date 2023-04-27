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
    
    @IBOutlet weak var bubbleSizeLabel: UILabel!
    @IBOutlet weak var bubbleSizeSlider: UISlider!
    @IBOutlet weak var isColorBlindSwitch: UISwitch!
    var game = Game()
   
    @IBOutlet weak var clearScoresButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        retrieveSettings()
        
        clearScoresButton.setTitle("Clear score", for: .normal)
        //clearScoresButton.high
        
    }
    
    func retrieveSettings() {
        let gameSettings = game.getGameSettings()
        timerSlider.value = Float(gameSettings.getTimer())
        bubblesSlider.value = Float(gameSettings.getNumberOfBubbles())
        isColorBlindSwitch.isOn = gameSettings.getIsColorBlind()
        bubbleSizeSlider.value = Float(gameSettings.getBubbleSize())
        updateUILabels()
    }
    
    func changeSettings() {
        let gameSettings = game.getGameSettings()
        gameSettings.setTimer(howLong: Int(timerSlider.value))
        gameSettings.setNumberOfBubbles(howMany: Int(bubblesSlider.value))
        let isColorBlind = isColorBlindSwitch.isOn
        gameSettings.setColorBlind(isColorBlind: isColorBlind)
        gameSettings.setBubbbleSize(bubbleSize: Int(bubbleSizeSlider.value))
    }
    
    @IBAction func onBubbleSliderChange(_ sender: Any) {
        changeSettings()
        updateUILabels()
    }
    
    @IBAction func onTimerChanged(_ sender: UISlider) {
        changeSettings()
        updateUILabels()
    }
    
    @IBAction func onBubblesChanged(_ sender: Any) {
        changeSettings()
        updateUILabels()
    }
    
    @IBAction func onClearScoresPressed(_ sender: UIButton) {
        HighScoreManager.clearScores()
        game.clearAllPlayers()
        clearScoresButton.setTitle("Score cleard.", for: .normal)
    }
    
    
    
    func updateUILabels() {
        //display the bubbles and timer value that has been set.
        let timerSet: Int = Int(timerSlider.value)
        let bubbleSet: Int = Int(bubblesSlider.value)
        let bubbleSizeSet: Int = Int(bubbleSizeSlider.value)
        timerLabel.text = String(timerSet)
        numberOfBubblesLabel.text = String(bubbleSet)
        bubbleSizeLabel.text = String(bubbleSizeSet)
    }
    
    @IBAction func onIsColorBlindSwitchToggle(_ sender: UISwitch) {
        
    }
    
}
