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
    
    @objc func pressEffectButtons(_ sender: UIButton) {
        
        
        switch sender.tag {
        case 0:
            return
        case 1:
            return
        case 2:
            return
        case 3:
            return
        case 4:
            return
        default:
            return
        }
    }
    func createButtonStack() -> UIStackView {
        let setting = Setting.getSetting()
        let stack = UIStackView()
        let typeButtons = EffectButtons.getEffectButtons()
        for type in typeButtons {
            let button = createButton(
                type: type.type,
                tint: setting.colorTint,
                tag: type.tag
            )
            let title = createLabel(
                title: type.name,
                font: setting.nameFont,
                size: setting.normalSize,
                colorText: setting.colorText,
                colorBgrnd: setting.colorBgrnd
            )
            let tag = type.tag
            
            let stackButtonTitle = UIStackView(arrangedSubviews: [button, title])
            stackButtonTitle.axis = .vertical
            stackButtonTitle.spacing = 3
            stackButtonTitle.distribution = UIStackView.Distribution.fillEqually
            stackButtonTitle.backgroundColor = setting.colorBgrnd
            
            stack.insertArrangedSubview(stackButtonTitle, at: tag)
        }
        
        stack.axis = .horizontal
        stack.spacing = 10
        stack.distribution = UIStackView.Distribution.fillEqually
        stack.backgroundColor = setting.colorBgrnd
        return stack
    }
    
    private func createButton(type: Buttons, tint: UIColor, tag: Int) -> UIButton {
        let button = UIButton()
        button.tintColor = tint
        button.tag = tag
        button.setImage(UIImage(systemName: type.rawValue), for: .normal)
        button.addTarget(self, action: #selector(pressEffectButtons), for: .touchDown)
        
        return button
    }
    
    private func createLabel(
        title: String, font: String, size: CGFloat,
        colorText: UIColor, colorBgrnd: UIColor) -> UILabel {
            
            let label = UILabel()
            guard let font = UIFont(name: font, size: size) else {return label }
            label.font = font
            label.textColor = colorText
            label.backgroundColor = colorBgrnd
            label.minimumScaleFactor = 0.5
            label.adjustsFontSizeToFitWidth = true
            label.numberOfLines = 0
            label.textAlignment = .center
            label.text = title
            return label
        }
}


    

