//
//  NewGameViewController.swift
//  Bobble Pop
//
//  Created by Christopher Averkos on 3/4/2023.
//

import Foundation
import UIKit

class NewGameViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var playerNameText: UITextField!
    @IBOutlet weak var startButton: UIButton!
    
    var game = Game()
    var playerIdCounter: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        playerNameText.delegate = self
        
        //disables the start button if there is no name entered.
        disableButton(disabileIt: true)
        startButton.layer.cornerRadius = 10
        startButton.layer.borderWidth = 4
        
        
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToGamePlay" {
            let player = Player(playerName: playerNameText.text!, playerId: playerIdCounter)
            game.addPlayers(player: player)
            let VC = segue.destination as! GamePlayViewController
            //VC.remainingTime = Int(timerSlider.value)
            //VC.numberOfBubbles = Int(bubblesSlider.value)
            VC.game = game //pass the game class data to the view
            VC.currentPlayer = player //stores the current player.
        }
        else if segue.identifier == "goToSettings"
        {
            let VC = segue.destination as! SettingsViewController
            VC.game = game
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("return key pressed.")
        playerNameText.resignFirstResponder()
        return true
    }
    
    @IBAction func onNameTextChanged(_ sender: UITextField) {
        if playerNameText.text != "" {
            disableButton(disabileIt: false)
        }
        else
        {
            disableButton(disabileIt: true)
        }
    }
    
    func disableButton(disabileIt isDisabled: Bool)
    {
        if isDisabled {
            
            
            startButton.backgroundColor = .red
          
            startButton.isEnabled = false
            //startButton.setTitleColor(.white, for: UIControl.State.disabled)
            //startButton.tintColor = .red
            
        }
        else
        {
            
            startButton.backgroundColor = .green
            //startButton.titleLabel?.textColor = .black
            startButton.isEnabled = true
        }
    }
    
    
}
