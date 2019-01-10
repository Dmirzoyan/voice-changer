//
//  ViewController.swift
//  pitch-perfect
//
//  Created by Davit Mirzoyan on 12/27/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import UIKit
import AVFoundation

final class SoundRecorderViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    private var audioRecorder: AVAudioRecorder!
    private var soundRecorderViewStateFactory = SoundRecorderViewStateFactory()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stopRecordingButton.isEnabled = false
    }

    @IBAction func recordAudio(_ sender: Any) {
        let viewState = soundRecorderViewStateFactory.make(recordingState: .recording)
        display(viewState)
        startRecording()
    }
    
    @IBAction func stopRecording(_ sender: Any) {
        let viewState = soundRecorderViewStateFactory.make(recordingState: .readyToRecord)
        display(viewState)
        stopRecording()
    }
    
    private func startRecording() {
        let dirtPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirtPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(.playAndRecord, mode: .default, options: .defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    private func stopRecording() {
        audioRecorder.stop()
        let session = AVAudioSession.sharedInstance()
        try! session.setActive(false)
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        guard flag == true
        else { return }
        
        performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let soundPlayerViewController = segue.destination as? SoundPlayerViewController
            soundPlayerViewController?.recordedAudioUrl = sender as? URL
        }
    }
    
    private func display(_ viewState: SoundRecorderViewState) {
        recordButton.isEnabled = viewState.startRecordingEnabled
        stopRecordingButton.isEnabled = viewState.stopRecordingEnabled
        recordingLabel.text = viewState.description
    }
}

