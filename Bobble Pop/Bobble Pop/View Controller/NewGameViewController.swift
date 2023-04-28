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
    
    @IBOutlet weak var nameLabel: UILabel!
    
    var game = Game()
    var playerIdCounter: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        game.gameSettings.setTimer(howLong: 60)
        game.gameSettings.setNumberOfBubbles(howMany: 15)
        
        playerNameText.delegate = self
        
        //disables the start button if there is no name entered.
        disableButton(disabileIt: true)
        startButton.layer.cornerRadius = 10
        startButton.layer.borderWidth = 4
        
        
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToGamePlay" {
            let player = Player(playerName: playerNameText.text!)
            game.addPlayer(player: player)
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
        //let alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
        //checkLetters(name: playerNameText.text!)
        if playerNameText.text != "" {
            disableButton(disabileIt: false)
            nameLabel.text = "Name is entered."
        }
        else
        {
            disableButton(disabileIt: true)
            nameLabel.text = "Invalid Input: Enter your name."
        }
    }
    
    func disableButton(disabileIt isDisabled: Bool)
    {
        if isDisabled {
            
            startButton.layer.opacity = 0.7
            startButton.isEnabled = false
            //startButton.setTitleColor(.white, for: UIControl.State.disabled)
            //startButton.tintColor = .red
            
        }
        else
        {
            startButton.layer.opacity = 1
            startButton.isEnabled = true
        }
    }
    
    func checkLetters(name nameText: String)
    {
        let alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXUYZabcdefghijklmnopqrstuvwxyz"

        
        for letter in alphabet {
            print(letter)
            for char in nameText {
                print(char)
                if char == letter
                {
                    print("Letter found")
                }
                else
                {
                    print("letter not found.")
                }
            }
        }
    }
    
    
}
