//
//  HighScoreViewController.swift
//  Bobble Pop
//
//  Created by Christopher Averkos on 4/4/2023.
//

import Foundation
import UIKit

class HighScoreViewController: UIViewController {

   var game = Game()
    
    @IBOutlet weak var VerticalScoreStack: UIStackView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        renderResults()
    }
    
    //func retrievePlayers()
    
    @IBAction func returnButtonPressed(_ sender: UIButton) {
        let VC = storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! ViewController
        VC.game = game
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func renderResults()
    {
        let gamePlayers = game.getPlayers()
        
        var labelsYPos = 160
        for player in gamePlayers {
            let playerName = player.getPlayerName()!
            let playerScore = player.getScore().getHighScore()
            
            generateLabel(playerName: playerName, playerScore: playerScore, yPosition: labelsYPos)
            labelsYPos += 60
            print("Player Name: \(playerName), player score: \(playerScore)")
        }
    }
    
    func generateLabel(playerName playerNameText: String, playerScore playerScoreInt: Int, yPosition: Int) {
        //sets the X position to the right label according to screen width.
        let rightLabelXPos = game.getGameSettings().getDeviceWidth()
        
        let nameLabel = UILabel()
        let scoreLabel = UILabel()
        // sets the positions and sizes for the labels
        nameLabel.frame = CGRect(x: 40, y: yPosition, width: 120, height: 50)
        scoreLabel.frame = CGRect(x: rightLabelXPos - 120, y: yPosition, width: 70, height: 50)
        // adds the texts.
        nameLabel.text = playerNameText
        scoreLabel.text = String(playerScoreInt)
        nameLabel.textAlignment = .left
        scoreLabel.textAlignment = .right
        //shows the labels on the screen.
        self.view.addSubview(nameLabel)
        self.view.addSubview(scoreLabel)
        //nameLabel.addSubview(self)
    }
}
