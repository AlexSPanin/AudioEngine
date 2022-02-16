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
    let equalizer = AVAudioUnitEQ(numberOfBands: 2)
    
    
    
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
        
    }
    
    func setupSlidersValue() {
        let slidersValueEffect = EffectSliderValue.getEffectSliderValue()
        for slider in slidersValueEffect {
            sliderValue.append(slider.value)
        }
    }
    
    @objc func turnEffectSlider(_ sender: UISlider) {
        sliderValue[tag] = sender.value
        print(sender.value)
        
        
    }
    

    func playButton() {
//        pitchEffect.pitch = valuePitchEffect ?? 0
        setupAudio(music[1])
        playOrPause()
    }

    
    func editingReverb(_ slider: UISlider) {
        reverb.loadFactoryPreset(.cathedral)
        
    }
    
    func editingEQ(left: UISlider, rigth: UISlider) {
        
        equalizer.globalGain = 0
        let bands = equalizer.bands
        bands[0].filterType = .lowPass
        bands[0].frequency = left.value
        bands[1].filterType = .highPass
        bands[1].frequency = rigth.value
        
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
    private func setupColorButtonPressedEffect(_ tag: Int) {
        clearColorButtonEffect(tag)
        сhangingSettingSliderEffect(tag)
        сhangingSettingLabelEffect(tag)
        сhangingSettingImageEffect(tag)
    }
    
    @objc func pressEffectButtons(_ sender: UIButton) {
        
        tag = sender.tag
        setupColorButtonPressedEffect(tag)
        
        
        switch tag {
        case 0:
            stackEffectButton.isHidden = true
            stackEffectLabel.isHidden = true
            slidersEffect.isHidden = true
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
    
    
   

    
    
    
   
}


extension AudioEngineViewController {
    
    private func setupSladerEffect(_ tag: Int) {
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
        
        
//        stackEffectLabel.axis = .horizontal
//        stackEffectLabel.spacing = 5
//        stackEffectLabel.distribution = UIStackView.Distribution.fill
//        stackEffectLabel.backgroundColor = setting.colorBgrnd
//
//
//
//        view.addSubview(stackEffectSlider)
//
//        stackEffectSlider.heightAnchor.constraint(equalToConstant: 50).isActive = true
//        stackEffectSlider.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15).isActive = true
//        stackEffectSlider.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15).isActive = true
//        stackEffectSlider.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -55).isActive = true
    }
 
    //MARK: - анимация кнопок переключения эффектов
    private func clearColorButtonEffect(_ tag: Int) {
        let setting = Setting.getSetting()
        for button in buttonsEffect {
            if button.tag != 0 {
            button.backgroundColor = button.tag == tag ? setting.colorPressedButtonEffect : setting.colorBgrnd
            labelsEffect[button.tag].backgroundColor = button.tag == tag ? setting.colorPressedButtonEffect : setting.colorBgrnd
            }
        }
    }
    
    //MARK: - изменение настроек slider в зависимости от выбранного эффекта
    private func сhangingSettingSliderEffect(_ tag: Int) {
        
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
    
    private func сhangingSettingLabelEffect(_ tag: Int) {
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
    
    private func setupButtonsPlayer() {
        
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
    
    private func setupButtonsEffect() {
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
    
    private func setupLabelEffect() {
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
    
    
    // MARK: - navigation player
  
    
    func goForward() {
        
    }
    
    func goBackward() {
        
    }
}


