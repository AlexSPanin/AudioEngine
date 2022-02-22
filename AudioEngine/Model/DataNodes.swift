//
//  DataNodes.swift
//  AudioEngine
//
//  Created by Александр Панин on 22.02.2022.
//

import Foundation
import AVFAudio


struct DataPlayingNode {
    var nodeForSong: DataSong
    
    var addPlayList: Bool                     //признак добавления к проигрованию
    var isEditing: Bool                       //признак активного редактирования
    var isPlaying: Bool                       //признак что началось проигрование
    var isPlayerReady: Bool                   //признак что в плеере смонтирован аудио файл и плеер готов его проиговать
    var needsFileScheduled: Bool              //признак необходимости смонтировать аудиофайл
    
    var seekFrame: AVAudioFramePosition
    var currentPosition: AVAudioFramePosition
    var audioSeekFrame: AVAudioFramePosition
    var audioLengthSamples: AVAudioFramePosition
    var currentFrame: AVAudioFramePosition
    
    var audioPlayerNode: AVAudioPlayerNode
    var reverb: AVAudioUnitReverb
    var delayEcho: AVAudioUnitDelay
    var equalizer: AVAudioUnitEQ
    
    
}


class DataPlayingNodes {
    
    static var shared = DataPlayingNodes()
    
    private init() {}
    
    func getDataPlayingNodes() -> [DataPlayingNode] {
        var dataPlayingNodes: [DataPlayingNode] = []
        let dataSongs = DataSong.getDataSong()
        
        for dataSong in dataSongs {
            
            dataPlayingNodes.append(
                DataPlayingNode(
                    nodeForSong: dataSong,
                    addPlayList: false,
                    isEditing: false,
                    isPlaying: false,
                    isPlayerReady: false,
                    needsFileScheduled: true,
                    seekFrame: 0,
                    currentPosition: 0,
                    audioSeekFrame: 0,
                    audioLengthSamples: 0,
                    currentFrame: 0,
                    audioPlayerNode: AVAudioPlayerNode(),
                    reverb: AVAudioUnitReverb(),
                    delayEcho: AVAudioUnitDelay(),
                    equalizer: AVAudioUnitEQ(numberOfBands: 1)
                )
            )
        }
        return dataPlayingNodes
    }
}

