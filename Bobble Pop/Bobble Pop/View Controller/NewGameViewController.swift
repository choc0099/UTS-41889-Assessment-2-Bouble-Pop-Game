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
    //declare a game session objecct
    var game = Game()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // declars a deligate for the return key to hide the on-screen keyboard.
        playerNameText.delegate = self
        //disables the start button if there is no name entered.
        disableButton(disabileIt: true)
        //sets the borders and corner radius of the start button.
        startButton.layer.cornerRadius = 10
        startButton.layer.borderWidth = 4
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToGamePlay" {
            let player = Player(playerName: playerNameText.text!)
            game.addPlayer(player: player)
            let VC = segue.destination as! GamePlayViewController
            VC.game = game //pass the game class data to the view
            VC.currentPlayer = player //stores the current player.
        }
        else if segue.identifier == "goToSettings" {
            let VC = segue.destination as! SettingsViewController
            VC.game = game //passed the game session to the SettingsViewController
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        playerNameText.resignFirstResponder()
        return true
    }
    
    @IBAction func onNameTextChanged(_ sender: UITextField) {
        if playerNameText.text != "" {
            disableButton(disabileIt: false)
            nameLabel.text = "Name is entered."
        }
        else {
            disableButton(disabileIt: true)
            nameLabel.text = "Invalid Input: Enter your name."
        }
    }
    
    func disableButton(disabileIt isDisabled: Bool) {
        if isDisabled {
            startButton.layer.opacity = 0.7
            startButton.isEnabled = false
        }
        else {
            startButton.layer.opacity = 1
            startButton.isEnabled = true
        }
    }
}
