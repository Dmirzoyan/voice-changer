//
//  SoundRecorderPresenter.swift
//  PitchPerfect
//
//  Created by Davit Mirzoyan on 1/14/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation

protocol SoundRecorderDisplaying: class {
    func display(_ viewState: SoundRecorderViewState)
}

final class SoundRecorderPresenter: SoundRecorderPresenting {
    
    private weak var display: SoundRecorderDisplaying?
    private let viewStateFactory: SoundRecorderViewStateProducing
    
    init(
        display: SoundRecorderDisplaying,
        viewStateFactory: SoundRecorderViewStateProducing
    ) {
        self.display = display
        self.viewStateFactory = viewStateFactory
    }
    
    func present(_ recordingState: RecordingState) {
        let viewState = viewStateFactory.make(recordingState: recordingState)
        display?.display(viewState)
    }
}
