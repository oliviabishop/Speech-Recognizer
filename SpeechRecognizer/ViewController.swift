//
//  ViewController.swift
//  SpeechRecognizer
//
//  Created by Olivia Bishop on 8/29/19.
//  Copyright © 2019 Olivia Bishop. All rights reserved.
//

import UIKit
import Speech

class ViewController: UIViewController, SFSpeechRecognizerDelegate{
    
    let audioEngine = AVAudioEngine()
    let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer()
    let request = SFSpeechAudioBufferRecognitionRequest()
    var recognitionTask: SFSpeechRecognitionTask? = nil
    
    
    
    
    @IBOutlet weak var startButton: UIButton!
    
    @IBOutlet weak var textLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func StartClicked(_ sender: Any) {
        self.recordSpeech()
        
       
    }
    
    func recordSpeech() {
        
        let node = audioEngine.inputNode 
        let format = node.outputFormat(forBus: 0)
        node.installTap(onBus: 0 , bufferSize: 1024, format: format) {buffer, _ in
            self.request.append(buffer)
        }
        
        audioEngine.prepare()
        do{
            try audioEngine.start()
        } catch {
            return print(error)
        }
        
        guard let recognizer = SFSpeechRecognizer() else {
            
            return
        }
        
        if !recognizer.isAvailable {
            
            return
        }
       
        recognitionTask = speechRecognizer?.recognitionTask(with: request, resultHandler: {result, error  in if let result = result {
            
            let string = result.bestTranscription.formattedString
            self.textLabel.text = string
            
            }
        else if let error = error {
            
            print(error)
            }
            
        } )
        
    }
    
}
