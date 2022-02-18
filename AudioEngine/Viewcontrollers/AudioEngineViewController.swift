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
    
    let viewEffect = UIView()
    
    // управление слайдерами
    var sliderValue: [Float] = []
    var tag: Int = 1
    var track: Int = 0
    var typeButtosEffect: ButtonsEffect = .volume
    
    
//    var audioLengthSamples: Int?
//    var audioSampleRate: Double?
//    var audioLengthSeconds: Double?
    
    
    
//    var isPlayerReady: Bool?
    var isPlaying: Bool = false
//    var needsFileScheduled = true
//    var seekFrame: Double?
    
    let music = Music.getMusic()
    let setting = Setting.getSetting()
    var dataSongs = DataSong.getDataSong()
    var tracksSlidersValue = TrackSlidersValue.getTrackSlidersValue()
    var dataPlayingSong = DataPlayingSong.getDataPlayingSong()
    
    
    
    var audioFile: AVAudioFile?
    
    let audioEngine = AVAudioEngine()
    let audioMixer = AVAudioMixerNode()
    let micMixer = AVAudioMixerNode()
    
    let audioPlayerNode1 = AVAudioPlayerNode()
    let reverb1 = AVAudioUnitReverb()
    let delayEcho1 = AVAudioUnitDelay()
    let equalizer1 = AVAudioUnitEQ(numberOfBands: 1)
    
    let audioPlayerNode2 = AVAudioPlayerNode()
    let reverb2 = AVAudioUnitReverb()
    let delayEcho2 = AVAudioUnitDelay()
    let equalizer2 = AVAudioUnitEQ(numberOfBands: 1)
    
    let audioPlayerNode3 = AVAudioPlayerNode()
    let reverb3 = AVAudioUnitReverb()
    let delayEcho3 = AVAudioUnitDelay()
    let equalizer3 = AVAudioUnitEQ(numberOfBands: 1)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
//        setupSlidersValue()
        
        setupUI(typeButtosEffect)
        setupEffectValue()
        configureEngine(dataSongs)
    }
    
    
    
    func playButton(_ track: Int) {
        
        playOrPause(track)
    }
    
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
    
    func editingEQ(_ value: Float) {
        switch track {
        case 0:
            let bands = equalizer1.bands
            bands[0].frequency = value * value
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
    
    
    func configureEngine(_ dataSongs: [DataSong]) {
        // setting start value effect
        configureSetupEffect()
        let dataSongs = dataSongs
        let audioFormat1 = dataSongs[0].audioFormat
        let audioFormat2 = dataSongs[1].audioFormat
        let audioFormat3 = dataSongs[2].audioFormat
        
        
        // Attach the nodes
        audioEngine.attach(audioPlayerNode1)
        audioEngine.attach(delayEcho1)
        audioEngine.attach(reverb1)
        audioEngine.attach(equalizer1)
        
        audioEngine.attach(audioPlayerNode2)
        audioEngine.attach(delayEcho2)
        audioEngine.attach(reverb2)
        audioEngine.attach(equalizer2)
        
        audioEngine.attach(audioPlayerNode3)
        audioEngine.attach(delayEcho3)
        audioEngine.attach(reverb3)
        audioEngine.attach(equalizer3)
        
        audioEngine.attach(audioMixer)
        audioEngine.attach(micMixer)
        
   //     audioEngine.connect(audioMixer, to: audioEngine.mainMixerNode)
        audioEngine.connect(audioPlayerNode1, to: delayEcho1, format: audioFormat1)
        audioEngine.connect(delayEcho1, to: reverb1, format: audioFormat1)
        audioEngine.connect(reverb1, to: equalizer1, format: audioFormat1)
        audioEngine.connect(equalizer1, to: audioEngine.mainMixerNode, fromBus: 0, toBus: 0, format: audioFormat1)
        
        audioEngine.connect(audioPlayerNode2, to: delayEcho2, format: audioFormat2)
        audioEngine.connect(delayEcho2, to: reverb2, format: audioFormat2)
        audioEngine.connect(reverb2, to: equalizer2, format: audioFormat2)
        audioEngine.connect(equalizer2, to: audioEngine.mainMixerNode, fromBus: 0, toBus: 1, format: audioFormat2)
        
        audioEngine.connect(audioPlayerNode3, to: delayEcho3, format: audioFormat3)
        audioEngine.connect(delayEcho3, to: reverb3, format: audioFormat3)
        audioEngine.connect(reverb3, to: equalizer3, format: audioFormat3)
        audioEngine.connect(equalizer3, to: audioEngine.mainMixerNode, fromBus: 0, toBus: 2, format: audioFormat3)
        
        
        
        
        audioEngine.prepare()
        
        do {
            try audioEngine.start()
            for track in 0...2 {
                scheduleAudioFile(track)
            }
            
        } catch {
            print("error configure Engine")
        }
    }
    
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
    
    func changeImageButtonPlayPause(_ playOrPause: Bool) {
        if playOrPause {
            let image = UIImage(systemName: Buttons.pause.rawValue)
            buttonsPlayer[2].setImage(image, for: .normal)
        } else {
            let image = UIImage(systemName: Buttons.play.rawValue)
            buttonsPlayer[2].setImage(image, for: .normal)
        }
    }
    
    
    func playOrPause(_ track: Int) {
        
        changeImageButtonPlayPause(isPlaying)
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
    }
    
    
    @objc func pressEffectButtons(_ sender: UIButton) {
        
        typeButtosEffect = ButtonsEffect(rawValue: sender.tag) ?? .volume
        setupColorButtonPressedEffect(track: track, type: typeButtosEffect)
        
        switch typeButtosEffect {
        case .exit:
            hiddenEffectView()
        case .volume:
            return
        case .eq:
            return
        case .reverb:
            return
        case .delay:
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
            playButton(track)
        case 3:
            return
        case 4:
            return
        default:
            return
        }
    }
    
//    func setupSlidersValue() {
//        let slidersValueEffect = EffectSliderValue.getEffectSliderValue()
//        for slider in slidersValueEffect {
//            sliderValue.append(slider.value)
//        }
//    }
    
    
    @objc func turnEffectSlider(_ sender: UISlider) {
        
        switch tag {
        case 1:
            tracksSlidersValue[track].slidersValue.volume = sender.value
        case 2:
            tracksSlidersValue[track].slidersValue.eq = sender.value
        case 3:
            tracksSlidersValue[track].slidersValue.reverb = sender.value
        case 4:
            tracksSlidersValue[track].slidersValue.delay = sender.value
        default:
            print("Errortag Effect")
            return
        }
        setupEffectValue()
    }
    
    /*
    func setupAudio(_ music: [Music]) {
        for song in music {
           
            guard let url = Bundle.main.url(forResource: song.name, withExtension: song.format) else { return }
            do {
                let file = try AVAudioFile(forReading: url)
                let format = file.processingFormat
                
                
                let dataSong = DataSong(
                    name: song.name,
                    format: song.format,
                    file: file,
                    length: Int(file.length),
                    rate: format.sampleRate,
                    audioFormat: format
                )
                dataSongs.append(dataSong)
                
                //         audioLengthSeconds = Double(audioLengthSamples ?? 0) / (audioSampleRate ?? 1)
                
                //          configureEngine(index: 1, audioFormat: format)
                
            } catch {
                print("error Setup Audio")
            }
            
        }
    }
     */
    
    func configureSetupEffect() {
        delayEcho1.delayTime = 0
        reverb1.loadFactoryPreset(.largeHall)
        
        let bands1 = equalizer1.bands
        bands1[0].frequency = 25
        bands1[0].filterType = .highPass
        bands1[0].bypass = false
        
        delayEcho2.delayTime = 0
        reverb2.loadFactoryPreset(.largeHall)
        
        let bands2 = equalizer2.bands
        bands2[0].frequency = 25
        bands2[0].filterType = .highPass
        bands2[0].bypass = false
        
        delayEcho3.delayTime = 0
        reverb3.loadFactoryPreset(.largeHall)
        
        let bands3 = equalizer3.bands
        bands3[0].frequency = 25
        bands3[0].filterType = .highPass
        bands3[0].bypass = false
    }
}


