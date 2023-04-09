//
//  GamePlayViewController.swift
//  Bobble Pop
//
//  Created by Christopher Averkos on 4/4/2023.
//

import Foundation
import UIKit

class GamePlayViewController: UIViewController {
    
    @IBOutlet weak var remainingTimeLabel: UILabel!
    @IBOutlet weak var highScoreLabel: UILabel!
    @IBOutlet weak var currentScoreLabel: UILabel!
    
    var remainingTime = 0
    var currentScore = 0
    var timer = Timer()
    var game = Game()
    var currentPlayer = Player()
  
    
    
    
    //var score: Score = Score()
    
    /*init(game: Game)
     {
     self.game = game
     super.init(nibName: nil, bundle: nil)
     }
     
     required init?(coder: NSCoder) {
     fatalError("Failed to implement \(coder) class.")
     }*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        remainingTimeLabel.text = String(remainingTime)
        //game.getPlayers()
        //let currentPlayerId = currentPlayer.getPlayerId()
        print(currentPlayer.getPlayerName()!)
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {
            timer in
            self.countingDown()
            self.generateBubble()
        }
    }
    
    @objc func countingDown() {
        remainingTime -= 1
        remainingTimeLabel.text = String(remainingTime)
        
        if remainingTime == 0 {
            timer.invalidate()
            
            let VC = storyboard?.instantiateViewController(identifier: "HighScoreViewController") as! HighScoreViewController
            self.navigationController?.pushViewController(VC, animated: true)
            VC.navigationItem.setHidesBackButton(true, animated: true)
        }
    }
    
    func generateBubble() {
        let bubble = Bubble()
        bubble.addTarget(self, action: #selector(bubblePressed), for: .touchUpInside)
        self.view.addSubview(bubble)
    }
    
    func updateUI()
    {
        currentScoreLabel.text = String(currentScore)
    }
    
    @IBAction func bubblePressed(_ sender: UIButton) {
        
        sender.removeFromSuperview()
        currentScore = 5
        updateUI()
    }
}
