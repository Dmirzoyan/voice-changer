//
//  ViewController.swift
//  pitch-perfect
//
//  Created by Davit Mirzoyan on 12/27/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import UIKit
import AVFoundation

protocol SoundRecorderInteracting {
    func startStopRecording()
}

final class SoundRecorderViewController: UIViewController {

    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var startStopRecordingButton: UIButton!
    
    private var interactor: SoundRecorderInteracting!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyStyling()
        
        interactor = SoundRecorderInteractor(
            soundRecorder: SoundRecorder(),
            router: SoundRecorderRouter(display: self),
            presenter: SoundRecorderPresenter(
                display: self,
                viewStateFactory: SoundRecorderViewStateFactory()
            )
        )
    }
    
    private func applyStyling() {
        view.backgroundColor = UIColor.AppTheme.darkGreen
        recordingLabel.textColor = UIColor.AppTheme.lightGreen
        
        setupTitle()
        applyNavigationBarStyle()
    }
    
    private func setupTitle() {
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        title = "Pitch Perfect"
    }
    
    private func applyNavigationBarStyle() {
        guard let navigationBar = navigationController?.navigationBar
        else { return }
        
        navigationBar.barStyle = .blackTranslucent
        navigationBar.barTintColor = UIColor.AppTheme.darkGreen
        navigationBar.isTranslucent = false
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
    }

    @IBAction func startStopRecordingAudio(_ sender: UIButton) {
        interactor.startStopRecording()
        sender.pulsate()
    }
}

extension SoundRecorderViewController: SoundRecorderDisplaying {
    
    func display(_ viewState: SoundRecorderViewState) {
        startStopRecordingButton.setImage(viewState.buttonIcon, for: .normal)
        recordingLabel.text = viewState.description
    }
}
