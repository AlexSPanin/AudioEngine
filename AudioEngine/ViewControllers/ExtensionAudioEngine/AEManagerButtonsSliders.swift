//
//  AEManagerButtonsSliders.swift
//  AudioEngine
//
//  Created by Александр Панин on 21.02.2022.
//

import UIKit

extension AudioEngineViewController {
    
    // MARK: - обработка кнопок плеера
    
    @objc func pressEffectButtons(_ sender: UIButton) {
        guard let type = ButtonsEffect(rawValue: sender.tag) else { return }

        switch type {
        case .exit:
            hiddenEffectView()
        case .volume:
            typeButtosEffect = .volume
            setupColorButtonPressedEffect(track: activeEffectNode, type: typeButtosEffect)
            return
        case .eq:
            typeButtosEffect = .eq
            setupColorButtonPressedEffect(track: activeEffectNode, type: typeButtosEffect)
            return
        case .reverb:
            typeButtosEffect = .reverb
            setupColorButtonPressedEffect(track: activeEffectNode, type: typeButtosEffect)
            return
        case .delay:
            typeButtosEffect = .delay
            setupColorButtonPressedEffect(track: activeEffectNode, type: typeButtosEffect)
            return
        }
    }
    
    @objc func pressEditorButtons(_ sender: UIButton) {
        guard let type = ButtonsEditor(rawValue: sender.tag) else { return }
        switch type {
        case .effect:
            viewEffect.isHidden = false
        case .copy:
            return
        case .cut:
            return
        case .off:
            return
        case .on:
            return
        case .trash:
            return
        }
    }
    
    // MARK: - обработка кнопок эффектов
    
    @objc func pressPlayerButtons(_ sender: UIButton) {
        guard let type = ButtonsPlayer(rawValue: sender.tag) else { return }
        
        switch type {
        case .gobackward:
            return
        case .backward:
            return
        case .play:
            playButton()
        case .forward:
            return
        case .goforward:
            return
        }
    }
    
    // MARK: - обработка слайдера
    // сохранение значений в массиве и передача данных в функции установок значений
    @objc func turnEffectSlider(_ sender: UISlider) {
        switch typeButtosEffect {
        case .exit:
            return
        case .volume:
            tracksSlidersValue[activeEffectNode].slidersValue.volume = sender.value
        case .eq:
            tracksSlidersValue[activeEffectNode].slidersValue.eq = sender.value
        case .reverb:
            tracksSlidersValue[activeEffectNode].slidersValue.reverb = sender.value
        case .delay:
            tracksSlidersValue[activeEffectNode].slidersValue.delay = sender.value
        }
        setupEffectValue()
    }
    // менеджер передачи значений типа сладера в функцию устанок значений
    func setupEffectValue() {
        switch typeButtosEffect {
        case .exit:
            return
        case .volume:
            editingVolume(tracksSlidersValue[activeEffectNode].slidersValue.volume)
        case .eq:
            editingEQ(tracksSlidersValue[activeEffectNode].slidersValue.eq)
        case .reverb:
            editingReverb(tracksSlidersValue[activeEffectNode].slidersValue.reverb)
        case .delay:
            editingDelay(tracksSlidersValue[activeEffectNode].slidersValue.delay)
        }
    }
    // установка громкости
    func editingVolume(_ value: Float) {
        switch activeEffectNode {
        case 0:
            audioPlayerNode1.volume = value
        case 1:
            audioPlayerNode2.volume = value
        case 2:
            audioPlayerNode3.volume = value
        default:
            print("Default Volume")
            return
        }
    }
    // установка среза низкой частоты
    func editingEQ(_ value: Float) {
        switch activeEffectNode {
        case 0:
            let bands = equalizer1.bands
            bands[0].frequency = value * value * value / 10 // гипербола значений обработки частоты и положения слайдера
        case 1:
            let bands = equalizer2.bands
            bands[0].frequency = value * value
        case 2:
            let bands = equalizer3.bands
            bands[0].frequency = value * value
        default:
            print("Default EQ")
            return
        }
    }
    // установка объемного эффекта
    func editingReverb(_ value: Float) {
        switch activeEffectNode {
        case 0:
            reverb1.wetDryMix = value
        case 1:
            reverb2.wetDryMix = value
        case 2:
            reverb3.wetDryMix = value
        default:
            print("Default Reverb")
            return
        }
    }
    // установка времени задержки для эха
    func editingDelay(_ value: Float) {
        switch activeEffectNode {
        case 0:
            delayEcho1.delayTime = Double(value)
        case 1:
            delayEcho2.delayTime = Double(value)
        case 2:
            delayEcho3.delayTime = Double(value)
        default:
            print("Default Delay")
            return
        }
    }
}
