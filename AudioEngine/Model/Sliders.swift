//
//  Sliders.swift
//  AudioEngine
//
//  Created by Александр Панин on 16.02.2022.
//

import Foundation

enum SideTrack {
    case empty
    case minimum
    case maximum
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

struct EffectSliderValue {
    let tag: Int
    let type: Buttons
    let count: Int
    let track: SideTrack
    
    let value: Float
    let minimum: Float
    let maximum: Float
    
    static func getEffectSliderValue() -> [EffectSliderValue] {
        [
            EffectSliderValue(tag: 1, type: .volume, count: 1, track: .minimum, value: 20, minimum: 0, maximum: 50),
            EffectSliderValue(tag: 2, type: .eq, count: 1, track: .maximum, value: 1, minimum: 0, maximum: 2),
            EffectSliderValue(tag: 3, type: .reverb, count: 1, track: .minimum, value: 1, minimum: 0, maximum: 2),
            EffectSliderValue(tag: 4, type: .delay, count: 1, track: .minimum, value: 1, minimum: 0, maximum: 2)
        ]
    }
}
