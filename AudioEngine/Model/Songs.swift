//
//  Music.swift
//  AudioEngine
//
//  Created by Александр Панин on 12.02.2022.
//

import Foundation

struct Songs {
    let name: String
    let format: String
    
    static func getSongs() -> [Songs] {
        [
            Songs(name: "Scott Buckley - Life In Silico", format: "mp3"),
            Songs(name: "01 The St. Louis Blues", format: "m4a"),
            Songs(name: "otbivka", format: "mp3")
        ]
    }
}

