//
//  DataSongs.swift
//  AudioEngine
//
//  Created by Александр Панин on 18.02.2022.
//

import Foundation
import AVFAudio

struct DataSong {
    let name: Songs
    let file: AVAudioFile
    let length: Int
    let rate: Double
    let audioFormat: AVAudioFormat
    
    private var lengthSeconds: Double {
        Double(length) / rate
    }
    static func getDataSong() -> [DataSong]{
        let music = Songs.getSongs()
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
    let node: Int
    var addPlayList: Bool                     //признак добавления к проигрованию
    var isEditing: Bool                       //признак активного редактирования
    var isPlaying: Bool                       //признак что началось проигрование
    var isPlayerReady: Bool                   //признак что в плеере смонтирован аудио файл и плеер готов его проиговать
    var needsFileScheduled: Bool              //признак необходимости смонтировать аудиофайл
    var seekFrame: Double
    static func getDataPlayingSong() -> [DataPlayingSong] {
        [
            DataPlayingSong(node: 0,
                            addPlayList: false,
                            isEditing: false,
                            isPlaying: false,
                            isPlayerReady: false,
                            needsFileScheduled: true,
                            seekFrame: 0),
            DataPlayingSong(node: 1,
                            addPlayList: false,
                            isEditing: false,
                            isPlaying: false,
                            isPlayerReady: false,
                            needsFileScheduled: true,
                            seekFrame: 0),
            DataPlayingSong(node: 2,
                            addPlayList: false,
                            isEditing: false,
                            isPlaying: false,
                            isPlayerReady: false,
                            needsFileScheduled: true,
                            seekFrame: 0)
        ]
    }
}

