//
//  ScoreboardViewController.swift
//  Scoreboard
//
//  Created by Martin Stöhr on 15.12.17.
//  Copyright © 2017 Martin Stöhr. All rights reserved.
//

import Cocoa

class ScoreboardViewController: NSViewController  {

    @IBOutlet var heimScore: VerticallyAlignedTextFieldCell!
    @IBOutlet var gastScore: VerticallyAlignedTextFieldCell!
    @IBOutlet var timeLabel: VerticallyAlignedTextFieldCell!
    
    var count: Int = 0
    var countdown: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(timerSet), name: NSNotification.Name(rawValue: "timerSet"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(timerStart), name: NSNotification.Name(rawValue: "timerStart"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(timerStop), name: NSNotification.Name(rawValue: "timerStop"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(heimSet), name: NSNotification.Name(rawValue: "heimSet"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(gastSet), name: NSNotification.Name(rawValue: "gastSet"), object: nil)
        
    }
    
    override func viewDidAppear() {
        
//        let presOptions: NSApplication.PresentationOptions = [.autoHideMenuBar, .hideDock , .fullScreen, .autoHideToolbar]
//        //let presOptions: NSApplication.PresentationOptions = []
//        
//        let optionsDictionary = [NSView.FullScreenModeOptionKey.fullScreenModeApplicationPresentationOptions:presOptions.rawValue]
//        
//        self.view.enterFullScreenMode(NSScreen.main!, withOptions:optionsDictionary)
//        self.view.wantsLayer = true
        
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
            
        }
    }
    
//    override func keyDown(with event: NSEvent) {
//        print("key ")
//        if (event.keyCode == 6) {
//            print("Y")
//        } else if (event.keyCode == 7) {
//            print("X")
//        } else if (event.keyCode == 45) {
//            print("N")
//        } else if (event.keyCode == 46) {
//            print("M")
//        }
//    }
    
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
    
    @objc func timerStart() {
        print("start Timer")
        countdown = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: (#selector(ScoreboardViewController.update)), userInfo: nil, repeats: true)
    }
    
    @objc func timerStop() {
        print("stop Timer")
        countdown?.invalidate()
    }
    
    @objc func update() {
        
        if(count > 0){
            let minutes = String(format: "%02d", count / 60)
            let seconds = String(format: "%02d", count % 60)
            timeLabel.stringValue = minutes + ":" + seconds
            count = count - 1
        }
        
    }


}
class VerticallyAlignedTextFieldCell: NSTextFieldCell {
    override func drawingRect(forBounds rect: NSRect) -> NSRect {
        let newRect = NSRect(x: 0, y: (rect.size.height - 22) / 2, width: rect.size.width, height: 22)
        return super.drawingRect(forBounds: newRect)
    }
}
