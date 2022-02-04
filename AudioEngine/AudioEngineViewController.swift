//
//  AudioEngineViewController.swift
//  AudioEngine
//
//  Created by Александр Панин on 02.02.2022.
//

import UIKit
import AVFoundation

class AudioEngineViewController: UIViewController {
    
    @IBOutlet var timeLabel: UILabel!
    
    let name = "Scott Buckley - Life In Silico"
    
    var audioFile: AVAudioFile?
    var engine = AVAudioEngine()
    var player = AVAudioPlayerNode()
    var changePitchEffect = AVAudioUnitTimePitch()
    
    var audioLengthSamples: Int64?
    var audioSampleRate: Double?
    var audioLengthSeconds: Double?
    
    var isPlaying: Bool?
    var isPlayerReady: Bool?
    var needsFileScheduled = true
    var seekFrame: Double?
    
    var pitchEffect: Float?
    
    
    @IBAction func pitchSlider(_ sender: UISlider) {
        editingPitch(sender)
    }
    
    @IBAction func playButton(_ sender: Any) {
        changePitchEffect.pitch = pitchEffect ?? 0
        setupAudio(name)
        playOrPause()
    }
    
    @IBAction func stopButton(_ sender: Any) {
        player.stop()
        engine.stop()
    }
    
    func editingPitch(_ slider: UISlider) {
        pitchEffect = slider.value
        changePitchEffect.pitch = pitchEffect ?? 0
    }
    
    func configureEngine(_ format: AVAudioFormat) {
        
            engine.attach(player)
            engine.attach(changePitchEffect)
            
            engine.connect(player, to: changePitchEffect, format: nil)
            engine.connect(changePitchEffect, to: engine.outputNode, format: format)
            
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
    
    func setupAudio(_ name: String) {
        guard let url = Bundle.main.url(forResource: name, withExtension: "mp3") else { return }
        do {
            let file = try AVAudioFile(forReading: url)
            let format = file.processingFormat
            
            audioLengthSamples = file.length
            audioSampleRate = format.sampleRate
            audioLengthSeconds = Double(audioLengthSamples ?? 0) / (audioSampleRate ?? 1)
            
            audioFile = file
            configureEngine(format)
            
        } catch {
            print("error Setup Audio")
        }
    }
    
    func playOrPause() {
        isPlaying?.toggle()
        if player.isPlaying {
            player.pause()
        } else {
            if needsFileScheduled {
                scheduleAudioFile()
            }
            player.play()
        }
    }
}

