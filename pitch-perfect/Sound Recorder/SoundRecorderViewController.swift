//
//  ViewController.swift
//  pitch-perfect
//
//  Created by Davit Mirzoyan on 12/27/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import UIKit
import AVFoundation

final class SoundRecorderViewController: UIViewController {

    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var startStopRecordingButton: UIButton!
    
    private let soundRecorderViewStateFactory: SoundRecorderViewStateProducing = SoundRecorderViewStateFactory()
    private var audioRecorder: AVAudioRecorder!
    private var recordingState: RecordingState = .idle
    private let backgroundColor = UIColor(red: 0.128, green: 0.175, blue: 0.191, alpha: 1)
    private let textColor = UIColor(red: 0.428, green: 0.475, blue: 0.491, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyStyling()
    }
    
    private func applyStyling() {
        view.backgroundColor = backgroundColor
        recordingLabel.textColor = textColor
        
        setupTitle()
        applyNavigationBarStyle()
    }
    
    private func setupTitle() {
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        title = "Pitch Perfect"
    }
    
    private func applyNavigationBarStyle() {
        guard let navigationBar = navigationController?.navigationBar
            else { return }
        
        navigationBar.barStyle = .blackTranslucent
        navigationBar.barTintColor = backgroundColor
        navigationBar.isTranslucent = false
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
    }

    @IBAction func startStopRecordingAudio(_ sender: Any) {
        var viewState: SoundRecorderViewState
        
        switch recordingState {
        case .idle:
            startRecording()
            viewState = soundRecorderViewStateFactory.make(recordingState: .recording)
            recordingState = .recording
        case .recording:
            stopRecording()
            recordingState = .idle
            viewState = soundRecorderViewStateFactory.make(recordingState: .idle)
        }
        
        display(viewState)
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
    
    private func display(_ viewState: SoundRecorderViewState) {
        startStopRecordingButton.setImage(viewState.buttonIcon, for: .normal)
        recordingLabel.text = viewState.description
    }
}

extension SoundRecorderViewController: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        guard flag == true
        else { return }
        
        performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let url = sender as? URL
        else { return }
        
        if segue.identifier == "stopRecording" {
            guard let soundPlayerViewController = segue.destination as? SoundPlayerViewController
                else { return }
            
            let soundPlayer = SoundPlayer(recordedAudioUrl: url, display: soundPlayerViewController)
            soundPlayerViewController.soundPlayer = soundPlayer
        }
    }
}

