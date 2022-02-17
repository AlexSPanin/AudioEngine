//
//  AESetupView.swift
//  AudioEngine
//
//  Created by Александр Панин on 17.02.2022.
//

import UIKit

extension AudioEngineViewController {
    
    func setupUI(_ tag: Int) {
        setupButtonsPlayer()
        setupSladerEffect(tag)
        setupButtonsEffect()
        setupLabelEffect()
        setupColorButtonPressedEffect(tag)
    }
    
    func setupSladerEffect(_ tag: Int) {
        slidersEffect = SliderEffectView.shared.getSlidersEffect(tag)
        slidersEffect.addTarget(self, action: #selector(turnEffectSlider), for: .allTouchEvents)
        
        slidersTextEffect = SliderEffectView.shared.getLabelsEffect(tag)
        stackEffectText = UIStackView(arrangedSubviews: slidersTextEffect)
        stackEffectText.axis = .horizontal
        stackEffectText.spacing = 0
        stackEffectText.distribution = UIStackView.Distribution.fillEqually
        
        slidersImageEffect = SliderEffectView.shared.getImagesEffect(tag)
        stackEffectImage = UIStackView(arrangedSubviews: slidersImageEffect)
        stackEffectImage.axis = .horizontal
        stackEffectImage.spacing = 0
        stackEffectImage.distribution = UIStackView.Distribution.fillEqually
        
        stackEffect = UIStackView(arrangedSubviews: [stackEffectText, slidersEffect, stackEffectImage])
        
        stackEffect.axis = .vertical
        stackEffect.spacing = 0
        stackEffect.distribution = UIStackView.Distribution.fillEqually
        
        view.addSubview(stackEffect)
        
        stackEffect.translatesAutoresizingMaskIntoConstraints = false
        stackEffect.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15).isActive = true
        stackEffect.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15).isActive = true
        stackEffect.bottomAnchor.constraint(equalTo: stackPlayer.topAnchor).isActive = true
    }
    
    //MARK: - анимация кнопок переключения эффектов
    func clearColorButtonEffect(_ tag: Int) {
        let setting = Setting.getSetting()
        for button in buttonsEffect {
            if button.tag != 0 {
                button.backgroundColor = button.tag == tag ? setting.colorPressedButtonEffect : setting.colorBgrnd
                labelsEffect[button.tag].backgroundColor = button.tag == tag ? setting.colorPressedButtonEffect : setting.colorBgrnd
            }
        }
    }
    
    //MARK: - изменение настроек slider в зависимости от выбранного эффекта
    func сhangingSettingSliderEffect(_ tag: Int) {
        
        let setting = Setting.getSetting()
        let typeSliders = EffectSliderValue.getEffectSliderValue()
        
        guard let indexValue = typeSliders.firstIndex(where: { $0.tag == tag }) else { return }
        let typeSlider = typeSliders[indexValue]
        
        slidersEffect.minimumValue = typeSlider.minimum
        slidersEffect.maximumValue = typeSlider.maximum
        slidersEffect.value = sliderValue[tag]
        slidersEffect.thumbTintColor = setting.colorBgrnd
        
        if typeSlider.track == .maximum {
            slidersEffect.maximumTrackTintColor = setting.colorTint
            slidersEffect.minimumTrackTintColor = setting.colorPressedButtonEffect
        } else {
            slidersEffect.minimumTrackTintColor = setting.colorTint
            slidersEffect.maximumTrackTintColor = setting.colorPressedButtonEffect
        }
        slidersEffect.isContinuous = true
    }
    
    func сhangingSettingLabelEffect(_ tag: Int) {
        let typeLabels = EffectSliderLabel.getEffectSliderLabel()
        
        guard let indexLabel = typeLabels.firstIndex(where: { $0.tag == tag }) else { return }
        let typeLabel = typeLabels[indexLabel]
        slidersTextEffect[0].text = typeLabel.minLabel
        slidersTextEffect[1].text = typeLabel.maxLabel
    }
    
    private func сhangingSettingImageEffect(_ tag: Int) {
        let typeImages = EffectSliderImage.getEffectSliderImage()
        guard let indexImage = typeImages.firstIndex(where: { $0.tag == tag }) else { return }
        let typeImage = typeImages[indexImage]
        slidersImageEffect[0].image = UIImage(systemName: typeImage.minImage)
        slidersImageEffect[1].image = UIImage(systemName: typeImage.maxImage)
    }
    
    //MARK: - setup Buttons for Player
    
    func setupButtonsPlayer() {
        
        let height = view.bounds.width / 8
        buttonsPlayer = ButtonPlayerView.shared.getButtonsPlayer()
        for button in buttonsPlayer {
            button.addTarget(self, action: #selector(pressPlayerButtons), for: .touchDown)
        }
        stackPlayer = UIStackView(arrangedSubviews: buttonsPlayer)
        
        stackPlayer.axis = .horizontal
        stackPlayer.spacing = 5
        stackPlayer.distribution = UIStackView.Distribution.fillEqually
        stackPlayer.backgroundColor = setting.colorBrgndPlayerButton
        
        view.addSubview(stackPlayer )
        
        stackPlayer.translatesAutoresizingMaskIntoConstraints = false
        stackPlayer.heightAnchor.constraint(equalToConstant: height).isActive = true
        stackPlayer.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        stackPlayer.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        stackPlayer.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    //MARK: - setup Buttons and names for Labels Buttons for Effect
    
    func setupButtonsEffect() {
        let setting = Setting.getSetting()
        buttonsEffect = ButtonEffectView.shared.getButtonEffect()
        
        for button in buttonsEffect {
            button.addTarget(self, action: #selector(pressEffectButtons), for: .touchDown)
        }
        
        stackEffectButton = UIStackView(arrangedSubviews: buttonsEffect)
        
        stackEffectButton.axis = .horizontal
        stackEffectButton.spacing = 5
        stackEffectButton.distribution = UIStackView.Distribution.fillEqually
        stackEffectButton.backgroundColor = setting.colorBgrnd
        
        view.addSubview(stackEffectButton)
        
        stackEffectButton.translatesAutoresizingMaskIntoConstraints = false
        
        stackEffectButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15).isActive = true
        stackEffectButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15).isActive = true
        stackEffectButton.bottomAnchor.constraint(equalTo: stackEffect.topAnchor, constant: -10).isActive = true
    }
    
    func setupLabelEffect() {
        let setting = Setting.getSetting()
        labelsEffect = ButtonEffectView.shared.getLabelEffect()
        stackEffectLabel = UIStackView(arrangedSubviews: labelsEffect)
        
        stackEffectLabel.axis = .horizontal
        stackEffectLabel.spacing = 5
        stackEffectLabel.distribution = UIStackView.Distribution.fillEqually
        stackEffectLabel.backgroundColor = setting.colorBgrnd
        
        view.addSubview(stackEffectLabel)
        
        stackEffectLabel.translatesAutoresizingMaskIntoConstraints = false
        
        stackEffectLabel.topAnchor.constraint(equalTo: stackEffectButton.bottomAnchor).isActive = true
        stackEffectLabel.rightAnchor.constraint(equalTo: stackEffectButton.rightAnchor).isActive = true
        stackEffectLabel.leftAnchor.constraint(equalTo: stackEffectButton.leftAnchor).isActive = true
    }
    
    func setupColorButtonPressedEffect(_ tag: Int) {
        clearColorButtonEffect(tag)
        сhangingSettingSliderEffect(tag)
        сhangingSettingLabelEffect(tag)
        сhangingSettingImageEffect(tag)
    }
    
    func hiddenEffectView() {
        stackEffectButton.isHidden = true
        stackEffectLabel.isHidden = true
        slidersEffect.isHidden = true
    }
    
 
}



