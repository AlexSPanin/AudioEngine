//
//  Setting.swift
//  AudioEngine
//
//  Created by Александр Панин on 14.02.2022.
//

import UIKit

struct Setting {
    let nameFont: String
    let smallSize: CGFloat
    let normalSize: CGFloat
    let largeSize: CGFloat
    
    let colorText: UIColor
    let colorTint: UIColor
    let colorBgrnd: UIColor
    let colorLabel: UIColor
    
    static func getSetting() -> Setting {
        Setting(
            nameFont: "Thonburi",
            smallSize: 9,
            normalSize: 12,
            largeSize: 20,
            colorText: #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1),
            colorTint: #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1),
            colorBgrnd: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),
            colorLabel: #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        )
    }
}
