//
//  SoundRecorderViewStateFactory.swift
//  PitchPerfect
//
//  Created by Davit Mirzoyan on 1/10/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation
import UIKit.UIImage

protocol SoundRecorderViewStateProducing {
    func make(recordingState: RecordingState) -> SoundRecorderViewState
}

final class SoundRecorderViewStateFactory: SoundRecorderViewStateProducing {
    
    func make(recordingState: RecordingState) -> SoundRecorderViewState {
        switch recordingState {
        case .idle:
            return SoundRecorderViewState(
                buttonIcon: UIImage(named: "recordButton"),
                description: "Tap to start recording"
            )
        case .recording:
            return SoundRecorderViewState(
                buttonIcon: UIImage(named: "Stop"),
                description: "Tap to stop recording"
            )
        }
    }
}
