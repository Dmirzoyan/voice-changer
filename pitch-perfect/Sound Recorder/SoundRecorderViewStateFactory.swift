//
//  SoundRecorderViewStateFactory.swift
//  PitchPerfect
//
//  Created by Davit Mirzoyan on 1/10/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation

final class SoundRecorderViewStateFactory {
    
    func make(recordingState: RecordingState) -> SoundRecorderViewState {        
        switch recordingState {
        case .readyToRecord:
            return SoundRecorderViewState(
                startRecordingEnabled: true,
                stopRecordingEnabled: false,
                description: "Tap to record"
            )
        case .recording:
            return SoundRecorderViewState(
                startRecordingEnabled: false,
                stopRecordingEnabled: true,
                description: "Recording..."
            )
        }
    }
}
