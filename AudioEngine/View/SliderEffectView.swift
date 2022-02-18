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
    
    func getSlidersEffect(_ type: ButtonsEffect) -> UISlider {
        let typeSliders = EffectSliderValue.getEffectSliderValue()
        let index = type.rawValue
        let type = typeSliders[index]
        let slider = createSlider(track: type.track, value: type.value, minimum: type.minimum, maximum: type.maximum)
        return slider
    }
    
    // функция подготовки надписи
    func getLabelsEffect(_ type: ButtonsEffect) -> [UILabel] {
        var labels: [UILabel] = []
        if type == .volume {
            let setting = Setting.getSetting()
            let minLabel = createLabel(
                title: "0 ДБ", font: setting.nameFont, size: setting.normalSize,
                colorText: setting.colorLabel, colorBgrnd: setting.colorBgrnd
            )
            let maxLabel = createLabel(
                title: "50 ДБ", font: setting.nameFont, size: setting.normalSize,
                colorText: setting.colorLabel, colorBgrnd: setting.colorBgrnd
            )
            minLabel.textAlignment = .left
            maxLabel.textAlignment = .right
            labels.append(minLabel)
            labels.append(maxLabel)
        }
        return labels
    }
    
    // формирует изображения к слайдеру
    func getImagesEffect(_ type: ButtonsEffect) -> [UIImageView] {
        let index = type.rawValue
        var images: [UIImageView] = []
        let setting = Setting.getSetting()
        let sliderImage = EffectSliderImage.getEffectSliderImage()
        
        let min = sliderImage[index].minImage
        let max = sliderImage[index].maxImage
        let minImage = createImageView(name: min, colorTint: setting.colorTint, colorBgrnd: setting.colorBgrnd)
        let maxImage = createImageView(name: max, colorTint: setting.colorTint, colorBgrnd: setting.colorBgrnd)
        minImage.contentMode = .left
        maxImage.contentMode = .right
        images.append(minImage)
        images.append(maxImage)
        return images
    }
    
    //MARK: - create slider, label, button
    
    private func createSlider(track: SideTrack, value: Float, minimum: Float, maximum: Float) -> UISlider {
        let setting = Setting.getSetting()
        let slider = UISlider()
        
        slider.minimumValue = minimum
        slider.maximumValue = maximum
        slider.value = value
        slider.thumbTintColor = setting.colorBgrnd
        slider.backgroundColor = setting.colorBgrnd
        
        if track == .maximum {
            slider.maximumTrackTintColor = setting.colorTint
            slider.minimumTrackTintColor = setting.colorPressedButtonEffect
        } else {
            slider.minimumTrackTintColor = setting.colorTint
            slider.maximumTrackTintColor = setting.colorPressedButtonEffect
        }
        slider.isContinuous = true
        return slider
    }
    
    private func createLabel( title: String, font: String, size: CGFloat, colorText: UIColor, colorBgrnd: UIColor) -> UILabel {
        
        let label = UILabel()
        guard let font = UIFont(name: font, size: size) else {return label }
        label.font = font
        label.textColor = colorText
        label.backgroundColor = colorBgrnd
        label.minimumScaleFactor = 0.5
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
        label.text = title
        return label
    }
    
    private func createImageView(name: String, colorTint: UIColor, colorBgrnd: UIColor) -> UIImageView {
        let image = UIImage(systemName: name)
        let imageView = UIImageView(frame: Setting.getSetting().sizeImageButton)
        imageView.image = image
        imageView.backgroundColor = colorBgrnd
        imageView.tintColor = colorTint
        return imageView
    }
}

