//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Scott Baumbich on 10/1/15.
//  Copyright © 2015 Glazed. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    // Global variables
    var receivedAudio: RecordedAudio!
    var audioPlayerNode: AVAudioPlayerNode!
    var audioEngine: AVAudioEngine!
    var audioFile: AVAudioFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Sets audio to play through phone speaker
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord, withOptions: .DefaultToSpeaker)
            }
            catch let error as NSError {
                print(error.localizedDescription)
            }
        
        // Gets recorded audio file
        audioFile = try! AVAudioFile(forReading: receivedAudio.filePathUrl)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Binds effects to each buttion
    }
    @IBAction func playSlowAudio(sender: UIButton) {
        print("Slow Button Presed")
        playAudio(1200, speed: 0.5, reverb: 0, echo: 0)
    }
    @IBAction func playFastAudio(sender: UIButton) {
        print("Fast Button Pressed")
        playAudio(-700, speed: 1.5, reverb: 0, echo: 0)
    }
    @IBAction func playChipmunkAudio(sender: UIButton) {
        print("Chimpmonk Button Pressed")
        playAudio(1400, speed: 1.0, reverb: 0, echo: 0)
    }
    @IBAction func playDarthvaderAudio(sender: UIButton) {
        print("Darth Vader Button Pressed")
        playAudio(-800, speed: 1.1, reverb: 0, echo: 0)
    }
    @IBAction func playEchoAudio(sender: UIButton) {
        print("Echo Button Pressed")
        playAudio(0, speed: 1, reverb: 0, echo: 0.2)
    }
    @IBAction func playReverbAudio(sender: UIButton) {
        print("Reverb Button Pressed")
        playAudio(0, speed: 1, reverb: 50.0, echo: 0)
    }
    @IBAction func stopAudio(sender: UIButton) {
        print("Stop Button Pressed (PlaysoundsViewController)")
        playAudio(0, speed: 0.1, reverb: 0, echo: 0)
        audioPlayerNode.stop()
    }
    
    // Refrence To Unit Measurements: https://developer.apple.com/library/prerelease/ios/documentation/AVFoundation/Reference/AVAudioUnitVarispeed_Class/index.html#//apple_ref/occ/instp/AVAudioUnitVarispeed/rate
    
    private func playAudio(pitch : Float, speed: Float, reverb: Float, echo: Float) {
        // Initialize variables
        audioEngine = AVAudioEngine()
        audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        // Set pitch
        let pitchEffect = AVAudioUnitTimePitch()
        pitchEffect.pitch = pitch
        audioEngine.attachNode(pitchEffect)
        
        // Set platback speed
        let playbackRateEffect = AVAudioUnitVarispeed()
        playbackRateEffect.rate = speed
        audioEngine.attachNode(playbackRateEffect)
        
        // Set reverb
        let reverbEffect = AVAudioUnitReverb()
        reverbEffect.loadFactoryPreset(AVAudioUnitReverbPreset.Cathedral)
        reverbEffect.wetDryMix = reverb
        audioEngine.attachNode(reverbEffect)
        
        // Set echo
        let echoEffect = AVAudioUnitDelay()
        echoEffect.delayTime = NSTimeInterval(echo)
        audioEngine.attachNode(echoEffect)
        
        // Chain nodes
        audioEngine.connect(audioPlayerNode, to: playbackRateEffect, format: nil)
        audioEngine.connect(playbackRateEffect, to: pitchEffect, format: nil)
        audioEngine.connect(pitchEffect, to: reverbEffect, format: nil)
        audioEngine.connect(reverbEffect, to: echoEffect, format: nil)
        audioEngine.connect(echoEffect, to: audioEngine.outputNode, format: nil)
        
        // Play audio
        audioPlayerNode.stop()
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        try! audioEngine.start()
        audioPlayerNode.play()
    }
    
}
