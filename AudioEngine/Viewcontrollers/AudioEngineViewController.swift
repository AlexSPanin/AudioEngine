//
//  AudioEngineViewController.swift
//  AudioEngine
//
//  Created by Александр Панин on 02.02.2022.
//

import UIKit
import AVFoundation



class AudioEngineViewController: UIViewController {
    
    var tag = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    
    
  
    
  
    var audioFile: AVAudioFile?
    var engine = AVAudioEngine()
    var player = AVAudioPlayerNode()
    
    var pitchEffect = AVAudioUnitTimePitch()
    
    var reverbEffect = AVAudioUnitReverb()
    var delayEffect = AVAudioUnitDelay()
    
    var eqEffect = AVAudioUnitEQ(numberOfBands: 2)
    var mixMode = AVAudioMixerNode()
    
    var audioLengthSamples: Int?
    var audioSampleRate: Double?
    var audioLengthSeconds: Double?
    
    var isPlaying: Bool = false
    var isPlayerReady: Bool?
    var needsFileScheduled = true
    var seekFrame: Double?
    
    var valuePitchEffect: Float?
    
    let music = Music.getMusic()
    let setting = Setting.getSetting()
    var buttonsPlayer: [UIButton] = []
    var buttonsEffect: [UIButton] = []
    var labelsEffect: [UILabel] = []
    var slidersEffect: [UISlider] = []
    
    var stackPlayer = UIStackView()
    var stackEffectButton = UIStackView()
    var stackEffectLabel = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupButtonsPlayer()
        setupButtonsEffect()
        setupLabelEffect()
 //       setupEffectView(tag)
        
    }
    
    @IBAction func doSomething(sender: UISlider) {
        printContent(sender.value)
        
    }
    

//    override func viewWillLayoutSubviews() {
//            print("DidLay ", tag)
//        }
//
//
//    override func viewWillAppear(_ animated: Bool) {
//            super.viewWillAppear(true)
//
//        print("viewApp ", tag)
//
//        }

    @IBAction func pitchSlider(_ sender: UISlider) {
        editingPitch(sender)
        
    }

    func playButton() {
//        pitchEffect.pitch = valuePitchEffect ?? 0
        setupAudio(music[1])
        playOrPause()
    }

    
    func editingPitch(_ slider: UISlider) {
        valuePitchEffect = slider.value
        pitchEffect.pitch = valuePitchEffect ?? 0
    }
    
    func editingReverb(_ slider: UISlider) {
        reverbEffect.loadFactoryPreset(.cathedral)
        
    }
    
    func editingEQ(left: UISlider, rigth: UISlider) {
        
        eqEffect.globalGain = 0
        let bands = eqEffect.bands
        bands[0].filterType = .lowPass
        bands[0].frequency = left.value
        bands[1].filterType = .highPass
        bands[1].frequency = rigth.value
        
        
    }
    
    func configureEngine(_ format: AVAudioFormat) {
        
            engine.attach(player)
    //        engine.attach(eqEffect)
        
            
  //          engine.connect(player, to: eqEffect, format: nil)
            engine.connect(player, to: engine.outputNode, format: format)
            
            engine.prepare()
        
        do {
            try engine.start()
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
        player.scheduleFile(file, at: nil) {
            self.needsFileScheduled = true
        }
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
    
//    func reloadUI() {
//
//        guard let max = self.view.viewWithTag(202) as? UIImageView else { return print("No") }
//        print("Yes")
//        max.tintColor = .gray
//        self.view.reloadInputViews()
//        let slider = stack.subviews[1]
//        slider.removeFromSuperview()
//        slider.reloadInputViews()
//        print(stack.subviews.count)
//        stack.addArrangedSubview(SliderEffectView.shared.createSlidersStack(tag))
//        print(stack.subviews.count)
//
//
    

        
        
  //          viewWithTag.removeFromSuperview()
        
//        viewDidLayoutSubviews()
//        let effect = view.subviews[1]
//        effect.removeFromSuperview()
//
//        view.reloadInputViews()
  
 //       setupUI(tag)
        
 //       view.reloadInputViews()
//        let view = view.subviews.count
//
//        let stack = sliderEffectStack?.arrangedSubviews.count
//        print(view)
//        let newStack = NavigationEffectView.shared.setupNavigationSliderEffect(tag)


 //   }
    @objc func pressEffectButtons(_ sender: UIButton) {
        
        let tag = sender.tag
        clearColorButtonEffect(tag)
        
        switch tag {
        case 0:
            stackEffectButton.isHidden = true
            stackEffectLabel.isHidden = true
            print(tag)
            
        case 1:
            
            print(tag)
        case 2:
            
            print(tag)
        case 3:
            
            print(tag)
        case 4:
            
            print(tag)
        default:
            
            print(tag)
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
    
    
    
    
//    func setupEffectView(_ tag: Int) {
//        let height = view.bounds.width / 6
//        let button = ButtonEffectView.shared.createButtonStack()
//        button.tag = 30
//        let slider = SliderEffectView.shared.createSlidersStack(tag)
//        slider.tag = 20
//        let stack = UIStackView(arrangedSubviews: [button, sliderStack])
//        stack.tag = 40
//
//
//        stack.axis = .vertical
//        stack.spacing = 0
//        stack.distribution = UIStackView.Distribution.fillProportionally
//
//        view.addSubview(stack)
//        stack.translatesAutoresizingMaskIntoConstraints = false
//
//        stack.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
//        stack.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
//        stack.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -height).isActive = true
//    }
    
  
//    func setupNavigationSlidersEffect(_ tag: Int) {
//        let height = view.bounds.width / 10
//        let stack = SliderEffectView.shared.createSlidersStack(tag)
//        stack.tag = 30
//        effectView.addSubview(stack)
//
//        stack.translatesAutoresizingMaskIntoConstraints = false
//        stack.heightAnchor.constraint(equalToConstant: height).isActive = true
//        stack.leftAnchor.constraint(equalTo: effectView.leftAnchor, constant: 20).isActive = true
//        stack.rightAnchor.constraint(equalTo: effectView.rightAnchor, constant: -20).isActive = true
//        stack.topAnchor.constraint(equalTo: effectView.topAnchor, constant: 2 * height).isActive = true
//    }
//
//    func setupNavigationButtonEffect() {
//        let height = view.bounds.width / 10
//        let stack = ButtonEffectView.shared.createButtonStack()
//        stack.tag = 20
//        effectView.addSubview(stack)
//
//        stack.translatesAutoresizingMaskIntoConstraints = false
//
//        stack.heightAnchor.constraint(equalToConstant: height).isActive = true
//        stack.leftAnchor.constraint(equalTo: effectView.leftAnchor, constant: 15).isActive = true
//        stack.rightAnchor.constraint(equalTo: effectView.rightAnchor, constant: -15).isActive = true
//        stack.topAnchor.constraint(equalTo: effectView.topAnchor, constant: 15).isActive = true
//    }
    
    
    
   
}

// MARK: - navigation player
extension AudioEngineViewController {
    
   
    
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
        stackEffectButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100).isActive = true
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
    
    private func clearColorButtonEffect(_ tag: Int) {
        let setting = Setting.getSetting()
        for button in buttonsEffect {
            button.backgroundColor = button.tag == tag ? setting.colorPressedButtonEffect : setting.colorBgrnd
            labelsEffect[button.tag].backgroundColor = button.tag == tag ? setting.colorPressedButtonEffect : setting.colorBgrnd
        }
    }
    
    func playOrPause() {
        
        if needsFileScheduled { scheduleAudioFile() }
        if player.isPlaying {
            player.pause()
            let image = UIImage(systemName: Buttons.play.rawValue)
            buttonsPlayer[2].setImage(image, for: .normal)
        } else {
            player.play()
            let image = UIImage(systemName: Buttons.pause.rawValue)
            buttonsPlayer[2].setImage(image, for: .normal)
            
        }
        
    }
    
    func goForward() {
        
    }
    
    func goBackward() {
        
    }
}


