//
//  ViewController.swift
//  Bobble Pop
//
//  Created by Christopher Averkos on 28/3/2023.
//

import UIKit

class ViewController: UIViewController {

    //var gameSettings = GameSettings()
    
    let gameData = HighScoreManager.readHighScroes()
    var game = Game()
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        self.initializeGame()
    }
    
    //a function that will prevent the game from overwriting the highscores when the app is restarted.
    func initializeGame() {
        if gameData.count > 0 { //prevents the app from crashing if there is nothing on userDefaults
            for storedPlayer in gameData {
                let player = Player(playerName: storedPlayer.name)
                //print(storedPlayer.name)
                let playerScore = player.getScore()
                playerScore.setScore(currentScore: storedPlayer.score)
                game.addPlayer(player: player)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToNewGame" {
            let VC = segue.destination as! NewGameViewController
            VC.game = game
        }
        else if segue.identifier == "goToHighScore" {
            let VC = segue.destination as! HighScoreViewController
            //hides the return button when you press on the High Score view from the main menur.
            VC.isReturnButtonHidden = true
        }
    }
    /*
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        if UIDevice.current.orientation.isLandscape {
            print("landscape")
        }
        else{
            print("Portriat")
        }
    }*/
}

