//
//  AudioPlayer.swift
//  FollowTheOrder
//
//  Created by Oleh Study on 23.01.2022.
//

import UIKit
import AVFoundation

enum SoundList: String {
    case click, lose, win, anthemUSA
}

class AudioPlayer {
    var audioPlayer: AVAudioPlayer!
    
    static var shared: AudioPlayer = {
        let instance = AudioPlayer()
        return instance
    }()
       
    
    func play(_ name: SoundList ) {
        let pathToSound = Bundle.main.path(forResource: name.rawValue, ofType: "mp3")!
        let url = URL(fileURLWithPath: pathToSound)
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } catch {
            //error handling
        }
    }
    
    private init() {}
}


extension AudioPlayer: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
}
