//
//  ButtonsEffect.swift
//  AudioEngine
//
//  Created by Александр Панин on 18.02.2022.
//

import Foundation

enum ButtonsEffect: Int {
    case exit, volume, eq, reverb, delay
}

struct EffectButtons {
    
    let type: ButtonsEffect
    let name: String
    let nameImage: String
    
    static func getEffectButtons() -> [EffectButtons] {
        [
            EffectButtons(type: .exit, name: "Выход", nameImage: "fx"),
            EffectButtons(type: .volume, name: "Громкость", nameImage: "dot.radiowaves.up.forward"),
            EffectButtons(type: .eq, name: "Частоты", nameImage: "slider.vertical.3"),
            EffectButtons(type: .reverb, name: "Реверб", nameImage: "camera.metering.multispot"),
            EffectButtons(type: .delay, name: "Дилэй", nameImage: "antenna.radiowaves.left.and.right")
        ]
    }
}
