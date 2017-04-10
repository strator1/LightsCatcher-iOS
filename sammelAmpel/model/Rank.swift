//
//  Rank.swift
//  sammelAmpel
//
//  Created by Patrick Valenta on 05.04.17.
//  Copyright © 2017 Patrick Valenta. All rights reserved.
//

import Foundation

struct Rank {
    var key: String
    var position: Int
    var name: String
    var points: Int
    
    init(key: String, dict: NSDictionary, pos: Int) {
        self.key = key
       self.position = pos
        self.name = dict["name"] as? String ?? ""
        self.points = dict["points"] as? Int ?? 0
    }
    
    init(key: String, position: Int, name: String, points: Int) {
        self.key = key
        self.position = position
        self.name = name
        self.points = points
    }
    
    func getPositionText() -> String {
        switch position {
        case 1: return "🥇"
        case 2: return "🥈"
        case 3: return "🥉"
        default: return "\(position.description)."
        }
    }
}
