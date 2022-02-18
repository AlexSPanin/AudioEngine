//
//  DataSongs.swift
//  AudioEngine
//
//  Created by Александр Панин on 18.02.2022.
//

import Foundation

struct DataSong {
    let name: Music
    let file: AVAudioFile
    
    let length: Int
    let rate: Double
    let audioFormat: AVAudioFormat
    
    private var lengthSeconds: Double {
        Double(length) / rate
    }
    static func getDataSong() -> [DataSong]{
        let music = Music.getMusic()
        var dataSongs: [DataSong] = []
        for song in music {
            guard let url = Bundle.main.url(forResource: song.name, withExtension: song.format) else { return dataSongs}
            do {
                let file = try AVAudioFile(forReading: url)
                let format = file.processingFormat
                let dataSong = DataSong(
                    name: song,
                    file: file,
                    length: Int(file.length),
                    rate: format.sampleRate,
                    audioFormat: format
                )
                dataSongs.append(dataSong)
            } catch {
                print("error Setup Audio")
            }
        }
        return dataSongs
    }
}

struct DataPlayingSong {
    let tag: Int
    var isPlaying: Bool
    var isPlayerReady: Bool
    var needsFileScheduled: Bool
    var seekFrame: Double
    static func getDataPlayingSong() -> [DataPlayingSong] {
        [
            DataPlayingSong(tag: 0, isPlaying: false, isPlayerReady: false, needsFileScheduled: true, seekFrame: 0),
            DataPlayingSong(tag: 1, isPlaying: false, isPlayerReady: false, needsFileScheduled: true, seekFrame: 0),
            DataPlayingSong(tag: 2, isPlaying: false, isPlayerReady: false, needsFileScheduled: true, seekFrame: 0)
        ]
    }
}

