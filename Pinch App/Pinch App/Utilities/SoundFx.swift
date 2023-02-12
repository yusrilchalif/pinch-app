//
//  SoundFx.swift
//  Pinch App
//
//  Created by Yusril on 12/02/23.
//

import Foundation
import AVKit

var audioPlayer: AVAudioPlayer?

func PlayAudio(sound: String, type: String) {
    if let path: String = Bundle.main.path(forResource: sound, ofType: type) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
            audioPlayer?.play()
        } catch {
            print("Audio Cant play")
        }
    }
}
