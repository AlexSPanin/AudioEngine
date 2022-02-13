//
//  NavigationPlayerView.swift
//  AudioEngine
//
//  Created by Александр Панин on 13.02.2022.
//




import UIKit

class NavigationPlayerView {
    
    private let stack = UIStackView()
    private let heigth: CGFloat = 30
    private let colorBgrn: UIColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
    private let colorTint: UIColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    private var audioVC = AudioEngineViewController()
       
    static var shared = NavigationPlayerView()
    
    private init() {}
    
    @objc func pressPlayerButtons(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            return
        case 1:
            return
        case 2:
            audioVC.playButton()
        case 3:
            return
        case 4:
            return
        default:
            return
        }
    }
    
    func setupNavigationPlayer () -> UIStackView {
        let stack = UIStackView()
        let typeButtons = PlayerButtons.getPlayerButtons()
        for type in typeButtons {
            let button = createButton(type: type.type, tint: colorTint, tag: type.tag)
            let tag = type.tag
            
            stack.insertArrangedSubview(button, at: tag)
        }
        
        stack.axis = .horizontal
        stack.spacing = 5
        stack.distribution = UIStackView.Distribution.fillEqually
        stack.backgroundColor = colorBgrn
        return stack
    }
    
    private  func createButton(type: Buttons, tint: UIColor, tag: Int) -> UIButton {
        let button = UIButton()
        button.tintColor = tint
        button.tag = tag
        button.setImage(UIImage(systemName: type.rawValue), for: .normal)
        button.addTarget(self, action: #selector(pressPlayerButtons), for: .touchDown)
    
        return button
    }
}
