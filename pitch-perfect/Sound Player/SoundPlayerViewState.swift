//
//  SoundPlayerViewState.swift
//  PitchPerfect
//
//  Created by Davit Mirzoyan on 1/12/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation

enum PlayingState { case idle, playing }

struct SoundPlayerViewState {
    let playButtonsEnabled: Bool
    let stopButtonEnabled: Bool
}
