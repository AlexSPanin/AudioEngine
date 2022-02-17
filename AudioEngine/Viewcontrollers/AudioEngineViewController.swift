//
//  AudioEngineViewController.swift
//  AudioEngine
//
//  Created by Александр Панин on 02.02.2022.
//

import UIKit
import AVFoundation

class AudioEngineViewController: UIViewController {
    
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
     var tag: Int = 1
  
    var audioLengthSamples: Int?
    var audioSampleRate: Double?
    var audioLengthSeconds: Double?
    
    var isPlaying: Bool = false
    var isPlayerReady: Bool?
    var needsFileScheduled = true
    var seekFrame: Double?
    
    let music = Music.getMusic()
    let setting = Setting.getSetting()
    
    
    
    
    
    
    var audioFile: AVAudioFile?
    
    let audioEngine = AVAudioEngine()
    let audioMixer = AVAudioMixerNode()
    let micMixer = AVAudioMixerNode()
    
    let audioPlayerNode1 = AVAudioPlayerNode()
    let audioPlayerNode2 = AVAudioPlayerNode()
    
    let reverb = AVAudioUnitReverb()
    let delayEcho = AVAudioUnitDelay()
    let equalizer = AVAudioUnitEQ(numberOfBands: 1)
    let distortion = AVAudioUnitDistortion()
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSlidersValue()
        setupUI(tag)
        setupEffectValue()
        setupAudio(music[1])
    }
    
  
  
    

    func playButton() {
        
        playOrPause()
    }
    
    func setupEffectValue() {
        
        
        
        switch tag {
        case 1:
            editingVolume(sliderValue[1])
        case 2:
            editingEQ(sliderValue[2])
        case 3:
            editingReverb(sliderValue[3])
        default:
            editingDelay(sliderValue[4])
        }
    }
    
    
    
    func editingVolume(_ value: Float) {
        audioPlayerNode1.volume = value
        print("Volume", audioPlayerNode1.volume)
    }
    
    func editingEQ(_ value: Float) {
        let bands = equalizer.bands
        bands[0].frequency = value
        print("EQ", bands[0].frequency)
        print("EQ gain", bands[0].gain)
        print("EQ bandwidth", bands[0].bandwidth)
    }
    
    func editingReverb(_ value: Float) {
        reverb.wetDryMix = value
        print("Reverb", reverb.wetDryMix)
    }
    
    func editingDelay(_ value: Float) {
       delayEcho.delayTime = Double(value)
        print("Delay", delayEcho.delayTime)
    }
    
    func configureEngine(_ format: AVAudioFormat) {
        // setting start value effect
        delayEcho.delayTime = 0
        reverb.loadFactoryPreset(.largeHall)
        
        let bands = equalizer.bands
        bands[0].frequency = 20
        bands[0].filterType = .highPass
        bands[0].bypass = false
        
        // Attach the nodes
        audioEngine.attach(audioPlayerNode1)
        audioEngine.attach(audioMixer)
        audioEngine.attach(micMixer)
        
        audioEngine.attach(reverb)
        audioEngine.attach(delayEcho)
        audioEngine.attach(equalizer)
        
        audioEngine.connect(audioMixer, to: audioEngine.mainMixerNode, format: format)
        audioEngine.connect(audioPlayerNode1, to: delayEcho, format: format)
        audioEngine.connect(delayEcho, to: reverb, format: format)
        audioEngine.connect(reverb, to: equalizer, format: format)
        audioEngine.connect(equalizer, to: audioMixer, fromBus: 0, toBus: 0, format: format)
    
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
        audioPlayerNode1.scheduleFile(file, at: nil) {
            self.needsFileScheduled = true
        }
    }
    
    
    
    func playOrPause() {
        
        if needsFileScheduled { scheduleAudioFile() }
        if audioPlayerNode1.isPlaying {
            audioPlayerNode1.pause()
            let image = UIImage(systemName: Buttons.play.rawValue)
            buttonsPlayer[2].setImage(image, for: .normal)
        } else {
            
            audioPlayerNode1.play()
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
    
    
    @objc func turnEffectSlider(_ sender: UISlider) {
        sliderValue[tag] = sender.value
        setupEffectValue()
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
}


