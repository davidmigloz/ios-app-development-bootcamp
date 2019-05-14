    //
    //  ViewController.swift
    //  Destini
    //
    //  Created by Philipp Muellauer on 01/09/2015.
    //  Copyright (c) 2015 London App Brewery. All rights reserved.
    //

    import UIKit

    class ViewController: UIViewController {
    
    // UI Elements linked to the storyboard
    @IBOutlet weak var topButton: UIButton!         // Has TAG = 1
    @IBOutlet weak var bottomButton: UIButton!      // Has TAG = 2
    @IBOutlet weak var storyTextView: UILabel!
    @IBOutlet weak var restartButton: UIButton!
    
    let storyBank = StoryBank()
    var currentStoryIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }

    // User presses one of the buttons
    @IBAction func buttonPressed(_ sender: UIButton) {
        if(sender.tag == 1) {
            nextStory(btn: AnswerButton.top)
        } else if (sender.tag == 2) {
            nextStory(btn: AnswerButton.bottom)
        }
    }
    
    @IBAction func restart(_ sender: Any) {
        currentStoryIndex = 0
        updateUI()
    }
    
    func updateUI() {
        let story = storyBank.list[currentStoryIndex].story
        let answerA = storyBank.list[currentStoryIndex].answerA
        let answerB = storyBank.list[currentStoryIndex].answerB
        storyTextView.text = story
        if(answerA != nil && answerB != nil) {
            topButton.setTitle(answerA, for: UIControl.State.normal)
            bottomButton.setTitle(answerB, for: UIControl.State.normal)
            topButton.isHidden = false
            bottomButton.isHidden = false
            restartButton.isHidden = true
        } else {
            topButton.isHidden = true
            bottomButton.isHidden = true
            restartButton.isHidden = false
        }
    }
    
    func nextStory(btn: AnswerButton) {
        if(currentStoryIndex == 0 && btn == AnswerButton.top) {
            currentStoryIndex = 2
        } else if(currentStoryIndex == 0 && btn == AnswerButton.bottom) {
            currentStoryIndex = 1
        } else if(currentStoryIndex == 1 && btn == AnswerButton.top) {
            currentStoryIndex = 2
        } else if(currentStoryIndex == 1 && btn == AnswerButton.bottom) {
            currentStoryIndex = 3
        } else if(currentStoryIndex == 2 && btn == AnswerButton.top) {
            currentStoryIndex = 4
        } else if(currentStoryIndex == 2 && btn == AnswerButton.bottom) {
            currentStoryIndex = 5
        } else {
            currentStoryIndex = 0
        }
        updateUI()
    }
    
    enum AnswerButton : String {
        case top
        case bottom
    }
}
