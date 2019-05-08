//
//  Story.swift
//  Destini
//
//  Created by David Miguel on 08/05/2019.
//  Copyright © 2019 London App Brewery. All rights reserved.
//

import Foundation

class Story {
    
    let story: String
    let answerA: String?
    let answerB: String?
    
    init(story: String, answerA: String?, answerB: String?) {
        self.story = story
        self.answerA = answerA
        self.answerB = answerB
    }
}
