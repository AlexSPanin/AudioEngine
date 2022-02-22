//
//  AESetupView.swift
//  AudioEngine
//
//  Created by Александр Панин on 17.02.2022.
//

import UIKit

extension AudioEngineViewController {
    
    
    func setupUI(track: Int, type: ButtonsEffect) {
        createViewEditor()
        createViewEffect()
        
        setupButtonsPlayer()
        setupButtonsEditor()
        setupButtonsEffect()
        setupLabelEffect()
        setupSladerEffect(type)
        
        setupColorButtonPressedEffect(track: track, type: type)
       hiddenEffectView()
    }
    
    // MARK: -  white subview for effect (надо в дальнейшем завести весь интерфес эффектов на него)
    
    func createViewEffect() {
        viewEffect.backgroundColor = setting.colorBgrnd
        viewEffect.layer.cornerRadius = 5
        
        view.addSubview(viewEffect)
        
        viewEffect.translatesAutoresizingMaskIntoConstraints = false
        viewEffect.heightAnchor.constraint(equalToConstant: 150).isActive = true
        viewEffect.rightAnchor.constraint(equalTo: viewEditor.rightAnchor).isActive = true
        viewEffect.leftAnchor.constraint(equalTo: viewEditor.leftAnchor).isActive = true
        viewEffect.bottomAnchor.constraint(equalTo: viewEditor.topAnchor, constant: 5).isActive = true
    }
    //MARK: - setup Buttons and names for Labels Buttons for Effect
    // установка меню кнопок эффектов
    func setupButtonsEffect() {
        let height: CGFloat = 37
        buttonsEffect = ButtonEffectView.shared.getButtonEffect()
        for button in buttonsEffect {
            button.addTarget(self, action: #selector(pressEffectButtons), for: .touchDown)
        }
        stackEffectButton = UIStackView(arrangedSubviews: buttonsEffect)
        
        stackEffectButton.axis = .horizontal
        stackEffectButton.spacing = 8
        stackEffectButton.distribution = UIStackView.Distribution.fillEqually
        stackEffectButton.backgroundColor = setting.colorBgrnd
        
        viewEffect.addSubview(stackEffectButton)
        
        stackEffectButton.translatesAutoresizingMaskIntoConstraints = false
        
        stackEffectButton.heightAnchor.constraint(equalToConstant: height).isActive = true
        stackEffectButton.leftAnchor.constraint(equalTo: viewEffect.leftAnchor, constant: 15).isActive = true
        stackEffectButton.rightAnchor.constraint(equalTo: viewEffect.rightAnchor, constant: -15).isActive = true
        stackEffectButton.topAnchor.constraint(equalTo: viewEffect.topAnchor, constant: 15).isActive = true
    }
    
    // установка подписей к кнопкам эффектов
    func setupLabelEffect() {
        let setting = Setting.getSetting()
        labelsEffect = ButtonEffectView.shared.getLabelEffect()
        stackEffectLabel = UIStackView(arrangedSubviews: labelsEffect)
        
        stackEffectLabel.axis = .horizontal
        stackEffectLabel.spacing = 8
        stackEffectLabel.distribution = UIStackView.Distribution.fillEqually
        stackEffectLabel.backgroundColor = setting.colorBgrnd
        
        viewEffect.addSubview(stackEffectLabel)
        
        stackEffectLabel.translatesAutoresizingMaskIntoConstraints = false
        
        stackEffectLabel.leftAnchor.constraint(equalTo: stackEffectButton.leftAnchor).isActive = true
        stackEffectLabel.rightAnchor.constraint(equalTo: stackEffectButton.rightAnchor).isActive = true
        stackEffectLabel.topAnchor.constraint(equalTo: stackEffectButton.bottomAnchor).isActive = true
    }
    
    // MARK: - установка блока слайдера (текст, слайдер, изображение)
    
    func setupSladerEffect(_ type: ButtonsEffect) {
        slidersEffect = SliderEffectView.shared.getSlidersEffect(type)
        slidersEffect.addTarget(self, action: #selector(turnEffectSlider), for: .allTouchEvents)
        
        slidersTextEffect = SliderEffectView.shared.getLabelsEffect(type)
        stackEffectText = UIStackView(arrangedSubviews: slidersTextEffect)
        stackEffectText.axis = .horizontal
        stackEffectText.spacing = 0
        stackEffectText.distribution = UIStackView.Distribution.fillEqually
        
        slidersImageEffect = SliderEffectView.shared.getImagesEffect(type)
        stackEffectImage = UIStackView(arrangedSubviews: slidersImageEffect)
        stackEffectImage.axis = .horizontal
        stackEffectImage.spacing = 0
        stackEffectImage.distribution = UIStackView.Distribution.fillEqually
        
        stackEffect = UIStackView(arrangedSubviews: [stackEffectText, slidersEffect, stackEffectImage])
        
        stackEffect.axis = .vertical
        stackEffect.spacing = 0
        stackEffect.distribution = UIStackView.Distribution.fillEqually
        
        viewEffect.addSubview(stackEffect)
        
        stackEffect.translatesAutoresizingMaskIntoConstraints = false
        
        stackEffect.leftAnchor.constraint(equalTo: viewEffect.leftAnchor, constant: 15).isActive = true
        stackEffect.rightAnchor.constraint(equalTo: viewEffect.rightAnchor, constant: -15).isActive = true
        stackEffect.topAnchor.constraint(equalTo: stackEffectLabel.bottomAnchor, constant: 2).isActive = true
    }
    
    //MARK: - анимация кнопок переключения эффектов
    
    func clearColorButtonEffect(_ type: ButtonsEffect) {
        let type = type.rawValue
        let setting = Setting.getSetting()
        for button in buttonsEffect {
            if button.tag != 0 {
                button.backgroundColor = button.tag == type ? setting.colorPressedButtonEffect : setting.colorBgrnd
                labelsEffect[button.tag].backgroundColor = button.tag == type ? setting.colorPressedButtonEffect : setting.colorBgrnd
            }
        }
    }
    
    //MARK: - изменение настроек slider в зависимости от выбранного эффекта
    func сhangingSettingSliderEffect(track: Int, type: ButtonsEffect) {
        let setting = Setting.getSetting()
        let typeSliders = EffectSliderValue.getEffectSliderValue()
        let trackSliderValue = tracksSlidersValue[track].slidersValue
        let indexValue = type.rawValue
        let typeSlider = typeSliders[indexValue]
        
        slidersEffect.minimumValue = typeSlider.minimum
        slidersEffect.maximumValue = typeSlider.maximum
        slidersEffect.thumbTintColor = setting.colorBgrnd
        
        if typeSlider.track == .maximum {
            slidersEffect.maximumTrackTintColor = setting.colorTint
            slidersEffect.minimumTrackTintColor = setting.colorPressedButtonEffect
        } else {
            slidersEffect.minimumTrackTintColor = setting.colorTint
            slidersEffect.maximumTrackTintColor = setting.colorPressedButtonEffect
        }
        
        switch type {
        case .exit:
            return
        case .volume:
            slidersEffect.value = trackSliderValue.volume
        case .eq:
            slidersEffect.value = trackSliderValue.eq
        case .reverb:
            slidersEffect.value = trackSliderValue.reverb
        case .delay:
            slidersEffect.value = trackSliderValue.delay
        }
        
        slidersEffect.isContinuous = true
    }
    // смена подписей у слайдера
    func сhangingSettingLabelEffect(_ type: ButtonsEffect) {
        let typeLabels = EffectSliderLabel.getEffectSliderLabel()
        let indexLabel = type.rawValue
        let typeLabel = typeLabels[indexLabel]
        slidersTextEffect[0].text = typeLabel.minLabel
        slidersTextEffect[1].text = typeLabel.maxLabel
    }
    // смена изображений у слайдера
    private func сhangingSettingImageEffect(_ type: ButtonsEffect) {
        let typeImages = EffectSliderImage.getEffectSliderImage()
        let indexImage = type.rawValue
        let typeImage = typeImages[indexImage]
        slidersImageEffect[0].image = UIImage(systemName: typeImage.minImage)
        slidersImageEffect[1].image = UIImage(systemName: typeImage.maxImage)
    }
    
    //MARK: - setup Buttons for Player
    // установка кнопок плеера
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
    
    // смена вида пауза или игра проигрователя
    func changeImageButtonPlayPause(_ playOrPause: Bool) {
        if playOrPause {
            let image = UIImage(systemName: "pause")
            buttonsPlayer[2].setImage(image, for: .normal)
        } else {
            let image = UIImage(systemName: "play")
            buttonsPlayer[2].setImage(image, for: .normal)
        }
    }
    //MARK: - setup Buttons for Editor
    func createViewEditor() {
        viewEditor.backgroundColor = setting.colorBgrnd
        viewEditor.layer.cornerRadius = 5
        
        view.addSubview(viewEditor)
        
        viewEditor.translatesAutoresizingMaskIntoConstraints = false
        viewEditor.heightAnchor.constraint(equalToConstant: 120).isActive = true
        viewEditor.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        viewEditor.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        viewEditor.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    // установка кнопок редактора
    func setupButtonsEditor() {
        let height: CGFloat = 50
        buttonsEffect = ButtonEditorView.shared.getButtonsEditor()
        for button in buttonsEffect {
            button.addTarget(self, action: #selector(pressEditorButtons), for: .touchDown)
        }
        stackEditor = UIStackView(arrangedSubviews: buttonsEffect)
        
        stackEditor.axis = .horizontal
        stackEditor.spacing = 2
        stackEditor.distribution = UIStackView.Distribution.fillEqually
        stackEditor.backgroundColor = setting.colorBgrnd
        
        viewEditor.addSubview(stackEditor)
        
        stackEditor.translatesAutoresizingMaskIntoConstraints = false
        stackEditor.heightAnchor.constraint(equalToConstant: height).isActive = true
        stackEditor.leftAnchor.constraint(equalTo: viewEditor.leftAnchor, constant: 15).isActive = true
        stackEditor.rightAnchor.constraint(equalTo: viewEditor.rightAnchor, constant: -15).isActive = true
        stackEditor.topAnchor.constraint(equalTo: viewEditor.topAnchor, constant: 15).isActive = true
    }
 
    //MARK: - hidden view Effect and change color pressed button effect
    // смена цвета нажатой кнопки
    func setupColorButtonPressedEffect(track: Int, type: ButtonsEffect) {
        clearColorButtonEffect(type)
        сhangingSettingSliderEffect(track: track, type: type)
        сhangingSettingLabelEffect(type)
        сhangingSettingImageEffect(type)
    }
    
 
    
    
}



