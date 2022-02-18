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
        let typeButtons = PlayerButtons.getPlayerButtons()
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
        button.tintColor = setting.colorTintPlayerButton
        button.backgroundColor = setting.colorBrgndPlayerButton
        button.tag = tag
        
        return button
    }
}
