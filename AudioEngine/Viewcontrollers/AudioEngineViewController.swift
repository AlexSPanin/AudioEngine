//
//  AudioEngineViewController.swift
//  AudioEngine
//
//  Created by Александр Панин on 02.02.2022.
//

import UIKit
import AVFoundation



class AudioEngineViewController: UIViewController {
    
    
    
    
  
    var audioFile: AVAudioFile?
    let audioEngine = AVAudioEngine()
    let audioMixer = AVAudioMixerNode()
    let micMixer = AVAudioMixerNode()
    let reverb = AVAudioUnitReverb()
    let delayEcho = AVAudioUnitDelay()
    let audioPlayerNode = AVAudioPlayerNode()
    let equalizer = AVAudioUnitEQ(numberOfBands: 1)
    
    
    
    var audioLengthSamples: Int?
    var audioSampleRate: Double?
    var audioLengthSeconds: Double?
    
    var isPlaying: Bool = false
    var isPlayerReady: Bool?
    var needsFileScheduled = true
    var seekFrame: Double?
    
    
    
    let music = Music.getMusic()
    let setting = Setting.getSetting()
    
    
   // элементы интерфейса
    var buttonsPlayer: [UIButton] = []
    var buttonsEffect: [UIButton] = []
    var labelsEffect: [UILabel] = []
    var slidersEffect = UISlider()
    var slidersTextEffect: [UILabel] = []
    var slidersImageEffect: [UIImageView] = []
    
    var stackPlayer = UIStackView()
    var stackEffectButton = UIStackView()
    var stackEffectLabel = UIStackView()
    var stackEffectSlider = UIStackView()
    var stackEffectText = UIStackView()
    var stackEffectImage = UIStackView()
    var stackEffect = UIStackView()
    
    
    // управление слайдерами
    var sliderValue: [Float] = []
    var tag: Int = 1 {
        didSet {
            print(tag)
        }
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSlidersValue()
        
        setupButtonsPlayer()
        setupSladerEffect(tag)
        setupButtonsEffect()
        setupLabelEffect()
        
        setupColorButtonPressedEffect(tag)
        
        setupEffectValue()
        setupAudio(music[0])
        
    }
    
  
    @objc func turnEffectSlider(_ sender: UISlider) {
        sliderValue[tag] = sender.value
        print(sender.value)
        setupEffectValue()
    }
    

    func playButton() {
        
        playOrPause()
    }
    
    func setupEffectValue() {
        equalizer.globalGain = 0
        let bands = equalizer.bands
        bands[0].filterType = .bandPass
        bands[0].frequency = 5000
        
        
            editingVolume(sliderValue[1])
            editingEQ(sliderValue[2])
            editingReverb(sliderValue[3])
            editingDelay(sliderValue[4])
        
    }
    
    
    
    func editingVolume(_ value: Float) {
        audioPlayerNode.volume = value
    }
    
    
    func editingDelay(_ value: Float) {
        delayEcho.delayTime = Double(value)
    }
    
    func editingReverb(_ value: Float) {
        let index = Int(round(value + 0.5))
        switch index {
        case 0:
            reverb.loadFactoryPreset(.smallRoom)
        case 1:
            reverb.loadFactoryPreset(.mediumRoom)
        case 2:
            reverb.loadFactoryPreset(.largeRoom)
        case 3:
            reverb.loadFactoryPreset(.mediumHall)
        case 4:
            reverb.loadFactoryPreset(.plate)
        case 5:
            reverb.loadFactoryPreset(.mediumChamber)
        default:
            reverb.loadFactoryPreset(.cathedral)
        }
    }
    
    func editingEQ(_ value: Float) {
        let bands = equalizer.bands
        bands[0].bandwidth = value
    }
    
    func setupAudio(_ music: Music) {
        guard let url = Bundle.main.url(forResource: music.name, withExtension: music.format) else { return }
        do {
            let file = try AVAudioFile(forReading: url)
            let format = file.processingFormat
            
            audioLengthSamples = Int(file.length)
            audioSampleRate = format.sampleRate
            audioLengthSeconds = Double(audioLengthSamples ?? 0) / (audioSampleRate ?? 1)
            audioFile = file
            
            configureEngine(format)
            
        } catch {
            print("error Setup Audio")
        }
    }
    
    func configureEngine(_ format: AVAudioFormat) {
        // Attach the nodes
        audioEngine.attach(audioPlayerNode)
        audioEngine.attach(equalizer)
        audioEngine.attach(reverb)
        audioEngine.attach(delayEcho)
        audioEngine.attach(audioMixer)
        audioEngine.attach(micMixer)
        
        audioEngine.connect(audioPlayerNode, to: equalizer, format: format)
        audioEngine.connect(audioPlayerNode, to: reverb, format: format)
        audioEngine.connect(audioPlayerNode, to: delayEcho, format: format)
        audioEngine.connect(equalizer, to: audioMixer, format: format)
        audioEngine.connect(reverb, to: audioMixer, format: format)
        audioEngine.connect(delayEcho, to: audioMixer, format: format)
        audioEngine.connect(audioMixer, to: audioEngine.outputNode, format: format)
        
        
      /*
        // Connect the nodes
        
        audioEngine.connect(audioMixer, to: audioEngine.mainMixerNode, format: format)
        audioEngine.connect(delayEcho, to: audioMixer, fromBus: 0, toBus: 0, format: format)
        audioEngine.connect(reverb, to: audioMixer, fromBus: 0, toBus: 0, format: format)
        audioEngine.connect(equalizer, to: audioMixer, fromBus: 0, toBus: 0, format: format)
        audioEngine.connect(micMixer, to: reverb, format: format)
        
        // Здесь мы делаем несколько выходных соединений с узла плеера
        // 1) с основным микшером и
        // 2) с другим узлом микшера, который мы используем для добавления эффектов.
       let playerConnectionPoints = [
            AVAudioConnectionPoint(node: audioEngine.mainMixerNode, bus: 0),
            AVAudioConnectionPoint(node: audioMixer, bus: 1)
      ]
        
       audioEngine.connect(audioPlayerNode, to: playerConnectionPoints, fromBus: 0, format: format)
        
        // Наконец-то установление соединения для микрофонного входа
        let micInput = audioEngine.inputNode
        let micFormat = micInput.inputFormat(forBus: 0)
        audioEngine.connect(micInput, to: micMixer, format: micFormat)
      */
        
        
        audioEngine.prepare()
        
        do {
            try audioEngine.start()
            scheduleAudioFile()
            isPlayerReady = true
        } catch {
            print("error configure Engine")
        }
    }
    
    func scheduleAudioFile() {
        guard let file = audioFile, needsFileScheduled else { return }
        
        needsFileScheduled = false
        seekFrame = 0
        audioPlayerNode.scheduleFile(file, at: nil) {
            self.needsFileScheduled = true
        }
    }
    
    
    
    func playOrPause() {
        
        if needsFileScheduled { scheduleAudioFile() }
        if audioPlayerNode.isPlaying {
            audioPlayerNode.pause()
            let image = UIImage(systemName: Buttons.play.rawValue)
            buttonsPlayer[2].setImage(image, for: .normal)
        } else {
            
            audioPlayerNode.play()
            let image = UIImage(systemName: Buttons.pause.rawValue)
            buttonsPlayer[2].setImage(image, for: .normal)
            
        }
        
    }
    
    
    @objc func pressEffectButtons(_ sender: UIButton) {
        
        tag = sender.tag
        setupColorButtonPressedEffect(tag)
        
        switch tag {
        case 0:
            hiddenEffectView()
        default:
            return
        }
    }
   
    @objc func pressPlayerButtons(_ sender: UIButton) {
        
        switch sender.tag {
        case 0:
            return
        case 1:
            return
        case 2:
            playButton()
        case 3:
            return
        case 4:
            return
        default:
            return
        }
    }
    
    func setupSlidersValue() {
        let slidersValueEffect = EffectSliderValue.getEffectSliderValue()
        for slider in slidersValueEffect {
            sliderValue.append(slider.value)
        }
    }
    
}


