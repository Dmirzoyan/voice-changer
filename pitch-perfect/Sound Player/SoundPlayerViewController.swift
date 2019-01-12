//
//  SoundPlayerViewController.swift
//  PitchPerfect
//
//  Created by Davit Mirzoyan on 1/5/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit
import AVFoundation

final class SoundPlayerViewController: UIViewController {
    
    @IBOutlet weak var snailButton: UIButton!
    @IBOutlet weak var chipmunkButton: UIButton!
    @IBOutlet weak var rabbitButton: UIButton!
    @IBOutlet weak var vaderButton: UIButton!
    @IBOutlet weak var echoButton: UIButton!
    @IBOutlet weak var reverbButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var soundFilterLabel: UILabel!
    @IBOutlet weak var recordNewSoundButton: UIButton!
    
    var soundPlayer: SoundPlayer!
    
    enum ButtonType: Int {
        case slow = 0, fast, chipmunk, vader, echo, reverb
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyStyle()
        soundPlayer.setupAudio()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor = UIColor.AppTheme.darkGreen
        configureUI(.notPlaying)
    }
    
    private func applyStyle() {
        navigationItem.setHidesBackButton(true, animated:false);
        soundFilterLabel.textColor = UIColor.AppTheme.lightGreen
        recordNewSoundButton.setTitleColor(UIColor.AppTheme.brightGreen, for: .normal)
        
        setupTitle()
        addButtonConstraints()
    }
    
    private func setupTitle() {
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        title = "Pitch Perfect"
    }
    
    @IBAction func playSoundForButton(_ sender: UIButton) {
        guard let buttonTag = ButtonType(rawValue: sender.tag)
        else { return }
        
        switch buttonTag {
        case .slow:
            soundPlayer.playSound(rate: 0.5)
        case .fast:
            soundPlayer.playSound(rate: 1.5)
        case .chipmunk:
            soundPlayer.playSound(pitch: 1000)
        case .vader:
            soundPlayer.playSound(pitch: -1000)
        case .echo:
            soundPlayer.playSound(echo: true)
        case .reverb:
            soundPlayer.playSound(reverb: true)
        }
    }
    
    @IBAction func stopButtonPressed(_ sender: UIButton) {
        soundPlayer.stopAudio()
    }
    
    @IBAction func recordNewSound(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    private func addButtonConstraints() {
        snailButton.imageView?.contentMode = .scaleAspectFit
        chipmunkButton.imageView?.contentMode = .scaleAspectFit
        rabbitButton.imageView?.contentMode = .scaleAspectFit
        vaderButton.imageView?.contentMode = .scaleAspectFit
        echoButton.imageView?.contentMode = .scaleAspectFit
        reverbButton.imageView?.contentMode = .scaleAspectFit
    }
}

extension SoundPlayerViewController: SoundPlayerDisplaying {
    
    func configureUI(_ playState: PlayingState) {
        switch(playState) {
        case .playing:
            setPlayButtons(enabled: false)
            stopButton.isEnabled = true
        case .notPlaying:
            setPlayButtons(enabled: true)
            stopButton.isEnabled = false
        }
    }
    
    func showAlert(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Alerts.DismissAlert, style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func setPlayButtons(enabled: Bool) {
        snailButton.isEnabled = enabled
        chipmunkButton.isEnabled = enabled
        rabbitButton.isEnabled = enabled
        vaderButton.isEnabled = enabled
        echoButton.isEnabled = enabled
        reverbButton.isEnabled = enabled
    }
}
