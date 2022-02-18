//
//  AudioEngineViewController.swift
//  AudioEngine
//
//  Created by Александр Панин on 02.02.2022.
//

import UIKit
import AVFoundation

class AudioEngineViewController: UIViewController {
    
    // MARK: - User Interface
    // Player View
    var buttonsPlayer: [UIButton] = []
    var stackPlayer = UIStackView()
    
    // Editor View
    let viewEditor = UIView()
    var buttonsEditor: [UIButton] = []
    var stackEditor = UIStackView()
    
    
    // MARK: - Effect View
    // Effect View
    let viewEffect = UIView()
    var stackEffect = UIStackView()
    
    // Effect Buttons
    var buttonsEffect: [UIButton] = []
    var labelsEffect: [UILabel] = []
    var stackEffectButton = UIStackView()
    var stackEffectLabel = UIStackView()
    
    //Effect Sliders
    var slidersEffect = UISlider()
    var slidersTextEffect: [UILabel] = []
    var slidersImageEffect: [UIImageView] = []
    var stackEffectSlider = UIStackView()
    var stackEffectText = UIStackView()
    var stackEffectImage = UIStackView()
    
    // MARK: - AudioEngine
    // Mixer and Engine
    var audioFile: AVAudioFile?
    let audioEngine = AVAudioEngine()
    let audioMixer = AVAudioMixerNode()
    let micMixer = AVAudioMixerNode()
    
    // Node 1
    let audioPlayerNode1 = AVAudioPlayerNode()
    let reverb1 = AVAudioUnitReverb()
    let delayEcho1 = AVAudioUnitDelay()
    let equalizer1 = AVAudioUnitEQ(numberOfBands: 1)
    
    // Node 2
    let audioPlayerNode2 = AVAudioPlayerNode()
    let reverb2 = AVAudioUnitReverb()
    let delayEcho2 = AVAudioUnitDelay()
    let equalizer2 = AVAudioUnitEQ(numberOfBands: 1)
    
    // Node 3
    let audioPlayerNode3 = AVAudioPlayerNode()
    let reverb3 = AVAudioUnitReverb()
    let delayEcho3 = AVAudioUnitDelay()
    let equalizer3 = AVAudioUnitEQ(numberOfBands: 1)
    
    // MARK: - Data Songs and Settings UI and start value
    let setting = Setting.getSetting()
    var dataSongs = DataSong.getDataSong()
    var dataPlayingSong = DataPlayingSong.getDataPlayingSong()
    
    
    // MARK: - number song and start button effect
    var track: Int = 0
    var typeButtosEffect: ButtonsEffect = .volume
   
    // состояние плеера общее играет или нет
    var isPlaying: Bool = false
    
    var isHiddenEffectView: Bool = true
    // значения настроек слайдеров по песням
    var tracksSlidersValue = TrackSlidersValue.getTrackSlidersValue()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)

        setupUI(track: track, type: typeButtosEffect)
        
        setupEffectValue()
        configureEngine(dataSongs)
    }
    
    // MARK: - обработка кнопок плеера
    
    @objc func pressEffectButtons(_ sender: UIButton) {
        guard let type = ButtonsEffect(rawValue: sender.tag) else { return }

        switch type {
        case .exit:
            hiddenEffectView()
        case .volume:
            typeButtosEffect = .volume
            setupColorButtonPressedEffect(track: track, type: typeButtosEffect)
            return
        case .eq:
            typeButtosEffect = .eq
            setupColorButtonPressedEffect(track: track, type: typeButtosEffect)
            return
        case .reverb:
            typeButtosEffect = .reverb
            setupColorButtonPressedEffect(track: track, type: typeButtosEffect)
            return
        case .delay:
            typeButtosEffect = .delay
            setupColorButtonPressedEffect(track: track, type: typeButtosEffect)
            return
        }
    }
    
    @objc func pressEditorButtons(_ sender: UIButton) {
        guard let type = ButtonsEditor(rawValue: sender.tag) else { return }
        switch type {
        case .effect:
            hiddenEffectView()
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
            playButton(track)
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
            tracksSlidersValue[track].slidersValue.volume = sender.value
        case .eq:
            tracksSlidersValue[track].slidersValue.eq = sender.value
        case .reverb:
            tracksSlidersValue[track].slidersValue.reverb = sender.value
        case .delay:
            tracksSlidersValue[track].slidersValue.delay = sender.value
        }
        setupEffectValue()
    }
    // менеджер передачи значений типа сладера в функцию устанок значений
    func setupEffectValue() {
        switch typeButtosEffect {
        case .exit:
            return
        case .volume:
            editingVolume(tracksSlidersValue[track].slidersValue.volume)
        case .eq:
            editingEQ(tracksSlidersValue[track].slidersValue.eq)
        case .reverb:
            editingReverb(tracksSlidersValue[track].slidersValue.reverb)
        case .delay:
            editingDelay(tracksSlidersValue[track].slidersValue.delay)
        }
    }
    // установка громкости
    func editingVolume(_ value: Float) {
        switch track {
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
        switch track {
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
        switch track {
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
        switch track {
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
    
    //MARK: - Подготовка аудио движка
    
    func configureEngine(_ dataSongs: [DataSong]) {
        // setting start value effect
        configureSetupEffect()
        let dataSongs = dataSongs
        let audioFormat1 = dataSongs[0].audioFormat
        let audioFormat2 = dataSongs[1].audioFormat
        let audioFormat3 = dataSongs[2].audioFormat
        
        // MARK: - Attach the nodes
        
        // Node1
        audioEngine.attach(audioPlayerNode1)
        audioEngine.attach(delayEcho1)
        audioEngine.attach(reverb1)
        audioEngine.attach(equalizer1)
        
        // Node2
        audioEngine.attach(audioPlayerNode2)
        audioEngine.attach(delayEcho2)
        audioEngine.attach(reverb2)
        audioEngine.attach(equalizer2)
        
        // Node3
        audioEngine.attach(audioPlayerNode3)
        audioEngine.attach(delayEcho3)
        audioEngine.attach(reverb3)
        audioEngine.attach(equalizer3)
        
        // Mixer and microfon Mixer
        audioEngine.attach(audioMixer)
        audioEngine.attach(micMixer)
        
        // MARK: - connect Node
        
        // Node1
        audioEngine.connect(audioPlayerNode1, to: delayEcho1, format: audioFormat1)
        audioEngine.connect(delayEcho1, to: reverb1, format: audioFormat1)
        audioEngine.connect(reverb1, to: equalizer1, format: audioFormat1)
        audioEngine.connect(equalizer1, to: audioEngine.mainMixerNode, fromBus: 0, toBus: 0, format: audioFormat1)
        // Node2
        audioEngine.connect(audioPlayerNode2, to: delayEcho2, format: audioFormat2)
        audioEngine.connect(delayEcho2, to: reverb2, format: audioFormat2)
        audioEngine.connect(reverb2, to: equalizer2, format: audioFormat2)
        audioEngine.connect(equalizer2, to: audioEngine.mainMixerNode, fromBus: 0, toBus: 1, format: audioFormat2)
        // Node3
        audioEngine.connect(audioPlayerNode3, to: delayEcho3, format: audioFormat3)
        audioEngine.connect(delayEcho3, to: reverb3, format: audioFormat3)
        audioEngine.connect(reverb3, to: equalizer3, format: audioFormat3)
        audioEngine.connect(equalizer3, to: audioEngine.mainMixerNode, fromBus: 0, toBus: 2, format: audioFormat3)
        // монтирование движка
        audioEngine.prepare()
        // старт движка и монтирование аудифайлов
        do {
            try audioEngine.start()
            for track in 0...2 {
                scheduleAudioFile(track)
            }
        } catch {
            print("error configure Engine")
        }
    }
    
        // MARK: - create audio file and setting sign for ready play
    func scheduleAudioFile(_ track: Int) {
        let audioFile = dataSongs[track].file
        if dataPlayingSong[track].needsFileScheduled {
            switch track {
            case 0:
                audioPlayerNode1.scheduleFile(audioFile, at: nil)
            case 1:
                audioPlayerNode2.scheduleFile(audioFile, at: nil)
            case 2:
                audioPlayerNode3.scheduleFile(audioFile, at: nil)
            default:
                print("Default Schedule Audio File")
                return
            }
        }
        dataPlayingSong[track].needsFileScheduled.toggle()
        dataPlayingSong[track].isPlayerReady.toggle()
    }
    
    // MARK: -  запуск воспроизведения или пауза
    
    func playButton(_ track: Int) {
        
        
        if dataPlayingSong[track].needsFileScheduled { scheduleAudioFile(track) }
        
        if isPlaying {
            switch track {
            case 0:
                audioPlayerNode1.pause()
            case 1:
                audioPlayerNode2.pause()
            case 2:
                audioPlayerNode3.pause()
            default:
                print("Default Pause Player")
                return
            }
        } else {
            switch track {
            case 0:
                audioPlayerNode1.play()
            case 1:
                audioPlayerNode2.play()
            case 2:
                audioPlayerNode3.play()
            default:
                print("Default Play Player")
                return
            }
        }
        isPlaying.toggle()
        changeImageButtonPlayPause(isPlaying)
    }
    
    //MARK: -  первоначальные настройки эффектов по 3 нодам
    
    func configureSetupEffect() {
        delayEcho1.delayTime = 0
        reverb1.loadFactoryPreset(.largeHall)
        
        let bands1 = equalizer1.bands
        bands1[0].frequency = 0
        bands1[0].filterType = .highPass
        bands1[0].bypass = false
        
        delayEcho2.delayTime = 0
        reverb2.loadFactoryPreset(.largeHall)
        
        let bands2 = equalizer2.bands
        bands2[0].frequency = 0
        bands2[0].filterType = .highPass
        bands2[0].bypass = false
        
        delayEcho3.delayTime = 0
        reverb3.loadFactoryPreset(.largeHall)
        
        let bands3 = equalizer3.bands
        bands3[0].frequency = 0
        bands3[0].filterType = .highPass
        bands3[0].bypass = false
    }
}


