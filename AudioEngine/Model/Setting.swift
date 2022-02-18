//
//  Setting.swift
//  AudioEngine
//
//  Created by Александр Панин on 14.02.2022.
//

import UIKit

struct Setting {
    // font
    let nameFont: String
    let smallSize: CGFloat
    let normalSize: CGFloat
    let largeSize: CGFloat
    // color
    let colorText: UIColor
    let colorTint: UIColor
    let colorBgrnd: UIColor
    let colorLabel: UIColor
    let colorBrgndPlayerButton: UIColor
    let colorTintPlayerButton: UIColor
    let colorPressedButtonEffect: UIColor
    // size
    let sizeButton: CGRect
    let sizeImageButton: CGRect
    
    static func getSetting() -> Setting {
        Setting(
            nameFont: "Thonburi",
            smallSize: 9,
            normalSize: 12,
            largeSize: 20,
            colorText: #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1),
            colorTint: #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1),
            colorBgrnd: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),
            colorLabel: #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1),
            colorBrgndPlayerButton: #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1),
            colorTintPlayerButton: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),
            colorPressedButtonEffect: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1),
            sizeButton: CGRect(x: 0, y: 0, width: 50, height: 60),
            sizeImageButton: CGRect(x: 0, y: 0, width: 50, height: 50)
          
            
        )
    }
}
