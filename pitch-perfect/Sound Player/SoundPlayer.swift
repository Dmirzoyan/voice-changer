//
//  SoundPlayer.swift
//  PitchPerfect
//
//  Created by Davit Mirzoyan on 1/10/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation
import AVFoundation

protocol SoundPlayerDisplaying: class {
    func display(_ viewState: SoundPlayerViewState)
    func displayAlert(_ title: String, message: String)
}

final class SoundPlayer {
    
    private let recordedAudioUrl: URL
    private let audioEngine: AVAudioEngine
    private let audioPlayerNode: AVAudioPlayerNode
    private let viewStateFactory: SoundPlayerViewStateProducing
    private weak var display: SoundPlayerDisplaying?
    private var stopTimer: Timer?
    private var audioFile: AVAudioFile?
    
    init(
        recordedAudioUrl: URL,
        audioEngine: AVAudioEngine = AVAudioEngine(),
        audioPlayerNode: AVAudioPlayerNode = AVAudioPlayerNode(),
        viewStateFactory: SoundPlayerViewStateProducing = SoundPlayerViewStateFactory(),
        display: SoundPlayerDisplaying
    ) {
        self.recordedAudioUrl = recordedAudioUrl
        self.audioEngine = audioEngine
        self.audioPlayerNode = audioPlayerNode
        self.viewStateFactory = viewStateFactory
        self.display = display
    }
    
    // MARK: Audio Functions
    
    func setupAudio() {
        display?.display(viewStateFactory.make(playingState: .idle))
        
        // initialize (recording) audio file
        do {
            audioFile = try AVAudioFile(forReading: recordedAudioUrl as URL)
        } catch {
            display?.displayAlert(Alerts.AudioFileError, message: String(describing: error))
        }
    }
    
    func playSound(rate: Float? = nil, pitch: Float? = nil, echo: Bool = false, reverb: Bool = false) {
        
        guard let audioFile = audioFile
        else { return }
        
        audioEngine.attach(audioPlayerNode)
        
        // node for adjusting rate/pitch
        let changeRatePitchNode = AVAudioUnitTimePitch()
        if let pitch = pitch {
            changeRatePitchNode.pitch = pitch
        }
        if let rate = rate {
            changeRatePitchNode.rate = rate
        }
        audioEngine.attach(changeRatePitchNode)
        
        // node for echo
        let echoNode = AVAudioUnitDistortion()
        echoNode.loadFactoryPreset(.multiEcho1)
        audioEngine.attach(echoNode)
        
        // node for reverb
        let reverbNode = AVAudioUnitReverb()
        reverbNode.loadFactoryPreset(.cathedral)
        reverbNode.wetDryMix = 50
        audioEngine.attach(reverbNode)
        
        // connect nodes
        if echo == true && reverb == true {
            connectAudioNodes(audioPlayerNode, changeRatePitchNode, echoNode, reverbNode, audioEngine.outputNode)
        } else if echo == true {
            connectAudioNodes(audioPlayerNode, changeRatePitchNode, echoNode, audioEngine.outputNode)
        } else if reverb == true {
            connectAudioNodes(audioPlayerNode, changeRatePitchNode, reverbNode, audioEngine.outputNode)
        } else {
            connectAudioNodes(audioPlayerNode, changeRatePitchNode, audioEngine.outputNode)
        }
        
        // schedule to play and start the engine!
        audioPlayerNode.stop()
        audioPlayerNode.scheduleFile(audioFile, at: nil) { [weak self] in
            
            guard
                let strongSelf = self,
                let audioPlayerNode = self?.audioPlayerNode,
                let audioFile = self?.audioFile
            else { return }
            
            var delayInSeconds: Double = 0
            
            if let
                lastRenderTime = audioPlayerNode.lastRenderTime,
                let playerTime = audioPlayerNode.playerTime(forNodeTime: lastRenderTime) {
                
                if let rate = rate {
                    delayInSeconds = Double(audioFile.length - playerTime.sampleTime) /
                        Double(audioFile.processingFormat.sampleRate) / Double(rate)
                } else {
                    delayInSeconds = Double(audioFile.length - playerTime.sampleTime) /
                        Double(audioFile.processingFormat.sampleRate)
                }
            }
            
            // schedule a stop timer for when audio finishes playing
            strongSelf.stopTimer = Timer(
                timeInterval: delayInSeconds,
                target: strongSelf,
                selector: #selector(SoundPlayer.stopAudio),
                userInfo: nil,
                repeats: false
            )
            
            if let stopTimer = strongSelf.stopTimer {
                RunLoop.main.add(stopTimer, forMode: RunLoop.Mode.default)
            }
        }
        
        do {
            try audioEngine.start()
        } catch {
            display?.displayAlert(Alerts.AudioEngineError, message: String(describing: error))
            return
        }
        
        // play the recording!
        audioPlayerNode.play()
        display?.display(viewStateFactory.make(playingState: .playing))
    }
    
    @objc func stopAudio() {
        audioPlayerNode.stop()
        
        if let stopTimer = stopTimer {
            stopTimer.invalidate()
        }
        
        display?.display(viewStateFactory.make(playingState: .idle))
        
        audioEngine.stop()
        audioEngine.reset()
    }
    
    // MARK: Connect List of Audio Nodes
    
    private func connectAudioNodes(_ nodes: AVAudioNode...) {
        guard let audioFile = audioFile
        else { return }
        
        for x in 0..<nodes.count-1 {
            audioEngine.connect(nodes[x], to: nodes[x+1], format: audioFile.processingFormat)
        }
    }
}
