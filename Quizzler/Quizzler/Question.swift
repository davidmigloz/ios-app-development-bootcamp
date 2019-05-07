//
//  Question.swift
//  Quizzler
//
//  Created by David Miguel on 05/05/2019.
//  Copyright © 2019 London App Brewery. All rights reserved.
//

import Foundation

class Question {
    
    let text: String
    let answer: Bool
    
    init(text: String, answer: Bool) {
        self.text = text
        self.answer = answer
    }
}
