//
//  Button.swift
//  AudioEngine
//
//  Created by Александр Панин on 13.02.2022.
//

import Foundation

enum Buttons: String, CaseIterable {
    case play = "play"
    case pause = "pause"
    case forward = "forward"
    case backward = "backward"
    case goforward = "goforward"
    case gobackward = "gobackward"
}

struct PlayerButtons {
    
    let tag: Int
    let type: Buttons
    let name: String
    
    static func getPlayerButtons() -> [PlayerButtons] {
        [
            PlayerButtons(tag: 0, type: .gobackward, name: Buttons.gobackward.rawValue),
            PlayerButtons(tag: 1, type: .backward, name: Buttons.backward.rawValue),
            PlayerButtons(tag: 2, type: .play, name: Buttons.play.rawValue),
            PlayerButtons(tag: 3, type: .forward, name: Buttons.forward.rawValue),
            PlayerButtons(tag: 4, type: .goforward, name: Buttons.goforward.rawValue)
        ]
    }
    
    
    
    
    
}
