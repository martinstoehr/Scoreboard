//
//  Einstellungen.swift
//  Scoreboard
//
//  Created by Martin Stöhr on 26.01.19.
//  Copyright © 2019 Martin Stöhr. All rights reserved.
//

import Foundation

struct Einstellungen {
    
    var defaultMinuten: Double {
        get {
            let savedDefaultMinuten = UserDefaults.standard.double(forKey: "defaultMinuten")
            if savedDefaultMinuten > 0 {
                return savedDefaultMinuten
            }
            return 12
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "defaultMinuten")
        }
    }
    
    var defaultSekunden: Double {
        get {
            let savedDefaultSekunden = UserDefaults.standard.double(forKey: "defaultSekunden")
            if savedDefaultSekunden > 0 {
                return savedDefaultSekunden
            }
            return 0
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "defaultSekunden")
        }
    }
    
    static let soundFiles = ["AirHorn1.wav", "AirHorn2.wav"]
    
    var soundFile: String {
        get {
            let savedSoundFile = UserDefaults.standard.string(forKey: "soundFile")
            if savedSoundFile != nil {
                return savedSoundFile!
            }
            return Einstellungen.soundFiles[0]
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "soundFile")
        }
    }
    
    var playSound: Bool {
        get {
            let savedPlaySound = UserDefaults.standard.bool(forKey: "playSound")
            return savedPlaySound
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "playSound")
        }
    }
    
}
