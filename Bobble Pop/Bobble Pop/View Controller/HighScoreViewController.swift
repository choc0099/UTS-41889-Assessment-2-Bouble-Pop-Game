//
//  HighScoreViewController.swift
//  Bobble Pop
//
//  Created by Christopher Averkos on 4/4/2023.
//

import Foundation
import UIKit


//let KEY_HIGH_SCORE = "highScore"
class HighScoreViewController: UIViewController {

   var game = Game()

    @IBOutlet weak var highScoreTableView: UITableView!
    
    var highScores: [GameScore] = []
    
    @IBOutlet weak var returnButton: UIButton!
    var isReturnButtonHidden: Bool = false
    
    //var gamePlayers = copyPlayers()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        hideHomeButton(hideIt: isReturnButtonHidden)
           
        highScores = HighScoreManager.readHighScroes()
        
        //sorts the array with the highest score
        highScores.sort(by: {
            $0.score > $1.score
        })
        
        print(highScores)
    }
    
    @IBAction func returnButtonPressed(_ sender: UIButton) {
        //let VC = storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! ViewController
        //VC.game = game
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func hideHomeButton(hideIt isHidden: Bool)
    {
        if isHidden{
            returnButton.alpha = 0
        }
    }
    /*
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
    }*/
    
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
        cell.detailTextLabel?.text = "\(score.score)";
        
        // Return the cell to TableView
        return cell;
        
    }
}
