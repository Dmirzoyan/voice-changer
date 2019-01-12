//
//  SoundPlayerViewStateFactory.swift
//  PitchPerfect
//
//  Created by Davit Mirzoyan on 1/12/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation

protocol SoundPlayerViewStateProducing {
    func make(playingState: PlayingState) -> SoundPlayerViewState
}

final class SoundPlayerViewStateFactory: SoundPlayerViewStateProducing {
    
    func make(playingState: PlayingState) -> SoundPlayerViewState {
        switch(playingState) {
        case .idle:
            return SoundPlayerViewState(
                playButtonsEnabled: true,
                stopButtonEnabled: false
            )
        case .playing:
            return SoundPlayerViewState(
                playButtonsEnabled: false,
                stopButtonEnabled: true
            )
        }
    }
}
