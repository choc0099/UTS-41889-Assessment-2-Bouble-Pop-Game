//
//  GameScore.swift
//  Bobble Pop
//
//  Created by Christopher Averkos on 19/4/2023.
//

import Foundation

//This is used to help with storing score data to the tableView.
struct GameScore: Codable {
    var name: String
    var score: Int
}
