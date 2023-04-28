//
//  HighScoreViewController.swift
//  Bobble Pop
//
//  Created by Christopher Averkos on 4/4/2023.
//

import Foundation
import UIKit

class HighScoreViewController: UIViewController {
    var game = Game() //declars a game object.
    @IBOutlet weak var highScoreTableView: UITableView!
    @IBOutlet weak var returnButton: UIButton!
    
    var isReturnButtonHidden: Bool = false
    var highScores: [GameScore] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        hideHomeButton(hideIt: isReturnButtonHidden)
         // reads the high score date from the HighScoreManager
        highScores = HighScoreManager.readHighScroes()
        //sorts the array with the highest score
        highScores.sort(by: {
            $0.score > $1.score
        })
    }
    
    @IBAction func returnButtonPressed(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    //this hides the Home button on this view when you press "High Score" from the main screen.
    func hideHomeButton(hideIt isHidden: Bool) {
        if isHidden {
            returnButton.alpha = 0
        }
    }
}

extension HighScoreViewController:UITableViewDelegate {  var highScores: [GameScore] = []
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
