//
//  MainWindowController.swift
//  SpeakLine
//
//  Created by Dennis Nguyen on 7/23/15.
//  Copyright (c) 2015 dnwin. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController, NSSpeechSynthesizerDelegate,
                            NSWindowDelegate {
    
    @IBOutlet weak var textField: NSTextField!
    @IBOutlet weak var speakButton: NSButton!
    @IBOutlet weak var stopButton: NSButton!
    
    let speechSynth = NSSpeechSynthesizer()
    
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
}
