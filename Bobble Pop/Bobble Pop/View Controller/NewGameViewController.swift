//
//  NewGameViewController.swift
//  Bobble Pop
//
//  Created by Christopher Averkos on 3/4/2023.
//

import Foundation
import UIKit

class NewGameViewController: UIViewController {
    @IBOutlet weak var TimerLabel: UILabel!
    @IBOutlet weak var bubblesLabel: UILabel!
    @IBOutlet weak var timerSlider: UISlider!
    @IBOutlet weak var bubblesSlider: UISlider!
    @IBOutlet weak var playerNameText: UITextField!

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
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
            
        
            let VC = segue.destination as! GamePlayViewController
            VC.remainingTime = Int(timerSlider.value)
            print(playerNameText.text!)
            
        }
    }
}

