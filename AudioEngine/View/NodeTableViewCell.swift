//
//  NodeTableViewCell.swift
//  AudioEngine
//
//  Created by Александр Панин on 21.02.2022.
//

import UIKit

class NodeTableViewCell: UITableViewCell {
    
    var delegate: NodeTableViewCellDelegate!
    var node: DataSong?
    
    var name: String = ""
    var length: Float = 0
    var current: Float = 0
    
    let buttonFX: UIButton = {
        let button = UIButton()
        let setting = Setting.getSetting()
        button.setImage(UIImage(systemName: "fx"), for: .normal)
        button.tintColor = setting.colorBgrnd
        button.backgroundColor = setting.colorBrgndPlayerButton
        return button
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        let setting = Setting.getSetting()
        guard let font = UIFont(name: setting.nameFont, size: setting.normalSize) else {return label }
        label.font = font
        label.textColor = setting.colorTint
        label.backgroundColor = setting.colorBgrnd
        label.minimumScaleFactor = 0.5
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    let lengthLabel: UILabel = {
        let label = UILabel()
        let setting = Setting.getSetting()
        guard let font = UIFont(name: setting.nameFont, size: setting.normalSize) else {return label }
        label.font = font
        label.textColor = setting.colorTint
        label.backgroundColor = setting.colorBgrnd
        label.minimumScaleFactor = 0.5
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    let currentLabel: UILabel = {
        let label = UILabel()
        let setting = Setting.getSetting()
        guard let font = UIFont(name: setting.nameFont, size: setting.normalSize) else {return label }
        label.font = font
        label.textColor = setting.colorTint
        label.backgroundColor = setting.colorBgrnd
        label.minimumScaleFactor = 0.5
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    let switchAdd: UISwitch = {
        let switchAdd = UISwitch()
        let setting = Setting.getSetting()
        switchAdd.setOn(false, animated: true)
        switchAdd.onTintColor = setting.colorTint
        return switchAdd
    }()
    
    let progress: UIProgressView = {
        let progress = UIProgressView()
        let setting = Setting.getSetting()
        progress.trackTintColor = setting.colorTint
        
        return progress
    }()
    
    
    private let setting = Setting.getSetting()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(_ node: DataSong) {
        
    }
    
    
    private func configureUICell() {
        
    }

}
