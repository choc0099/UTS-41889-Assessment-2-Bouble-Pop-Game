//
//  ViewController.swift
//  Bobble Pop
//
//  Created by Christopher Averkos on 28/3/2023.
//

import UIKit

class ViewController: UIViewController {

    //var gameSettings = GameSettings()
    
    var game = Game()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToNewGame" {
            let VC = segue.destination as! NewGameViewController
            VC.game = game
        }
    }
}

