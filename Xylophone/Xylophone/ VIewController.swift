//
//  ViewController.swift
//  Xylophone
//
//  Created by Angela Yu on 27/01/2016.
//  Copyright © 2016 London App Brewery. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioPlayerDelegate {
    
    var player: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func notePressed(_ sender: UIButton) {
        let key = sender.tag
        if(key > 0 && key < 8) {
           playSound(soundRes: "note\(key)")
        }
    }
    
    func playSound(soundRes: String) {
        guard let url = Bundle.main.url(forResource: soundRes, withExtension: "wav") else { return }
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player.play()
        } catch let error {
            print(error)
        }
    }
}

