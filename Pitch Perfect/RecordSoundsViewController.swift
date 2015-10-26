//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Scott Baumbich on 10/1/15.
//  Copyright © 2015 Glazed. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    var audioRecorder: AVAudioRecorder!
    var recordedAudio: RecordedAudio!
    
    @IBOutlet weak var recordingInProgress: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var resumeButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func refreshSettings(){
        recordingInProgress.text = "Tap to Record"
        
        stopButton.hidden = true
        resumeButton.hidden = true
        pauseButton.hidden = true
        
        recordButton.enabled = true
    }
    
    override func viewWillAppear(animated: Bool){
        refreshSettings()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func recordAudio(sender: UIButton) {
        print("Recording Button Pressed")
        recordingInProgress.text = "Recording..."
        
        stopButton.hidden = false
        resumeButton.hidden = false
        pauseButton.hidden = false
        
        recordButton.enabled = false
        pauseButton.enabled = true
        resumeButton.enabled = false
        
        
        //Record the users voice
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let recordingName = "my_audio.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        try! audioRecorder = AVAudioRecorder(URL: filePath!, settings: [:])
             audioRecorder.delegate = self
             audioRecorder.meteringEnabled = true
             audioRecorder.prepareToRecord()
             audioRecorder.record()
    }
    
    @IBAction func stopAudio(sender: UIButton) {
        // Stop Audio recording
        audioRecorder.stop()
        recordingInProgress.text = ""
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    @IBAction func pauseAudio(sender: UIButton) {
        // Pause Audio Recording
        recordingInProgress.text = "Paused"
        resumeButton.enabled = true
        audioRecorder.pause()
        pauseButton.enabled = false
    }
    
    @IBAction func resumeAudio(sender: UIButton) {
        // Resume Audio Recording
        recordingInProgress.text = "Recording"
        audioRecorder.record()
        pauseButton.enabled = true
        resumeButton.enabled = false
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if(flag) {
            recordedAudio = RecordedAudio(filePathUrl: recorder.url, title: recorder.url.lastPathComponent!)
            recordedAudio.filePathUrl = recorder.url
            
            performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        }
        else {
            print("Recording Was Not Successful")
            refreshSettings()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "stopRecording"){
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }
}

