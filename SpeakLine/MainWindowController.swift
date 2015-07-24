//
//  MainWindowController.swift
//  SpeakLine
//
//  Created by Dennis Nguyen on 7/23/15.
//  Copyright (c) 2015 dnwin. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController, NSSpeechSynthesizerDelegate,
                            NSWindowDelegate, NSTableViewDelegate, NSTableViewDataSource {
    
    @IBOutlet weak var textField: NSTextField!
    @IBOutlet weak var speakButton: NSButton!
    @IBOutlet weak var stopButton: NSButton!
    @IBOutlet weak var tableView: NSTableView!
    
    let speechSynth = NSSpeechSynthesizer()
    let voices = NSSpeechSynthesizer.availableVoices() as! [String]
    // State of speechSynth
    var isStarted: Bool = false {
        didSet {
            updateButtons()
        }
    }
    
    override var windowNibName: String {
        return "MainWindowController"
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        updateButtons()
        speechSynth.delegate = self
        
        
        // Print all voices
        for voice in voices {
            let voiceName = voiceNameForIdentifier(voice)
            println(voiceName)
        }
        
        // Preselect default voice in table
        let defaultVoice = NSSpeechSynthesizer.defaultVoice()
        // Search for index of default voice in voices array
        if let defaultRow = find(voices, defaultVoice) {
            tableView.scrollRowToVisible(defaultRow)
            // Convert int to NSIndexSet then set selection
            let indices = NSIndexSet(index: defaultRow)
            tableView.selectRowIndexes(indices, byExtendingSelection: false)

        }
    }
    
    // MARK: - Action Methods
    
    @IBAction func speakIt(sender: NSButton) {
        // Get input as string
        let string = textField.stringValue
        if (string.isEmpty) {
            println("string from \(textField) is empty")
        } else {
            println("string is \(textField.stringValue)")
            speechSynth.startSpeakingString(string)
            isStarted = true
        }
    }
    
    @IBAction func stopIt(sender: NSButton) {
        println("Stopping")
        speechSynth.stopSpeaking()
    }
    
    // Checks state of speech synth and enables/disables buttons
    func updateButtons() {
        if (isStarted) {
            speakButton.enabled = false
            stopButton.enabled = true
        } else {
            speakButton.enabled = true
            stopButton.enabled = false
        }
    }

    // Takes in voice identifier from voices array and returns simple string attribute name
    func voiceNameForIdentifier(identifier: String) -> String? {
        if let attributes = NSSpeechSynthesizer.attributesForVoice(identifier) {
            return attributes[NSVoiceName] as? String
        } else {
            return nil
        }
    }
    
    // MARK: - NSSpeechSynthesizerDelegate
    func speechSynthesizer(sender: NSSpeechSynthesizer, didFinishSpeaking finishedSpeaking: Bool) {
        isStarted = false
        println("finsihed speaking = \(finishedSpeaking)")
    }
    
    // MARK: - NSWindowDelegate
    
    // Notifies delegate and asks for permission if can close
    func windowShouldClose(sender: AnyObject) -> Bool {
        // Only allows closing if speech synthesizer is not started
        return !isStarted
    }
    
    // MARK: - NSTableViewDataSource
    
    // Set number of rows to total number of different voices
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return voices.count
    }
    
    func tableView(tableView: NSTableView, objectValueForTableColumn tableColumn: NSTableColumn?, row: Int) -> AnyObject? {
        let voice = voices[row]
        let voiceName = voiceNameForIdentifier(voice)
        
        return voiceName
    }
    
    // MARK: - NSTableViewDelegate
    
    func tableViewSelectionDidChange(notification: NSNotification) {
        let row = tableView.selectedRow
        
        // Set default if no row is selected
        if (row == -1) {
            speechSynth.setVoice(nil)
            return
        }
        
        let voice = voices[row]
        speechSynth.setVoice(voice)
    }
    
    

}
