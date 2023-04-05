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
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        var timerSet: Int = Int(timerSlider.value)
        var bubbleSet: Int = Int(bubblesSlider.value)
        
        //display the bubbles and timer value that has been set.
        TimerLabel.text = String(timerSet)
        bubblesLabel.text = String(bubbleSet)
    }
}

