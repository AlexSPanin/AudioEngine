//
//  ButtonEditorView.swift
//  AudioEngine
//
//  Created by Александр Панин on 18.02.2022.
//

import UIKit

class ButtonEditorView {
    
    static var shared = ButtonEditorView()
    
    private init() {}

    func getButtonsEditor () -> [UIButton] {
        let typeButtons = EditorButtons.getEditorButtons()
        var buttons: [UIButton] = []
        
        for type in typeButtons {
            let tag = buttons.count
            buttons.append(createButton(nameImage: type.nameImage, tag: tag))
        }
        return buttons
    }
  
    private  func createButton(nameImage: String, tag: Int) -> UIButton {
        let setting = Setting.getSetting()
        let button = UIButton()
        let image = UIImage(systemName: nameImage)
        
        button.setImage(image, for: .normal)
        button.tintColor = tag == 0 ? setting.colorBgrnd : setting.colorBrgndPlayerButton
        button.backgroundColor = tag == 0 ? setting.colorBrgndPlayerButton : setting.colorBgrnd
        
        button.tag = tag
        
        return button
    }
}
