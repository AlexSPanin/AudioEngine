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
            buttons.append(createButton(type: type.type, tint: setting.colorTintPlayerButton, tag: type.tag))
        }
        return buttons
    }
  
    private  func createButton(type: Buttons, tint: UIColor, tag: Int) -> UIButton {
        let button = UIButton()
        button.tintColor = tint
        button.tag = tag
        button.setImage(UIImage(systemName: type.rawValue), for: .normal)
        return button
    }
}
