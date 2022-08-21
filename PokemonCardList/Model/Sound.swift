//
//  Sound.swift
//  PokemonCardList
//
//  Created by Roberts Kursitis on 20/08/2022.
//

import Foundation
import AVFoundation

var player: AVPlayer!

func playSound() {
    let introSoundURL = Bundle.main.url(forResource: "intro", withExtension: "mp3")
    player = AVPlayer(url: introSoundURL!) 
    player.volume = 0.3
    player.play()
}
