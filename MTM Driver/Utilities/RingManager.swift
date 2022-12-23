//
//  RingManager.swift
//  MTM Driver
//
//  Created by Gaurang on 23/09/22.
//  Copyright © 2022 baps. All rights reserved.
//

import AVFoundation
import UIKit


class RingManager {
    
    static let shared = RingManager()
    
    //MARK:- Play Audio
    var audioPlayer: AVAudioPlayer?
    
    func playSound() {
        
        guard let url = Bundle.main.url(forResource: "PickNGo", withExtension: "mp3") else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.mixWithOthers])
            try AVAudioSession.sharedInstance().setActive(true)
            
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.numberOfLoops = 3
            audioPlayer?.play()
            startVibration()
        }
        catch let error {
            print(error.localizedDescription)
        }
    }
    
    func stopSound() {
        audioPlayer?.stop()
    }
    
    func startVibration() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            if self.audioPlayer?.isPlaying == true {
                self.startVibration()
            }
        }
    }
}
