//
//  NavigationEffectView.swift
//  AudioEngine
//
//  Created by Александр Панин on 13.02.2022.
//

import UIKit

class SliderEffectView {
    
//    let fontNormal = UIFont(name: "Thonburi", size: 10)
//    let fontLarge = UIFont(name: "Thonburi", size: 20)
    
    private let stack = UIStackView()
//    private let heigth: CGFloat = 30
//    private let colorBgrn: UIColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//    private let colorTint: UIColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
//    private let colorTextButton: UIColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
//    private let colorTextSlider: UIColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
    private var audioVC = AudioEngineViewController()
    
    static var shared = SliderEffectView()
    
    private init() {}
    
    
    func createSlidersStack(_ tag: Int) -> UIStackView {
        let setting = Setting.getSetting()
        
        var slider = UISlider()
        var stackLabel = UIStackView()
        var stack = UIStackView()
        
        switch tag {
        case 0:
            return stack
        case 1:
            slider = volumeSlider()
            stackLabel = volumeLabel(
                font: setting.nameFont, size: setting.normalSize,
                colorText: setting.colorText, colorBgrnd: setting.colorBgrnd)
            let stackSlider = UIStackView(arrangedSubviews: [stackLabel, slider])
            stack = stackSlider
        default:
            slider = delaySlider()
            stackLabel = createImageSliderStack(tag: tag, colorTint: setting.colorTint, colorBgrnd: setting.colorBgrnd)
            let stackSlider = UIStackView(arrangedSubviews: [slider, stackLabel])
            stack = stackSlider
        }
        slider.thumbTintColor = setting.colorBgrnd
        slider.minimumTrackTintColor = setting.colorTint
        slider.isContinuous = true
        
        stack.axis = .vertical
        stack.spacing = 0
        stack.distribution = UIStackView.Distribution.fillEqually
        stack.backgroundColor = setting.colorBgrnd
        
        return stack
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
    
    private func createImageView(name: String, colorTint: UIColor, colorBgrnd: UIColor) -> UIImageView {
        let image = UIImage(systemName: name)
        let imageView = UIImageView(frame: CGRect(
            x: 0,
            y: 0,
            width: 50,
            height: 50))
        imageView.image = image
        
        imageView.backgroundColor = colorBgrnd
        imageView.tintColor = colorTint
        return imageView
    }
    
    
    

    
    private func volumeLabel(font: String, size: CGFloat, colorText: UIColor, colorBgrnd: UIColor) -> UIStackView {

        let minLabel = createLabel(
            title: "0 ДБ",
            font: font,
            size: size,
            colorText: colorText,
            colorBgrnd: colorBgrnd
        )
        let maxLabel = createLabel(
            title: "50 ДБ",
            font: font,
            size: size,
            colorText: colorText,
            colorBgrnd: colorBgrnd
        )
        minLabel.textAlignment = .left
        maxLabel.textAlignment = .right
        let stack = UIStackView(arrangedSubviews: [minLabel, maxLabel])
        stack.axis = .horizontal
        stack.spacing = 5
        stack.distribution = UIStackView.Distribution.fillEqually
        stack.backgroundColor = colorBgrnd
        return stack
    }
    
    
    
    private func createImageSliderStack(tag: Int, colorTint: UIColor, colorBgrnd: UIColor) -> UIStackView {
        let sliderImage = EffectSliderImage.getEffectSliderImage()
        let min = sliderImage[tag].minImage
        let max = sliderImage[tag].maxImage
        let minImage = createImageView(name: min, colorTint: colorTint, colorBgrnd: colorBgrnd)
        let maxImage = createImageView(name: max, colorTint: colorTint, colorBgrnd: colorBgrnd)
        minImage.contentMode = .left
        maxImage.contentMode = .right
        
        let stack = UIStackView(arrangedSubviews: [minImage, maxImage])
        stack.axis = .horizontal
        stack.spacing = 5
        stack.distribution = UIStackView.Distribution.fillEqually
        stack.backgroundColor = colorBgrnd
        return stack
    }
}


// MARK: - slider parametrs
extension SliderEffectView {
    
    private func volumeSlider() -> UISlider {
        let slider = UISlider()
        slider.minimumValue = 0
        slider.maximumValue = 50
        slider.value = 20
        return slider
    }
    
    private func delaySlider() -> UISlider {
        let slider = UISlider()
        slider.minimumValue = 0
        slider.maximumValue = 2
        slider.value = 1
        return slider
    }
    
}
