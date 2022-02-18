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
            EditorButtons(type: .copy, nameImage: "dot.radiowaves.up.forward"),
            EditorButtons(type: .cut, nameImage: "slider.vertical.3"),
            EditorButtons(type: .off, nameImage: "camera.metering.multispot"),
            EditorButtons(type: .on, nameImage: "antenna.radiowaves.left.and.right"),
            EditorButtons(type: .trash, nameImage: "antenna.radiowaves.left.and.right")
        ]
    }
}
