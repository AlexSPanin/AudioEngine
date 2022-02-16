//
//  NavigationEffectView.swift
//  AudioEngine
//
//  Created by Александр Панин on 13.02.2022.
//

import UIKit

class SliderEffectView {
    
    static var shared = SliderEffectView()
    private init() {}
    
    func getSlidersEffect(_ tag: Int) -> UISlider {
        let typeSliders = EffectSliderValue.getEffectSliderValue()
        guard let index = typeSliders.firstIndex(where: { $0.tag == tag }) else { return UISlider() }
        let type = typeSliders[index]
        let slider = createSlider(tag: type.tag ,track: type.track, value: type.value, minimum: type.minimum, maximum: type.maximum)
        return slider
    }
    
    private func createSlider(tag: Int, track: SideTrack, value: Float, minimum: Float, maximum: Float) -> UISlider {
        let setting = Setting.getSetting()
        let slider = UISlider()
        slider.tag = tag
        slider.minimumValue = minimum
        slider.maximumValue = maximum
        slider.value = value
        slider.thumbTintColor = setting.colorBgrnd
        
        if track == .maximum {
            slider.maximumTrackTintColor = setting.colorTint
            slider.minimumTrackTintColor = setting.colorBgrnd
        } else {
            slider.minimumTrackTintColor = setting.colorTint
            slider.maximumTrackTintColor = setting.colorBgrnd
        }
        slider.isContinuous = true
       
        return slider
    }
    
    
    
    
    // функция подготовки надписи
  func createLabel(
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
    // функция подкотовки изображения для слайдера
 func createImageView(name: String, colorTint: UIColor, colorBgrnd: UIColor) -> UIImageView {
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
    
    // формирует подпись для слайдера громкость
func volumeLabel(font: String, size: CGFloat, colorText: UIColor, colorBgrnd: UIColor) -> UIStackView {

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
        minLabel.tag = 101
        maxLabel.tag = 102
        
        let stack = UIStackView(arrangedSubviews: [minLabel, maxLabel])
        stack.axis = .horizontal
        stack.spacing = 5
        stack.distribution = UIStackView.Distribution.fillEqually
        stack.backgroundColor = colorBgrnd
        return stack
    }
    
    // формирует изображения к слайдеру
 func createImageSliderStack(tag: Int, colorTint: UIColor, colorBgrnd: UIColor) -> UIStackView {
        let sliderImage = EffectSliderImage.getEffectSliderImage()
        let min = sliderImage[tag].minImage
        let max = sliderImage[tag].maxImage
        let minImage = createImageView(name: min, colorTint: colorTint, colorBgrnd: colorBgrnd)
        let maxImage = createImageView(name: max, colorTint: colorTint, colorBgrnd: colorBgrnd)
        minImage.contentMode = .left
        maxImage.contentMode = .right
     minImage.tag = 201
     maxImage.tag = 202
        let stack = UIStackView(arrangedSubviews: [minImage, maxImage])
        stack.axis = .horizontal
        stack.spacing = 5
        stack.distribution = UIStackView.Distribution.fillEqually
        stack.backgroundColor = colorBgrnd
        return stack
    }
}

//        switch tag {
//
//        case 0:
//            return stack
//        case 1:
//            slider = volumeSlider()
//            stackLabel = volumeLabel(
//                font: setting.nameFont, size: setting.normalSize,
//                colorText: setting.colorLabel, colorBgrnd: setting.colorBgrnd)
//            let stackSlider = UIStackView(arrangedSubviews: [stackLabel, slider])
//            stack = stackSlider
//        default:
//            slider = delaySlider()
//            stackLabel = createImageSliderStack(tag: tag, colorTint: setting.colorTint, colorBgrnd: setting.colorBgrnd)
//            let stackSlider = UIStackView(arrangedSubviews: [slider, stackLabel])
//            stack = stackSlider
//        }
