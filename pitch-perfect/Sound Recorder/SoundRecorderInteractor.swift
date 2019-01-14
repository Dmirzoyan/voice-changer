//
//  SoundRecorderInteractor.swift
//  PitchPerfect
//
//  Created by Davit Mirzoyan on 1/14/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation

protocol SoundRecorderPresenting {
    func present(_ recordingState: RecordingState)
}

final class SoundRecorderInteractor: SoundRecorderInteracting {
    
    private let soundRecorder: SoundRecording
    private let router: SoundRecorderInternalRouting
    private let presenter: SoundRecorderPresenting
    private var recordingState: RecordingState = .idle
    
    init(
        soundRecorder: SoundRecording,
        router: SoundRecorderInternalRouting,
        presenter: SoundRecorderPresenting
    ) {
        self.soundRecorder = soundRecorder
        self.router = router
        self.presenter = presenter
    }
    
    func startStopRecording() {
        switch recordingState {
        case .idle:
            soundRecorder.startRecording()
            recordingState = .recording
        case .recording:
            soundRecorder.stopRecording(completion: { [weak self] url in
                self?.router.goToSoundPlayerView(audioFileUrl: url)
            })
            recordingState = .idle
        }
        
        presenter.present(recordingState)
    }
}
