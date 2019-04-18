//
//  ControllerViewController.swift
//  Scoreboard
//
//  Created by Martin Stöhr on 05.01.18.
//  Copyright © 2018 Martin Stöhr. All rights reserved.
//

import Cocoa
import AVFoundation

class ControllerViewController: NSViewController {

    var sound: AVAudioPlayer?
    
    @IBOutlet var heimTextfield: NSTextField!
    @IBOutlet var gastTextfield: NSTextField!
    @IBOutlet var heimScoreTextfield: NSTextField!
    @IBOutlet var gastScoreTextfield: NSTextField!
    @IBOutlet var timeMinutenTextfield: NSTextField!
    @IBOutlet var timeSekundenTextfield: NSTextField!
    @IBOutlet var heimPlusButton: NSButton!
    @IBOutlet var heimMinusButton: NSButton!
    @IBOutlet var gastPlusButton: NSButton!
    @IBOutlet var gastMinusButton: NSButton!
    @IBOutlet var timeSetButton: NSButton!
    @IBOutlet var timeStartButton: NSButton!
    @IBOutlet var timeStopButton: NSButton!
    @IBOutlet var resetButton: NSButton!
    @IBOutlet var timeControlTextfield: NSTextField!
    @IBOutlet var settingCountdownButton: NSButton!
    @IBOutlet var settingTimerButton: NSButton!
    @IBOutlet var sireneCheckbox: NSButton!
    
    var count: Int = 0
    var countdown: Timer?
    var countFactor: Int = -1
    
    var prefs = Einstellungen()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        timeStartButton.isEnabled = true
        timeStopButton.isEnabled = false
        
        timeMinutenTextfield.stringValue = String(format: "%02.0f", prefs.defaultMinuten)
        timeSekundenTextfield.stringValue = String(format: "%02.0f", prefs.defaultSekunden)
        
        let timerTotal = Int(prefs.defaultMinuten) * 60 + Int(prefs.defaultSekunden)
        let timerDict:[String: Int] = ["timer": timerTotal]
        
        let sirenState = prefs.playSound
        if sirenState {
            sireneCheckbox.state = NSControl.StateValue.on
        } else {
            sireneCheckbox.state = NSControl.StateValue.off
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(timerSet), name: NSNotification.Name(rawValue: "timerSet"), object: nil)
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "timerSet"), object: nil, userInfo: timerDict)

    }
    
    override func viewDidAppear() {
        self.performSegue(withIdentifier: "ScoreboardSegue", sender: self)
    }
    
    func playSiren() {
        
        let path = Bundle.main.path(forResource: prefs.soundFile, ofType:nil)!
        let url = URL(fileURLWithPath: path)
        do {
            sound = try AVAudioPlayer(contentsOf: url)
            sound?.play()
        } catch {
            print("no soundfile")
        }
        
    }
    
    @objc func update() {
        
        count = count + countFactor
        if(count >= 0){
            let mm = count / 60
            let ss = count % 60
            let timerTotal = mm * 60 + ss
            let timerDict:[String: Int] = ["timer": timerTotal]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "timerSet"), object: nil, userInfo: timerDict)
            print("Counter: ", count)
        } else {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "timerStopped"), object: nil, userInfo: nil)
            countdown?.invalidate()
            if prefs.playSound {
                playSiren()
            }
        }
        
    }
    
    @IBAction func heimPlusAction(_ sender: Any) {
        var heim = Int(self.heimScoreTextfield.stringValue)
        heim = heim! + 1
        self.heimScoreTextfield.stringValue = String(format: "%01d", heim!)
        let heimDict:[String: Int] = ["score": heim!]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "heimSet"), object: nil, userInfo: heimDict)
    }
    
    @IBAction func heimMinusAction(_ sender: Any) {
        var heim = Int(self.heimScoreTextfield.stringValue)
        heim = heim! - 1
        if heim! < 0 {
            heim = 0
        }
        self.heimScoreTextfield.stringValue = String(format: "%01d", heim!)
        let heimDict:[String: Int] = ["score": heim!]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "heimSet"), object: nil, userInfo: heimDict)
    }
    
    @IBAction func gastPlusAction(_ sender: Any) {
        var gast = Int(self.gastScoreTextfield.stringValue)
        gast = gast! + 1
        self.gastScoreTextfield.stringValue = String(format: "%01d", gast!)
        let gastDict:[String: Int] = ["score": gast!]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "gastSet"), object: nil, userInfo: gastDict)
    }
    
    @IBAction func gastMinusAction(_ sender: Any) {
        var gast = Int(self.gastScoreTextfield.stringValue)
        gast = gast! - 1
        if gast! < 0 {
            gast = 0
        }
        self.gastScoreTextfield.stringValue = String(format: "%01d", gast!)
        let gastDict:[String: Int] = ["score": gast!]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "gastSet"), object: nil, userInfo: gastDict)
    }
    
    @IBAction func timeSetAction(_ sender: Any) {
        let mm = Int(self.timeMinutenTextfield.stringValue) ?? 0
        let ss = Int(self.timeSekundenTextfield.stringValue) ?? 0
        let timerTotal = mm * 60 + ss
        let timerDict:[String: Int] = ["timer": timerTotal]
        let textDict:[String: String] = ["heim": self.heimTextfield.stringValue, "gast": self.gastTextfield.stringValue]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "timerSet"), object: nil, userInfo: timerDict)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "textSet"), object: nil, userInfo: textDict)
        count = timerTotal
        
        self.timeMinutenTextfield.stringValue = String(format: "%02d", mm)
        self.timeSekundenTextfield.stringValue = String(format: "%02d", ss)
    }
    
    @IBAction func timeStartAction(_ sender: Any) {
        print("start Timer")
        self.timeStartButton.isEnabled = false
        self.timeStopButton.isEnabled = true
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "timerStarted"), object: nil, userInfo: nil)
        countdown = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: (#selector(ControllerViewController.update)), userInfo: nil, repeats: true)
        
    }
    
    @IBAction func timeStopAction(_ sender: Any) {
        print("stop Timer")
        self.timeStartButton.isEnabled = true
        self.timeStopButton.isEnabled = false
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "timerStopped"), object: nil, userInfo: nil)
        countdown?.invalidate()
    }

    @IBAction func resetAction(_ sender: Any) {
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "timerStopped"), object: nil, userInfo: nil)
        countdown?.invalidate()
        
        self.heimTextfield.stringValue = "Heim"
        self.gastTextfield.stringValue = "Gast"
        self.heimScoreTextfield.stringValue = String(format: "%01d", 0)
        self.gastScoreTextfield.stringValue = String(format: "%01d", 0)
        self.timeMinutenTextfield.stringValue = String(format: "%02d", Int(prefs.defaultMinuten))
        self.timeSekundenTextfield.stringValue = String(format: "%02d", Int(prefs.defaultSekunden))
        
        self.timeSetAction(sender)
        
        self.timeStartButton.isEnabled = true
        self.timeStopButton.isEnabled = false
        
        let heimDict:[String: Int] = ["score": 0]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "heimSet"), object: nil, userInfo: heimDict)
        let gastDict:[String: Int] = ["score": 0]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "gastSet"), object: nil, userInfo: gastDict)
    }
    
    @IBAction func radioSettingChanged(_ sender: NSButton) {
        
        if settingCountdownButton.state == NSControl.StateValue.on {
            countFactor = -1
        } else if settingTimerButton.state == NSControl.StateValue.on {
            countFactor = 1
        }
        
    }
    
    @objc func timerSet(_ notification: NSNotification) {
        count = (notification.userInfo?["timer"] as? Int)!
        let minutes = String(format: "%02d", count / 60)
        let seconds = String(format: "%02d", count % 60)
        timeControlTextfield.stringValue = minutes + ":" + seconds
    }
    
    @IBAction func changePlaySoundAction(_ sender: NSButton) {
        if sireneCheckbox.state == NSControl.StateValue.on {
            prefs.playSound = true
        } else {
            prefs.playSound = false
        }
        print("Siren is: ", prefs.playSound)
    }
    
}
