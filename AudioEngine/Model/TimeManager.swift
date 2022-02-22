//
//  TimeManager.swift
//  AudioEngine
//
//  Created by Александр Панин on 22.02.2022.
//

import Foundation

enum TimeConstant: Int {
    case secPerMin = 60
    case secPerHour = 3600
}

class PlayerTime {
    
    static var shared = PlayerTime()
    
    private init() {}

    static func getFormattedTime(seconds: Int) -> String {
        var formattedString = ""
        var seconds = seconds
        var mins = 0
        var hours = 0
        
        if seconds > TimeConstant.secPerHour.rawValue {
            hours = seconds / TimeConstant.secPerHour.rawValue
            seconds -= hours * TimeConstant.secPerHour.rawValue
        }
        if seconds > TimeConstant.secPerMin.rawValue {
            mins = seconds / TimeConstant.secPerMin.rawValue
            seconds -= mins * TimeConstant.secPerMin.rawValue
        }
        
        if hours > 0 {
            formattedString = "\(String(format: "%02d", hours)):"
        }
        formattedString += "\(String(format: "%02d", mins)):\(String(format: "%02d", seconds))"
      return formattedString
    }
}
