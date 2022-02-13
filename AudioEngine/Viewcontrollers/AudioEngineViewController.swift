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
        
        setupUI()
        
    }
    
    
//    @IBAction func pitchSlider(_ sender: UISlider) {
//        editingPitch(sender)
//    }
//
    

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
    
    private func setupUI() {
        setupNavigationViewPlayer()
        
    }
    
    private func setupNavigationViewPlayer() {
        let height = view.bounds.height / 10
        let stack = NavigationPlayerView.shared.setupNavigationPlayer()
        view.addSubview(stack)
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        stack.heightAnchor.constraint(equalToConstant: height).isActive = true
        stack.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        stack.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        stack.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
//        stack.subviews.forEach { (button) in
//            button.transform = .identity
//            switch button.tag {
//            case 2:
//                button.addtar
//            default:
//                return
//            }
//        }
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
