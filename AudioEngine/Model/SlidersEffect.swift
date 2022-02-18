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
    
    let type: ButtonsEffect
    let minImage: String
    let maxImage: String
    
    static func getEffectSliderImage() -> [EffectSliderImage] {
        [
            EffectSliderImage(type: .exit, minImage: "", maxImage: ""),
            EffectSliderImage(type: .volume, minImage: "", maxImage: ""),
            EffectSliderImage(type: .eq, minImage: "slider.vertical.3", maxImage: "slider.vertical.3"),
            EffectSliderImage(type: .reverb, minImage: "camera.metering.multispot", maxImage: "camera.metering.multispot"),
            EffectSliderImage(type: .delay, minImage: "antenna.radiowaves.left.and.right.slash", maxImage: "antenna.radiowaves.left.and.right")
        ]
    }
}

struct EffectSliderLabel {
    
    let type: ButtonsEffect
    let minLabel: String
    let maxLabel: String
    
    static func getEffectSliderLabel() -> [EffectSliderLabel] {
        [
            EffectSliderLabel(type: .exit, minLabel: "", maxLabel: ""),
            EffectSliderLabel(type: .volume, minLabel: "0 ДБ", maxLabel: "50 ДБ"),
            EffectSliderLabel(type: .eq, minLabel: "", maxLabel: ""),
            EffectSliderLabel(type: .reverb, minLabel: "", maxLabel: ""),
            EffectSliderLabel(type: .delay, minLabel: "", maxLabel: "")
        ]
    }
}

struct EffectSliderValue {
    
    let type: ButtonsEffect
    let count: Int
    let track: SideTrack
    let value: Float
    let minimum: Float
    let maximum: Float
    
    static func getEffectSliderValue() -> [EffectSliderValue] {
        [
            EffectSliderValue(type: .exit, count: 1, track: .minimum, value: 0.5, minimum: 0, maximum: 1),
            EffectSliderValue(type: .volume, count: 1, track: .minimum, value: 0.1, minimum: 0, maximum: 1),
            EffectSliderValue(type: .eq, count: 1, track: .maximum, value: 0, minimum: 0, maximum: 50),
            EffectSliderValue(type: .reverb, count: 1, track: .minimum, value: 0, minimum: 0, maximum: 100),
            EffectSliderValue(type: .delay, count: 1, track: .minimum, value: 0, minimum: 0, maximum: 1)
        ]
    }
}
struct SlidersValue {
    var volume: Float
    var eq: Float
    var reverb: Float
    var delay: Float
    
    static func getSlidersValue() -> SlidersValue {
        let setup = EffectSliderValue.getEffectSliderValue()
        return SlidersValue(
            volume: setup[ButtonsEffect.volume.rawValue].value,
            eq: setup[ButtonsEffect.eq.rawValue].value,
            reverb: setup[ButtonsEffect.reverb.rawValue].value,
            delay: setup[ButtonsEffect.delay.rawValue].value
        )
    }
}

struct TrackSlidersValue {
    var track: Int
    var slidersValue: SlidersValue
    
    static func getTrackSlidersValue() -> [TrackSlidersValue] {
        let tracks = Songs.getSongs()
        var tracksValue: [TrackSlidersValue] = []
        
        for _ in tracks {
            let index = tracksValue.count
            let trackValue = TrackSlidersValue(
                track: index,
                slidersValue: SlidersValue.getSlidersValue()
            )
            tracksValue.append(trackValue)
        }
        return tracksValue
    }
}
