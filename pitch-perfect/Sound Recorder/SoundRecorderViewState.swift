//
//  SoundRecorderViewState.swift
//  PitchPerfect
//
//  Created by Davit Mirzoyan on 1/10/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation

enum RecordingState { case idle, recording }

struct SoundRecorderViewState {
    let startRecordingEnabled: Bool
    let stopRecordingEnabled: Bool
    let description: String
}
