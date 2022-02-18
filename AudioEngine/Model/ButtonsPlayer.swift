//
//  Button.swift
//  AudioEngine
//
//  Created by Александр Панин on 13.02.2022.
//

import Foundation


enum ButtonsPlayer: Int {
    case gobackward, backward, play, forward, goforward
}

struct PlayerButtons {
    
    let type: ButtonsPlayer
    let nameImage: String
    
    static func getPlayerButtons() -> [PlayerButtons] {
        [
            PlayerButtons(type: .gobackward, nameImage: "gobackward"),
            PlayerButtons(type: .backward, nameImage: "backward"),
            PlayerButtons(type: .play, nameImage: "play"),
            PlayerButtons(type: .forward, nameImage: "forward"),
            PlayerButtons(type: .goforward, nameImage: "goforward")
        ]
    }
}




