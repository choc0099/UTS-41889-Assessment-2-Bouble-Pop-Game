//
//  HighScoreViewController.swift
//  Bobble Pop
//
//  Created by Christopher Averkos on 4/4/2023.
//

import Foundation
import UIKit


let KEY_HIGH_SCORE = "highScore"
class HighScoreViewController: UIViewController {

   var game = Game()

    @IBOutlet weak var highScoreTableView: UITableView!
    
    var highScores: [GameScore] = []
    
    
    //var gamePlayers = copyPlayers()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        highScores = readHighScroes()
        print(highScores)
        
        //renderResults()
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
    /*
    //this will be used for table view to enable sorting without effecting the original class due to class referencing an object.
    func copyPlayers() -> [Player]
    {
        var copiedPlayers: [Player] = []
        let players = game.getPlayers()
        for player in players
        {
            copiedPlayers.append(player)
        }
        return copiedPlayers
    }*/
    
    func readHighScroes() -> [GameScore] {
        // Read from User Defaults
        // This should happen at the HighScrollViewController
        
        let defaults = UserDefaults.standard;
        
        if let savedArrayData = defaults.value(forKey:Game.KEY_HIGH_SCORE) as? Data {
            if let array = try? PropertyListDecoder().decode(Array<GameScore>.self, from: savedArrayData) {
                return array
            } else {
                return []
            }
        } else {
            return []
        }
    }
    
}

extension HighScoreViewController:UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // When a cell is selected, say hello
        let index = indexPath.row;
        let name = self.highScores[index]
        print("Hello \(name)")
    }
}

extension HighScoreViewController:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return highScores.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // As table view, what cell should I display, when user's at this index?
        
        // Dequed a reusable cell from the table view
        let cell = tableView.dequeueReusableCell(withIdentifier: "highScoreCell", for: indexPath);
        
        // Updated the UI for this Cell
        let score = highScores[indexPath.row]
        
        cell.textLabel?.text = score.name;
        cell.detailTextLabel?.text = "Score: \(score.score)";
        
        // Return the cell to TableView
        return cell;
        
    }
}
