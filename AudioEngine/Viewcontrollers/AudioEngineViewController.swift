//
//  AudioEngineViewController.swift
//  AudioEngine
//
//  Created by Александр Панин on 02.02.2022.
//

import UIKit
import AVFoundation



class AudioEngineViewController: UIViewController {
    
   var effectView = UIView()
    var buttonPlayerStack = UIStackView()
    var buttonEffectStack = UIStackView()
    var sliderEffectStack: UIStackView?
    
    var tag = 1
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray
        print(tag)
        setupUI(tag)
        setupNavigationViewPlayer()
        
    }
    
    override func viewDidLayoutSubviews() {
  //     setupNavigationSlidersEffect(4)
        }

    
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
    
    func reloadUI(_ tag: Int) {
        
        print(sliderEffectStack?.tag ?? 0)
        
        if let viewWithTag = self.view.viewWithTag(30) {
            viewWithTag.removeFromSuperview()
        }else{
            print("No!")
        }
        viewDidLayoutSubviews()
//        let effect = view.subviews[1]
//        effect.removeFromSuperview()
//
//        view.reloadInputViews()
        
        let count = view.subviews.count
       
        self.tag = tag
        print(" reload ",self.tag)
        print("view ", count)
 //       setupUI(tag)
        
 //       view.reloadInputViews()
//        let view = view.subviews.count
//
//        let stack = sliderEffectStack?.arrangedSubviews.count
//        print(view)
//        let newStack = NavigationEffectView.shared.setupNavigationSliderEffect(tag)


    }
    
    
    
    
    
    func setupUI(_ tag: Int) {
        setupEffectView()
        
        setupNavigationButtonEffect()
        setupNavigationSlidersEffect(tag)
        
        
    }
    
    
    
    func setupEffectView() {
        effectView.backgroundColor = .white
        effectView.layer.cornerRadius = 15
        view.addSubview(effectView)
        effectView.translatesAutoresizingMaskIntoConstraints = false
        
        effectView.heightAnchor.constraint(equalToConstant: 210).isActive = true
        effectView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        effectView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        effectView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    private func setupNavigationViewPlayer() {
        let height = view.bounds.height / 10
        buttonPlayerStack = ButtonPlayerView.shared.setupNavigationPlayer()
        view.addSubview(buttonPlayerStack)
        
        buttonPlayerStack.translatesAutoresizingMaskIntoConstraints = false
        
        buttonPlayerStack.heightAnchor.constraint(equalToConstant: height).isActive = true
        buttonPlayerStack.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        buttonPlayerStack.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        buttonPlayerStack.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    func setupNavigationSlidersEffect(_ tag: Int) {
        
        sliderEffectStack = SliderEffectView.shared.setupNavigationSliderEffect(tag)
        guard let stack = sliderEffectStack else { return }
        stack.tag = 30
        effectView.addSubview(stack)
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.leftAnchor.constraint(equalTo: effectView.leftAnchor, constant: 20).isActive = true
        stack.rightAnchor.constraint(equalTo: effectView.rightAnchor, constant: -20).isActive = true
        stack.topAnchor.constraint(equalTo: buttonEffectStack.bottomAnchor, constant: 10).isActive = true
    }
    
    func setupNavigationButtonEffect() {
        buttonEffectStack = SliderEffectView.shared.setupNavigationButtonsEffect()
        
        effectView.addSubview(buttonEffectStack)
        
        buttonEffectStack.translatesAutoresizingMaskIntoConstraints = false
        buttonEffectStack.leftAnchor.constraint(equalTo: effectView.leftAnchor, constant: 15).isActive = true
        buttonEffectStack.rightAnchor.constraint(equalTo: effectView.rightAnchor, constant: -15).isActive = true
        buttonEffectStack.topAnchor.constraint(equalTo: effectView.topAnchor, constant: 15).isActive = true
    }
    
    
    
   
}

// MARK: - navigation player
extension AudioEngineViewController {
    
    func playOrPause() {
        if needsFileScheduled { scheduleAudioFile() }
        player.isPlaying ? player.pause() : player.play()
    }
    
    func goForward() {
        
    }
    
    func goBackward() {
        
    }
}
