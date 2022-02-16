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
    
    case exit = "fx"
    case volume = "dot.radiowaves.up.forward"
    case eq = "slider.vertical.3"
    case reverb = "camera.metering.multispot"
    case delay = "antenna.radiowaves.left.and.right"
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

struct EffectButtons {
    
    let tag: Int
    let type: Buttons
    let name: String
    
    static func getEffectButtons() -> [EffectButtons] {
        [
            EffectButtons(tag: 0, type: .exit, name: "Выход"),
            EffectButtons(tag: 1, type: .volume, name: "Громкость"),
            EffectButtons(tag: 2, type: .eq, name: "Частоты"),
            EffectButtons(tag: 3, type: .reverb, name: "Реверб"),
            EffectButtons(tag: 4, type: .delay, name: "Дилэй")
        ]
    }
}



