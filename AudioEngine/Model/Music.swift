//
//  Music.swift
//  AudioEngine
//
//  Created by Александр Панин on 12.02.2022.
//

import Foundation
import AVFAudio

struct Music {
    let name: String
    let format: String
    
    static func getMusic() -> [Music] {
        [
            Music(name: "Scott Buckley - Life In Silico", format: "mp3"),
            Music(name: "01 The St. Louis Blues", format: "m4a"),
            Music(name: "otbivka", format: "mp3")
        ]
    }
}

