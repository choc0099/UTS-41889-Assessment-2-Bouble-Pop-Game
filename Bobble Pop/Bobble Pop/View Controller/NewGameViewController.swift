//
//  NewGameViewController.swift
//  Bobble Pop
//
//  Created by Christopher Averkos on 3/4/2023.
//

import Foundation
import UIKit

class NewGameViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var TimerLabel: UILabel!
    @IBOutlet weak var bubblesLabel: UILabel!
    @IBOutlet weak var timerSlider: UISlider!
    @IBOutlet weak var bubblesSlider: UISlider!
    @IBOutlet weak var playerNameText: UITextField!

    var game = Game()
    var playerIdCounter: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        playerNameText.delegate = self
        
        updateUI()
    }
    
    
    @IBAction func timerValueChanged(_ sender: Any) {
        updateUI()
    }
    
    @IBAction func bubbleValueChanged(_ sender: Any) {
        updateUI()
    }
    
    func updateUI() {
        //display the bubbles and timer value that has been set.
        let timerSet: Int = Int(timerSlider.value)
        let bubbleSet: Int = Int(bubblesSlider.value)
        TimerLabel.text = String(timerSet)
        bubblesLabel.text = String(bubbleSet)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToGamePlay" {
            let player = Player(playerName: playerNameText.text!, playerId: playerIdCounter)
            game.addPlayers(player: player)
            let VC = segue.destination as! GamePlayViewController
            VC.remainingTime = Int(timerSlider.value)
            VC.numberOfBubbles = Int(bubblesSlider.value)
            VC.game = game //pass the game class data to the view
            VC.currentPlayer = player //stores the current player.
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("return key pressed.")
        playerNameText.resignFirstResponder()
        return true
    }
}
