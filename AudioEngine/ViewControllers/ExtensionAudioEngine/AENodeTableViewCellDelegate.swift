//
//  AENodeTableViewCellDelegate.swift
//  AudioEngine
//
//  Created by Александр Панин on 22.02.2022.
//

import UIKit

extension AudioEngineViewController: NodeTableViewCellDelegate {
    
    func button(for cell: NodeTableViewCell) {
        
        if let node = cell.dataPlaying?.node, dataPlayingSong[node].addPlayList {
            clearIsEditing()
            viewEffect.isHidden = false
            dataPlayingSong[node].isEditing = true
            activeEffectNode = node
            setupEffectValue()
            setupColorButtonPressedEffect(track: activeEffectNode, type: typeButtosEffect)
        }
        tableViewNode.reloadData()
        return
    }
    
    func addSwitch(for cell: NodeTableViewCell) {
        //      clearAddPlayer()
        
        if let node = cell.dataPlaying?.node {
            dataPlayingSong[node].addPlayList = cell.switchAdd.isOn
        }
        checkAddPlayer()
        tableViewNode.reloadData()
        return
    }
}
