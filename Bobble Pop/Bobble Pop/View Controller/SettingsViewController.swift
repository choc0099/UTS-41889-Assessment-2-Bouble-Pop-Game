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
    
    @IBOutlet weak var isAnimatedSwitch: UISwitch!
    
    
    var game = Game()
   
    @IBOutlet weak var clearScoresButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //updates the settings values including the sliders and switches.
        optimizeScreenSize()
        retrieveSettings()
        
        clearScoresButton.setTitle("Clear score", for: .normal)
        //clearScoresButton.high
        
    }
    
    //the maximun bubble size are reduced on devices with smaller screen sizes.
    func optimizeScreenSize()
    {
        let gameSettings = game.getGameSettings()
        let screenWidth = gameSettings.getDeviceWidth()
        let screenHeight = gameSettings.getDeviceHeight()
        
        if screenWidth < 370 || screenHeight < 630 {
            bubbleSizeSlider.maximumValue = 65
        }
        else if screenWidth > 570 || screenHeight > 1150 { //allows even larger bubbles on an iPad.
            bubbleSizeSlider.maximumValue = 100
        }
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
        gameSettings.setIsAnimated(isAnimated: isAnimatedSwitch.isOn)
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
        let confirmClear = UIAlertController(title: "Clear High Scores", message: "Are you sure you want to clear all high scores", preferredStyle: .alert)
        let yesButton = UIAlertAction(title: "Yes", style: .default, handler: { (action) -> Void in
            self.handleClearScores()
        })
        
        let noButton = UIAlertAction(title: "No", style: .cancel, handler: { (action) -> Void in
            return
        })
        
           
        confirmClear.addAction(yesButton)
        confirmClear.addAction(noButton)
        self.present(confirmClear, animated: true)
        
    }
    
    func handleClearScores() {
        HighScoreManager.clearScores()
        game.clearAllPlayers()
        clearScoresButton.setTitle("Score cleard.", for: .normal)
    }
    
    
    
    func updateUILabels() {
        //display the bubbles and timer value that has been set.
        let timerSet: Int = Int(timerSlider.value)
        let bubbleSet: Int = Int(bubblesSlider.value)
        let bubbleSizeSet = bubbleSizeSlider.value - bubbleSizeSlider.minimumValue
        let maxBubbleSize = bubbleSizeSlider.maximumValue - bubbleSizeSlider.minimumValue
        let bubbleSizePercantge = ((bubbleSizeSet / maxBubbleSize) * 100)
        timerLabel.text = String(timerSet)
        numberOfBubblesLabel.text = String(bubbleSet)
        bubbleSizeLabel.text = "\(Int(bubbleSizePercantge))%"
    }
    
    @IBAction func onIsColorBlindSwitchToggle(_ sender: UISwitch) {
        changeSettings()
    }
    
    
    @IBAction func onAnimationToggle(_ sender: UISwitch) {
        changeSettings()
    }
    
    
}
