//
//  SoundRecorder.swift
//  PitchPerfect
//
//  Created by Davit Mirzoyan on 1/14/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation
import AVFoundation

typealias RecordingCompletion = (URL) -> Void

protocol SoundRecording {
    func startRecording()
    func stopRecording(completion: @escaping RecordingCompletion)
}

final class SoundRecorder: NSObject, SoundRecording {
    
    private var audioRecorder: AVAudioRecorder!
    private var recordingCompletion: RecordingCompletion?
    
    func startRecording() {
        guard let filePath = filePath()
        else { return }
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(.playAndRecord, mode: .default, options: .defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    func stopRecording(completion: @escaping RecordingCompletion) {
        recordingCompletion = completion
        audioRecorder.stop()
        let session = AVAudioSession.sharedInstance()
        try! session.setActive(false)
    }
    
    private func filePath() -> URL? {
        let dirtPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirtPath, recordingName]
        
        return URL(string: pathArray.joined(separator: "/"))
    }
}

extension SoundRecorder: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        guard flag == true
        else { return }
        
        recordingCompletion?(recorder.url)
    }
}

