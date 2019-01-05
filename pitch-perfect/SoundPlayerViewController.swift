//
//  SoundPlayerViewController.swift
//  PitchPerfect
//
//  Created by Davit Mirzoyan on 1/5/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit

class SoundPlayerViewController: UIViewController {
    
    @IBOutlet weak var snailButton: UIButton!
    @IBOutlet weak var chipmunkButton: UIButton!
    @IBOutlet weak var rabbitButton: UIButton!
    @IBOutlet weak var vaderButton: UIButton!
    @IBOutlet weak var echoButton: UIButton!
    @IBOutlet weak var reverbButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    var recordedAudioUrl: URL!
    
    @IBAction func playSoundForButton(_ sender: UIButton) {
        print("Play sound pressed")
    }
    
    @IBAction func stopButtonPressed(_ sender: UIButton) {
        print("Stop button pressed")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addButtonConstraints()
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
