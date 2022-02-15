//
//  NavigationPlayerView.swift
//  AudioEngine
//
//  Created by Александр Панин on 13.02.2022.
//

import UIKit

class ButtonPlayerView {
    
    static var shared = ButtonPlayerView()
    
    private init() {}

    func getButtonsPlayer () -> [UIButton] {
        let setting = Setting.getSetting()
        let typeButtons = PlayerButtons.getPlayerButtons()
        var buttons: [UIButton] = []
        
        for type in typeButtons {
            buttons.append(createButton(normal: type.typeNormal, selected: type.typeSelected ,  tint: setting.colorTintPlayerButton, tag: type.tag))
        }
        return buttons
    }
  
    private  func createButton(normal: Buttons, selected: Buttons, tint: UIColor, tag: Int) -> UIButton {
        let button = UIButton()
        button.tintColor = tint
        button.tag = tag
        button.setImage(UIImage(systemName: normal.rawValue), for: .normal)
        button.setImage(UIImage(systemName: selected.rawValue), for: .highlighted)
        return button
    }
}
