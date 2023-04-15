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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        game.getPlayers()
        
  
    }
    
    @IBAction func returnButtonPressed(_ sender: UIButton) {
        let VC = storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! ViewController
        VC.game = game
        self.navigationController?.popToRootViewController(animated: true)
    }
}
