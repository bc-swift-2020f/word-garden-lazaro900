//
//  ViewController.swift
//  WordGarden
//
//  Created by Lazaro Alvelaez on 9/12/20.
//  Copyright © 2020 Lazaro Alvelaez. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    func updateUIAfterGuess() {
        
        guessLetterButton.isEnabled = false
        
        guessedLetterTextField.resignFirstResponder()
        guessedLetterTextField.text = ""
    }
    
    func lastCharacter(text : String) -> String{
        guard let text1 = text.last else {
            return ""
        }
        return String(text1)
    }
    
    @IBOutlet weak var wordsGuessedLabel: UILabel!
    @IBOutlet weak var wordsRemainingLabel: UILabel!
    @IBOutlet weak var wordsMissedLabel: UILabel!
    @IBOutlet weak var wordsInGameLabel: UILabel!
    
    @IBOutlet weak var gameStatusLabel: UILabel!
    @IBOutlet weak var guessLetterButton: UIButton!
    
    @IBOutlet weak var guessedLetterTextField: UITextField!
    @IBOutlet weak var wordBeingRevealedLabel: UILabel!
    @IBOutlet weak var playAgainButton: UIButton!
    @IBOutlet weak var flowerImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        guessLetterButton.isEnabled = false
        
    }
    @IBAction func guessLetterButtonPressed(_ sender: Any) {
        updateUIAfterGuess()
    }
    @IBAction func playAgainButtonPressed(_ sender: Any) {
    }
    
    @IBAction func doneKeyPressed(_ sender: UITextField) {
        updateUIAfterGuess()
    }
    
    @IBAction func guessedLetterFieldChanged(_ sender: UITextField) {
        let text = guessedLetterTextField.text
        
        guessedLetterTextField.text = lastCharacter(text: text!)
       
        guessLetterButton.isEnabled = !text!.isEmpty
    }
}

