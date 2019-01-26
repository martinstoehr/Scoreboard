//
//  ControllerViewController.swift
//  Scoreboard
//
//  Created by Martin Stöhr on 05.01.18.
//  Copyright © 2018 Martin Stöhr. All rights reserved.
//

import Cocoa

class ControllerViewController: NSViewController {

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
    
    var count: Int = 0
    var countdown: Timer?
    var countFactor: Int = -1
    
    var prefs = Einstellungen()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        timeMinutenTextfield.stringValue = String(format: "%02.0f", prefs.defaultMinuten)
        timeSekundenTextfield.stringValue = String(format: "%02.0f", prefs.defaultSekunden)
        
        NotificationCenter.default.addObserver(self, selector: #selector(timerSet), name: NSNotification.Name(rawValue: "timerSet"), object: nil)

    }
    
    override func viewDidAppear() {
        self.performSegue(withIdentifier: "ScoreboardSegue", sender: self)
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
        let mm = Int(self.timeMinutenTextfield.stringValue)
        let ss = Int(self.timeSekundenTextfield.stringValue)
        let timerTotal = mm! * 60 + ss!
        let timerDict:[String: Int] = ["timer": timerTotal]
        let textDict:[String: String] = ["heim": self.heimTextfield.stringValue, "gast": self.gastTextfield.stringValue]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "timerSet"), object: nil, userInfo: timerDict)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "textSet"), object: nil, userInfo: textDict)
        count = timerTotal
    }
    
    @IBAction func timeStartAction(_ sender: Any) {
        print("start Timer")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "timerStarted"), object: nil, userInfo: nil)
        countdown = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: (#selector(ControllerViewController.update)), userInfo: nil, repeats: true)
        
    }
    
    @IBAction func timeStopAction(_ sender: Any) {
        print("stop Timer")
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
        self.timeMinutenTextfield.stringValue = String(format: "%02d", 12)
        self.timeSekundenTextfield.stringValue = String(format: "%02d", 0)
        
        self.timeSetAction(self)
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
    
}
