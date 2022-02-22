//
//  AudioEngineViewController.swift
//  AudioEngine
//
//  Created by Александр Панин on 02.02.2022.
//

import UIKit
import AVFoundation

protocol NodeTableViewCellDelegate {
    func button (for cell: NodeTableViewCell)
    func addSwitch ( for cell: NodeTableViewCell)
}

class AudioEngineViewController: UIViewController {
    
    // MARK: - User Interface
    
    weak var tableViewNode: UITableView!
    
    // Player View
    var buttonsPlayer: [UIButton] = []
    var stackPlayer = UIStackView()
    
    // Editor View
    let viewEditor = UIView()
    var buttonsEditor: [UIButton] = []
    var stackEditor = UIStackView()
    
    
    // MARK: - Effect View
    // Effect View
    let viewEffect = UIView()
    var stackEffect = UIStackView()
    
    // Effect Buttons
    var buttonsEffect: [UIButton] = []
    var labelsEffect: [UILabel] = []
    var stackEffectButton = UIStackView()
    var stackEffectLabel = UIStackView()
    
    //Effect Sliders
    var slidersEffect = UISlider()
    var slidersTextEffect: [UILabel] = []
    var slidersImageEffect: [UIImageView] = []
    var stackEffectSlider = UIStackView()
    var stackEffectText = UIStackView()
    var stackEffectImage = UIStackView()
    
    // MARK: - AudioEngine
    // Mixer and Engine
    var audioFile: AVAudioFile?
    let audioEngine = AVAudioEngine()
    let audioMixer = AVAudioMixerNode()
    let micMixer = AVAudioMixerNode()
    
    // Node 1
    let audioPlayerNode1 = AVAudioPlayerNode()
    let reverb1 = AVAudioUnitReverb()
    let delayEcho1 = AVAudioUnitDelay()
    let equalizer1 = AVAudioUnitEQ(numberOfBands: 1)
    
    // Node 2
    let audioPlayerNode2 = AVAudioPlayerNode()
    let reverb2 = AVAudioUnitReverb()
    let delayEcho2 = AVAudioUnitDelay()
    let equalizer2 = AVAudioUnitEQ(numberOfBands: 1)
    
    // Node 3
    let audioPlayerNode3 = AVAudioPlayerNode()
    let reverb3 = AVAudioUnitReverb()
    let delayEcho3 = AVAudioUnitDelay()
    let equalizer3 = AVAudioUnitEQ(numberOfBands: 1)
    
    // MARK: - Data Songs and Settings UI and start value
    let setting = Setting.getSetting()
    var dataSongs = DataSong.getDataSong()
    var dataPlayingSong = DataPlayingSong.getDataPlayingSong()
    
    
    // MARK: - number song and start button effect
    var activeEffectNode: Int = 0
    var isActiveAddPlayer: Bool = false
    var typeButtosEffect: ButtonsEffect = .volume
   
    // состояние плееров общее играют или нет
    var isPlaying: Bool = false
    
    // значения настроек слайдеров по песням
    var tracksSlidersValue = TrackSlidersValue.getTrackSlidersValue()
    
    
   

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)

        setupUI(track: activeEffectNode, type: typeButtosEffect)
        
        setupEffectValue()
        configureEngine(dataSongs)
        
        self.tableViewNode.register(NodeTableViewCell.self, forCellReuseIdentifier: "nodeCell")
        self.tableViewNode.dataSource = self
       
    }
    
    override func loadView() {
        super.loadView()
        
        let tableView = UITableView()
        tableView.rowHeight = 100
        tableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.heightAnchor.constraint(equalToConstant: 320).isActive = true
        
        self.tableViewNode = tableView
    }
    
   
    
    
    
   
    
    //MARK: - Подготовка аудио движка
    
    func configureEngine(_ dataSongs: [DataSong]) {
        // setting start value effect
        configureSetupEffect()
        
        let dataSongs = dataSongs
        let audioFormat1 = dataSongs[0].audioFormat
        let audioFormat2 = dataSongs[1].audioFormat
        let audioFormat3 = dataSongs[2].audioFormat
        
        // MARK: - connect Node
        
        // Node1
        audioEngine.connect(audioPlayerNode1, to: delayEcho1, format: audioFormat1)
        audioEngine.connect(delayEcho1, to: reverb1, format: audioFormat1)
        audioEngine.connect(reverb1, to: equalizer1, format: audioFormat1)
        audioEngine.connect(equalizer1, to: audioEngine.mainMixerNode, fromBus: 0, toBus: 0, format: audioFormat1)
        // Node2
        audioEngine.connect(audioPlayerNode2, to: delayEcho2, format: audioFormat2)
        audioEngine.connect(delayEcho2, to: reverb2, format: audioFormat2)
        audioEngine.connect(reverb2, to: equalizer2, format: audioFormat2)
        audioEngine.connect(equalizer2, to: audioEngine.mainMixerNode, fromBus: 0, toBus: 1, format: audioFormat2)
        // Node3
        audioEngine.connect(audioPlayerNode3, to: delayEcho3, format: audioFormat3)
        audioEngine.connect(delayEcho3, to: reverb3, format: audioFormat3)
        audioEngine.connect(reverb3, to: equalizer3, format: audioFormat3)
        audioEngine.connect(equalizer3, to: audioEngine.mainMixerNode, fromBus: 0, toBus: 2, format: audioFormat3)
        // монтирование движка
        audioEngine.prepare()
        // старт движка и монтирование аудифайлов
        do {
            try audioEngine.start()
            for node in 0...2 {
                scheduleAudioFile(node)
            }
        } catch {
            print("error configure Engine")
        }
    }
    
        // MARK: - create audio file and setting sign for ready play
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
    
    // MARK: -  запуск воспроизведения или пауза
    
    func playButton() {
        
        if isActiveAddPlayer {
            
            for node in 0...2 {
                if dataPlayingSong[node].addPlayList || dataPlayingSong[node].needsFileScheduled { scheduleAudioFile(node)}
            }
            
            switch isPlaying {
                
            case true:
                if dataPlayingSong[0].addPlayList { audioPlayerNode1.pause()}
                if dataPlayingSong[1].addPlayList { audioPlayerNode2.pause()}
                if dataPlayingSong[2].addPlayList { audioPlayerNode3.pause()}
            case false:
                if dataPlayingSong[0].addPlayList { audioPlayerNode1.play()}
                if dataPlayingSong[1].addPlayList { audioPlayerNode2.play()}
                if dataPlayingSong[2].addPlayList { audioPlayerNode3.play()}
            }
            
            isPlaying.toggle()
            changeImageButtonPlayPause(isPlaying)
        }
    }
    
    
    
    
    func clearIsEditing() {
        for count in 0...2 {
            dataPlayingSong[count].isEditing = false
        }
    }
  
    func checkAddPlayer() {
       isActiveAddPlayer = dataPlayingSong.contains { data in
            data.addPlayList
        }
    }
    
    // выключение меню эффектов
    func hiddenEffectView() {
        viewEffect.isHidden = true
        tableViewNode.reloadData()
    }
}



