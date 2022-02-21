//
//  AESetupEngine.swift
//  AudioEngine
//
//  Created by Александр Панин on 21.02.2022.
//

import UIKit

extension AudioEngineViewController {
 
    
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
    }
    
    
    
    
    
}




