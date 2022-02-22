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
    var dataPlaying: DataPlayingSong?
    
    var name: String = ""
    var length: Float = 1
    
    var current: Float! {
        didSet {
            let currentValue = current / length
            progress.progress = currentValue
        }
    }
    let buttonFX: UIButton = {
        let setting = Setting.getSetting()
        let button = UIButton(frame: setting.sizeButton)
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
        label.minimumScaleFactor = 0.5
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    let currentLabel: UILabel = {
        let label = UILabel()
        let setting = Setting.getSetting()
        guard let font = UIFont(name: setting.nameFont, size: setting.normalSize) else {return label }
        label.font = font
        label.textColor = setting.colorTint
        label.minimumScaleFactor = 0.5
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
        label.textAlignment = .left
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
        progress.setProgress(0, animated: true)
        
        return progress
    }()
    
    
    
    private let setting = Setting.getSetting()
    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }

//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
    
//    override func prepareForReuse() {
//        <#code#>
//    }
    
   
    
    @objc func selectSwitch(_ sender: UISwitch) {
        delegate.addSwitch(for: self)
    }
    
    @objc func selectButton(_ sender: UIButton) {
        delegate.button(for: self)
    }
    
    func configure(node: DataSong, data: DataPlayingSong, indexRow: IndexPath) {
   //     automaticallyUpdatesContentConfiguration = true
        configureUICell()
        self.node = node
        self.dataPlaying = data
        
        nameLabel.text = String("\(node.name.name) - \(node.name.format)")
        currentLabel.text = String("Current Time:  \(data.seekFrame)")
        lengthLabel.text = String("Total length: \(node.length)")
        
        current = Float(data.seekFrame)
        
        switchAdd.isOn = data.addPlayList
        
        buttonFX.backgroundColor = data.isEditing ? setting.colorTint : setting.colorBrgndPlayerButton
        
        backgroundColor = (indexRow.row + 1) % 2 == 1 ? .white : #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        selectionStyle = .none
        
    }
    
    
    private func configureUICell() {
        
        let stackLengthCurrent = UIStackView(arrangedSubviews: [lengthLabel, currentLabel])
        stackLengthCurrent.axis = .vertical
        stackLengthCurrent.spacing = 2
        stackLengthCurrent.distribution = UIStackView.Distribution.fillEqually

        let stack = UIStackView(arrangedSubviews: [nameLabel, stackLengthCurrent, progress])
        stack.axis = .vertical
        stack.spacing = 2
        stack.distribution = UIStackView.Distribution.equalSpacing

        contentView.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 5).isActive = true
        stack.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -5).isActive = true
        stack.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        stack.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5).isActive = true
        
        contentView.addSubview(buttonFX)
        buttonFX.addTarget(self, action: #selector(selectButton), for: .touchUpInside)
        buttonFX.translatesAutoresizingMaskIntoConstraints = false
        buttonFX.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -5).isActive = true
        buttonFX.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
 
        contentView.addSubview(switchAdd)
        switchAdd.addTarget(self, action: #selector(selectSwitch), for: .valueChanged)
        switchAdd.translatesAutoresizingMaskIntoConstraints = false
        switchAdd.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -5).isActive = true
        switchAdd.topAnchor.constraint(equalTo: buttonFX.bottomAnchor, constant: 5).isActive = true
    }

}
