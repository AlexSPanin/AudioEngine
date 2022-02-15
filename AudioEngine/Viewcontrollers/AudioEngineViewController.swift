//
//  AudioEngineViewController.swift
//  AudioEngine
//
//  Created by Александр Панин on 02.02.2022.
//

import UIKit
import AVFoundation



class AudioEngineViewController: UIViewController {
    
    var tag = 4
    
  lazy  var sliderStack: UIStackView = {
      let stack = SliderEffectView.shared.createSlidersStack(4)
      return stack
    }()
    
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

        setupNavigationViewPlayer()
        setupEffectView(tag)
        
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
    
    func reloadUI() {
   
        guard let max = self.view.viewWithTag(202) as? UIImageView else { return print("No") }
        print("Yes")
        max.tintColor = .gray
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


    }
    
    
    
    
    
    func setupUI(_ tag: Int) {
          setupEffectView(tag)
        
//        setupNavigationButtonEffect()
//        setupNavigationSlidersEffect(tag)
        
        
    }
    
    
    
    func setupEffectView(_ tag: Int) {
        let height = view.bounds.width / 6
        let button = ButtonEffectView.shared.createButtonStack()
        button.tag = 30
//        let slider = SliderEffectView.shared.createSlidersStack(tag)
//        slider.tag = 20
        let stack = UIStackView(arrangedSubviews: [button, sliderStack])
        stack.tag = 40
    
        
        stack.axis = .vertical
        stack.spacing = 0
        stack.distribution = UIStackView.Distribution.fillProportionally
        
        view.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        stack.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        stack.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        stack.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -height).isActive = true
    }
    
    private func setupNavigationViewPlayer() {
        let height = view.bounds.width / 8
        let stack = ButtonPlayerView.shared.setupNavigationPlayer()
        view.addSubview(stack)
        stack.tag = 10
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        stack.heightAnchor.constraint(equalToConstant: height).isActive = true
        stack.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        stack.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        stack.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
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
    
    func playOrPause() {
        if needsFileScheduled { scheduleAudioFile() }
        player.isPlaying ? player.pause() : player.play()
    }
    
    func goForward() {
        
    }
    
    func goBackward() {
        
    }
}
