//
//  SoundRecorderRouter.swift
//  PitchPerfect
//
//  Created by Davit Mirzoyan on 1/14/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit

protocol SoundRecorderInternalRouting {
    func goToSoundPlayerView(audioFileUrl: URL)
}

final class SoundRecorderRouter {
    
    private weak var display: UIViewController?
    
    init(display: UIViewController) {
        self.display = display
    }
}

extension SoundRecorderRouter: SoundRecorderInternalRouting {
    
    func goToSoundPlayerView(audioFileUrl: URL) {
        guard let soundPlayerViewController = UIStoryboard.init(
            name: "Main",
            bundle: Bundle.main
        ).instantiateViewController(withIdentifier: "SoundPlayerViewController") as? SoundPlayerViewController
        else { return }
        
        let soundPlayer = SoundPlayer(recordedAudioUrl: audioFileUrl, display: soundPlayerViewController)
        soundPlayerViewController.soundPlayer = soundPlayer
        display?.navigationController?.pushViewController(soundPlayerViewController, animated: true)
    }
}
