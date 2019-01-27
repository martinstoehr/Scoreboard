//
//  EinstellungenViewController.swift
//  Scoreboard
//
//  Created by Martin Stöhr on 26.01.19.
//  Copyright © 2019 Martin Stöhr. All rights reserved.
//

import Cocoa

class EinstellungenViewController: NSViewController {

    @IBOutlet var minutenPresetTextfield: NSTextField!
    @IBOutlet var sekundenPresetTextfield: NSTextField!
    @IBOutlet var minutenStepper: NSStepper!
    @IBOutlet var sekundenStepper: NSStepper!
    @IBOutlet var soundSelectPopup: NSPopUpButton!
    @IBOutlet var versionTextfield: NSTextField!
    
    var prefs = Einstellungen()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        let dictionary = Bundle.main.infoDictionary!
        let version = dictionary["CFBundleShortVersionString"] as! String
        let build = dictionary["CFBundleVersion"] as! String
        versionTextfield.stringValue = "\(version) [\(build)]"
        
        minutenStepper.doubleValue = prefs.defaultMinuten
        sekundenStepper.doubleValue = prefs.defaultSekunden
        
        minutenPresetTextfield.stringValue = String(format: "%02.0f", prefs.defaultMinuten)
        sekundenPresetTextfield.stringValue = String(format: "%02.0f", prefs.defaultSekunden)
        
    }
    
    @IBAction func minutenChangeAction(_ sender: NSStepper) {
        
        let minute = sender.doubleValue
        //print(minute)
        self.minutenPresetTextfield.stringValue = String(format: "%02.0f", minute)
        prefs.defaultMinuten = minute
        
    }
    
    @IBAction func sekundenChangeAction(_ sender: NSStepper) {
        
        let seconds = sender.doubleValue
        //print(seconds)
        self.sekundenPresetTextfield.stringValue = String(format: "%02.0f", seconds)
        prefs.defaultSekunden = seconds
        
    }
    
    
}
