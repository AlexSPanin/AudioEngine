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
            let tag = buttons.count
            buttons.append(createButton(nameImage: type.nameImage, tag: tag))
        }
        return buttons
    }
    
    func getLabelEffect() -> [UILabel] {
        let setting = Setting.getSetting()
        let typeLabels = EffectButtons.getEffectButtons()
        var labels: [UILabel] = []
        
        for type in typeLabels {
            let tag = labels.count
            labels.append(createLabel(title: type.name, font: setting.nameFont, size: setting.smallSize, tag: tag))
        }
        return labels
    }
    
    //MARK: - create button and ladel
    
    private func createButton(nameImage: String, tag: Int) -> UIButton {
        let setting = Setting.getSetting()
        let button = UIButton()
        let image = UIImage(systemName: nameImage)
        
        button.setImage(image, for: .normal)
        button.tintColor = tag == 0 ? setting.colorBgrnd : setting.colorTint
        button.backgroundColor = tag == 0 ? setting.colorBrgndPlayerButton : setting.colorBgrnd
        button.tag = tag
        
        return button
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


    

