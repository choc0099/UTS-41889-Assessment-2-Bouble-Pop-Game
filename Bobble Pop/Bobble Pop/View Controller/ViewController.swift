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
        let gameSettings = game.getGameSettings()
        let deviceWidth = Int(self.view.bounds.width)
        let deviceHeight = Int(self.view.bounds.height)
        
        gameSettings.setDeviceWdihAndHeight(deviceWidth: deviceWidth, deviceHeight: deviceHeight)
        self.initializeGame()
        
        //for testing
        for player in game.getPlayers()
        {
            print(player.getPlayerName())
            print(player.getScore().getHighScore())
        }
        
        // Do any additional setup after loading the view.
    }
    
    //a function that will prevent the game from overwriting the highscores when the app is restarted.
    func initializeGame() {
        if gameData.count > 0
        {
            for storedPlayer in gameData
            {
                var player = Player(playerName: storedPlayer.name)
                //print(storedPlayer.name)
                var playerScore = player.getScore()
                playerScore.setScore(currentScore: storedPlayer.score)
                game.addPlayer(player: player)
            }
        }
        print("func ex")
       
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToNewGame" {
            let VC = segue.destination as! NewGameViewController
            VC.game = game
        }
        else if segue.identifier == "goToHighScore"
        {
            let VC = segue.destination as! HighScoreViewController
            //VC.game = game
        }
    }
}

