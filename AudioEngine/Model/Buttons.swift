//
//  Button.swift
//  AudioEngine
//
//  Created by Александр Панин on 13.02.2022.
//

import Foundation
import simd

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
    let type: Buttons
    
    static func getPlayerButtons() -> [PlayerButtons] {
        [
            PlayerButtons(tag: 0, type: .gobackward),
            PlayerButtons(tag: 1, type: .backward),
            PlayerButtons(tag: 2, type: .play),
            PlayerButtons(tag: 3, type: .forward),
            PlayerButtons(tag: 4, type: .goforward)
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

struct EffectSliderImage {
    
    let tag: Int
    let type: Buttons
    let minImage: String
    let maxImage: String
    
    static func getEffectSliderImage() -> [EffectSliderImage] {
        [
            EffectSliderImage(tag: 0, type: .exit, minImage: "", maxImage: ""),
            EffectSliderImage(tag: 1, type: .volume, minImage: "", maxImage: ""),
            EffectSliderImage(tag: 2, type: .eq, minImage: "slider.vertical.3", maxImage: "slider.vertical.3"),
            EffectSliderImage(tag: 3, type: .reverb, minImage: "camera.metering.multispot", maxImage: "camera.metering.multispot"),
            EffectSliderImage(tag: 4, type: .delay, minImage: "antenna.radiowaves.left.and.right.slash", maxImage: "antenna.radiowaves.left.and.right")
        ]
    }
}
