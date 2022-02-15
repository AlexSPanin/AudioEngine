//
//  NavigationEffectButton.swift
//  AudioEngine
//
//  Created by Александр Панин on 14.02.2022.
//

import UIKit

class ButtonEffectView {
    
    static var shared = ButtonEffectView()
    private init() {}
    
    func getButtonEffect() -> [UIButton] {
        
        let typeButtons = EffectButtons.getEffectButtons()
        var buttons: [UIButton] = []
        
        for type in typeButtons {
            buttons.append(createButton(type: type.type, title: type.name, tag: type.tag))
        }
        return buttons
    }
    
    private func createButton(type: Buttons, title: String, tag: Int) -> UIButton {
        let setting = Setting.getSetting()
        let button = UIButton()
        let image = UIImage(systemName: type.rawValue)
        
        button.setImage(image, for: .normal)
        button.tintColor = tag == 0 ? setting.colorBgrnd : setting.colorTint
        button.backgroundColor = tag == 0 ? setting.colorBrgndPlayerButton : setting.colorBgrnd
        button.tag = tag
        
        return button
    }
    
    func getLabelEffect() -> [UILabel] {
        let setting = Setting.getSetting()
        let typeLabels = EffectButtons.getEffectButtons()
        var labels: [UILabel] = []
        
        for type in typeLabels {
            labels.append(createLabel(title: type.name, font: setting.nameFont, size: setting.smallSize, tag: type.tag))
        }
        return labels
    }
    
    private func createLabel(title: String, font: String, size: CGFloat, tag: Int) -> UILabel {
        let setting = Setting.getSetting()
        let label = UILabel()
        guard let font = UIFont(name: font, size: size) else {return label }
        label.font = font
        label.textColor = tag == 0 ? setting.colorBgrnd : setting.colorTint
        label.backgroundColor = tag == 0 ? setting.colorBrgndPlayerButton : setting.colorBgrnd
        label.minimumScaleFactor = 0.5
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = title
        label.tag  = tag
        return label
    }
}


    

