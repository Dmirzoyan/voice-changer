//
//  SoundRecorderViewState.swift
//  PitchPerfect
//
//  Created by Davit Mirzoyan on 1/10/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation
import UIKit.UIImage

enum RecordingState { case idle, recording }

struct SoundRecorderViewState {
    let buttonIcon: UIImage?
    let description: String
}
