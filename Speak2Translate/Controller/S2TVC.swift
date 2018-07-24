//
//  S2TVC.swift
//  Speak2Translate
//
//  Created by Arjun Singh on 24/07/18.
//  Copyright © 2018 Arjun Singh. All rights reserved.
//

import UIKit
import Speech

class S2TVC: UIViewController {
    
    //MARK: - Languages Selected by User
    
    var inputLanguage: Language = Language(identifier: "N/A", name: "N/A") {
        didSet {
            
            let identifier = inputLanguage.identifier.removeCountryCode()
            let locale = Locale(identifier: identifier)
            
            print("didSet inputLanguage identifier : \(identifier)")
            
            speechRecognizer = SFSpeechRecognizer(locale: locale)
        }
    }
    var outputLanguage: Language = Language(identifier: "N/A", name: "N/A")
    
    //MARK: - Record Button Variables
    var progressTimer: Timer = Timer()
    var progress: CGFloat = 0
    
    //MARK: - Connect UI Elements
    @IBOutlet weak var inputLanguageLabel: UILabel!
    @IBOutlet weak var outputLanguageLabel: UILabel!
    @IBOutlet weak var detectedTextLabel: UILabel!
    @IBOutlet weak var translatedTextLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    
    //MARK: - Declare and Initialise Speech Recognition properties
    
    let audioEngine = AVAudioEngine()
    var speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer()
    let recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
    var recognitionTask: SFSpeechRecognitionTask?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: - Set up Input and Output Language Labels
        inputLanguageLabel.text = inputLanguage.name
        outputLanguageLabel.text = outputLanguage.name
        
        self.requestSpeechAuthorization()
        // self.setUpRecordButton()
    }
    
    //MARK: IBActions and Cancel
    
    @IBAction func recordButtonPressed(_ sender: UIButton) {
        if audioEngine.isRunning {
            stopRecording()
            cancelRecording()
            // recordButton.titleLabel?.text = "Start"
        } else {
            // recordButton.titleLabel?.text = "Stop"
            self.recordAndRecognizeSpeech()
        }
    }
    
    
    
    //MARK: - Alert Message
    
    func sendAlert(message: String) {
        let alert = UIAlertController(title: "Speech Recognizer Error", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension S2TVC: SFSpeechRecognizerDelegate {
    
    //MARK: - Cancel / Finish recognition task
    
    func cancelRecording() {
        recognitionTask?.cancel()
        audioEngine.inputNode.removeTap(onBus: 0)
    }
    
    //MARK: - Stop Recording
    @objc func stopRecording() {
        audioEngine.stop()
        recognitionRequest.endAudio()
    }
    
    //MARK: - Record and Recognize Speech
    
    func recordAndRecognizeSpeech() {
        
        let node = audioEngine.inputNode
        let recordingFormat = node.outputFormat(forBus: 0)
        node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            self.recognitionRequest.append(buffer)
        }
        
        audioEngine.prepare()
        
        do {
            try audioEngine.start()
        } catch {
            self.sendAlert(message: "There has been an audio engine error.")
            return print(error)
        }
        
        guard let myRecognizer = SFSpeechRecognizer() else {
            self.sendAlert(message: "Speech recognition is not supported for your current locale.")
            return
        }
        
        if !myRecognizer.isAvailable {
            self.sendAlert(message: "Speech recognition is not currently available. Check back at a later time.")
            // Recognizer is not available right now
            return
        }
        
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { result, error in
            if let result = result {
                
                // Update input label
                let bestString = result.bestTranscription.formattedString
                self.detectedTextLabel.text = bestString
                
                // Translate and update output label
                print(self.inputLanguage.identifier)
                print(self.outputLanguage.identifier)
                Translator.requestTranslation(source: self.inputLanguage.identifier.removeCountryCode(), target: self.outputLanguage.identifier, textToTranslate: bestString, completion: {
                    (isSuccesful, result) in
                    if isSuccesful {
                        self.translatedTextLabel.text = result
                    }  else {
                        print(isSuccesful)
                    }
                    
                })
                
                var lastString: String = ""
                for segment in result.bestTranscription.segments {
                    let indexTo = bestString.index(bestString.startIndex, offsetBy: segment.substringRange.location)
                    lastString = String(bestString[indexTo...])
                }
                self.checkForColorsSaid(resultString: lastString)
                
            } else if let error = error {
                // self.sendAlert(message: "There has been a speech recognition error.")
                
                self.viewDidLoad()
                print(error)
            }
        })
    }
    
    //MARK: - Check Authorization Status
    
    func requestSpeechAuthorization() {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            OperationQueue.main.addOperation {
                switch authStatus {
                case .authorized:
                    self.recordButton.isEnabled = true
                case .denied:
                    self.recordButton.isEnabled = false
                    self.detectedTextLabel.text = "User denied access to speech recognition"
                case .restricted:
                    self.recordButton.isEnabled = false
                    self.detectedTextLabel.text = "Speech recognition restricted on this device"
                case .notDetermined:
                    self.recordButton.isEnabled = false
                    self.detectedTextLabel.text = "Speech recognition not yet authorized"
                }
            }
        }
    }
    
    //MARK: - Set color to colorView.
    
    func checkForColorsSaid(resultString: String) {
        
    }
}
