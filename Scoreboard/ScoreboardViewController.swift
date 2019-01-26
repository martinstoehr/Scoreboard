//
//  ScoreboardViewController.swift
//  Scoreboard
//
//  Created by Martin Stöhr on 15.12.17.
//  Copyright © 2017 Martin Stöhr. All rights reserved.
//

import Cocoa

class ScoreboardViewController: NSViewController  {

    @IBOutlet var heimTextfield: NSTextField!
    @IBOutlet var gastTextfield: NSTextField!
    
    @IBOutlet var heimScore: NSTextField!
    @IBOutlet var gastScore: NSTextField!
    @IBOutlet var timeLabel: NSTextField!
    @IBOutlet var timeStatusImage: NSImageView!
    
    var count: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(timerSet), name: NSNotification.Name(rawValue: "timerSet"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(heimSet), name: NSNotification.Name(rawValue: "heimSet"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(gastSet), name: NSNotification.Name(rawValue: "gastSet"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(textSet), name: NSNotification.Name(rawValue: "textSet"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(timerStarted), name: NSNotification.Name(rawValue: "timerStarted"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(timerStopped), name: NSNotification.Name(rawValue: "timerStopped"), object: nil)
        
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
            
        }
    }
    
    @objc func heimSet(_ notification: NSNotification) {
        let score = (notification.userInfo?["score"] as? Int)!
        heimScore.stringValue = String(format: "%01d", score)
    }
    
    @objc func gastSet(_ notification: NSNotification) {
        let score = (notification.userInfo?["score"] as? Int)!
        gastScore.stringValue = String(format: "%01d", score)
    }
    
    @objc func timerSet(_ notification: NSNotification) {
        print("set Timer")
        count = (notification.userInfo?["timer"] as? Int)!
        print(count)
        let minutes = String(format: "%02d", count / 60)
        let seconds = String(format: "%02d", count % 60)
        timeLabel.stringValue = minutes + ":" + seconds
    }
    
    @objc func textSet(_ notification: NSNotification) {
        print("set Text")
        let heimText = (notification.userInfo?["heim"] as? String)!
        let gastText = (notification.userInfo?["gast"] as? String)!
        self.heimTextfield.stringValue = heimText
        self.gastTextfield.stringValue = gastText
    }
    
    @objc func timerStarted(_ notification: NSNotification) {
        self.timeStatusImage.image = NSImage(named: "play")
    }
    
    @objc func timerStopped(_ notification: NSNotification) {
        self.timeStatusImage.image = NSImage(named: "pause")
    }


}
