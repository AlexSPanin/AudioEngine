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
    let typeNormal: Buttons
    let typeSelected: Buttons
    
    static func getPlayerButtons() -> [PlayerButtons] {
        [
            PlayerButtons(tag: 0, typeNormal: .gobackward, typeSelected: .gobackward),
            PlayerButtons(tag: 1, typeNormal: .backward, typeSelected: .backward),
            PlayerButtons(tag: 2, typeNormal: .play, typeSelected: .pause),
            PlayerButtons(tag: 3, typeNormal: .forward, typeSelected: .forward),
            PlayerButtons(tag: 4, typeNormal: .goforward, typeSelected: .goforward)
        ]
    }
}




