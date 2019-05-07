//
//  ViewController.swift
//  Quizzler
//
//  Created by Angela Yu on 25/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let questionsBank = QuestionsBank()
    var currentQuestion = 0
    var currentScore = 0
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet var progressBar: UIView!
    @IBOutlet weak var progressLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }


    @IBAction func answerPressed(_ sender: AnyObject) {
        ProgressHUD.dismiss()
        checkAnswer(answer: sender.tag == 1)
    }
    
    
    func updateUI() {
        questionLabel.text = questionsBank.list[currentQuestion].text
        scoreLabel.text = "Score \(currentScore)"
        progressLabel.text = "\(currentQuestion + 1) / \(questionsBank.list.count)"
        progressBar.frame.size.width = (view.frame.size.width / CGFloat(questionsBank.list.count)) * CGFloat(currentQuestion + 1)
    }
    

    func nextQuestion() {
        if(currentQuestion < questionsBank.list.count - 1) {
            currentQuestion += 1
            updateUI()
        } else {
            let alert = UIAlertController(title: "Done!", message: "Do you want to do it again>", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Restart", style: UIAlertActionStyle.default, handler: { (UIAlertAction) in
                self.startOver()
            }))
            present(alert, animated: true, completion: nil)
        }
    }
    
    
    func checkAnswer(answer: Bool) {
        if(questionsBank.list[currentQuestion].answer == answer) {
            ProgressHUD.showSuccess("Correct!")
            currentScore += 1
        } else {
            ProgressHUD.showError("Wrong!")
        }
        nextQuestion()
    }
    
    
    func startOver() {
       currentQuestion = 0
        currentScore = 0
        updateUI()
    }
}
