//
//  ButtonsEditor.swift
//  AudioEngine
//
//  Created by Александр Панин on 18.02.2022.
//

import Foundation

enum ButtonsEditor: Int {
    case effect, copy, cut, off, on, trash
}

struct EditorButtons {
    
    let type: ButtonsEditor
    let nameImage: String
    
    static func getEditorButtons() -> [EditorButtons] {
        [
            EditorButtons(type: .effect, nameImage: "fx"),
            EditorButtons(type: .copy, nameImage: "square.on.square"),
            EditorButtons(type: .cut, nameImage: "scissors"),
            EditorButtons(type: .off, nameImage: "speaker"),
            EditorButtons(type: .on, nameImage: "speaker.wave.2"),
            EditorButtons(type: .trash, nameImage: "trash")
        ]
    }
}
