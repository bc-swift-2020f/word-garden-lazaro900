//
//  ViewController.swift
//  WordGarden
//
//  Created by Lazaro Alvelaez on 9/12/20.
//  Copyright © 2020 Lazaro Alvelaez. All rights reserved.
//

import AVFoundation
import UIKit

class ViewController: UIViewController {
    // this function will be used to update the UI after a guess is made. fix the button, textfield
    func updateUIAfterGuess() {
        guessLetterButton.isEnabled = false
        
        guessedLetterTextField.resignFirstResponder()
        guessedLetterTextField.text = ""
    }
    
    // this function takes the last character of what is typed
    func lastCharacter(text : String) -> String{
        
        guard let text1 = text.last else {
            return ""
        }
        return String(text1)
    }
    
    
    
    // this function changes the displayed word as the user guesses.
    func guessALetter(char : Character) {
        //update gamestatuslabel
        guessCount += 1
        
        gameStatusLabel.text = (guessCount == 1 ? "You Have Made 1 Guess" : "You Have Made \(guessCount) Guesses")
        
        
        lettersGuessed = lettersGuessed + String(char)
        
        //check if the letter is corretct
        if wordToGuess.contains(char) {
            var newDisplay = ""
            for element in wordToGuess {
                if lettersGuessed.contains(element) {
                    newDisplay += String(element)
                } else {
                    newDisplay += "_ "
                }
            }
            
            display = newDisplay.trimmingCharacters(in: .whitespaces)
            
            revealedWord = display
            wordBeingRevealedLabel.text = revealedWord
            playSound(new: "correct")

        
        } else {
            drawFlowerAndPlaySound()
            revealedWord = display
            wordBeingRevealedLabel.text = revealedWord
            
        }
        
        //check to see if the game is over
        if flowerImageView.image == UIImage.init(named: "flower0") {
            wordsMissed += 1

            
            if wordsRemaining == 1 {
                wordsRemaining -= 1
                wordsRemainingLabel.text = "Words Remaining: \(wordsRemaining)"
                playAgainButton.isHidden = false
                wordsRemainingLabel.text = "Words Remaining: 0"
                gameStatusLabel.text = "You Have Gone Through All The Words, Play Again?!"

                
            } else {
                gameStatusLabel.text = "Sorry! You are out of guesses"
                wordsRemaining -= 1
                wordsRemainingLabel.text = "Words Remaining: \(wordsRemaining)"
                playAgainButton.isHidden = false

            }
            
            wordsMissedLabel.text = "Words Missed: \(wordsMissed)"
        
            
        } else if revealedWord == wordToGuess {
            wordsGuessedCount += 1
            playSound(new: "word-guessed")

            if wordsRemaining == 1 {
                gameStatusLabel.text = "Great Job! It took You \(guessCount) Guesses to Get The Word! \nYou Have Gone Through All The Words, Play Again?!"
                wordsRemaining -= 1
                wordsRemainingLabel.text = "Words Remaining: \(wordsRemaining)"
                playAgainButton.isHidden = false
        

            } else {
                gameStatusLabel.text = (guessCount == 1 ? "You Guessed The Word! \n It Took You \(guessCount) Guess" : "You Guessed The Word! \n It Took You \(guessCount) Guesses")
                
                wordsRemaining -= 1
                wordsRemainingLabel.text = "Words Remaining: \(wordsRemaining)"
                playAgainButton.isHidden = false

            }
            wordsGuessedLabel.text = "Words Guessed: \(wordsGuessedCount)"

        }
    }
    
    
    func updateAfterWinOrLose() {
        lettersGuessed = ""
        let index = wordsToGuess.firstIndex(of: wordToGuess)
        wordsToGuess.remove(at: index!)
        

        
        flower = 8
        drawFlowerAndPlaySound()
        
        guessCount = 0
        gameStatusLabel.text = (guessCount == 1 ? "You Have Made 1 Guess" : "You Have Made \(guessCount) Guesses")
        
        if wordsToGuess.count-1 < 0 {
            currentWordIndex = 0
        } else {
            currentWordIndex = Int.random(in: 0...wordsToGuess.count-1)
            wordToGuess = wordsToGuess[currentWordIndex]
        }
        createDashes()
        
    }
    
    
    func drawFlowerAndPlaySound() {
        
        flower -= 1
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            self.playSound(new: "incorrect")
            UIView.transition(with: self.flowerImageView, duration: 0.5, options: .transitionCrossDissolve, animations: {self.flowerImageView.image = UIImage(named: "wilt\(self.flower)")}) { (_) in
                
                if self.flower != 0 {
                        self.flowerImageView.image = UIImage.init(named: "flower\(self.flower)")

                } else {
                    self.playSound(new: "word-not-guessed")
                    UIView.transition(with: self.flowerImageView, duration: 0.5, options: .transitionCrossDissolve, animations: {
                        self.flowerImageView.image = UIImage.init(named: "flower\(self.flower)")
                    }, completion: nil)
                }
        }
        
        }
    }
    
    func createDashes() {
        display = ""
        for letter in wordToGuess {
            display = display + "_ "
        }
        display.removeLast()
        revealedWord = display
        wordBeingRevealedLabel.text = revealedWord
        
    }
    
    var wordsMissed = 0
    var wordsRemaining = 0
    var wordsGuessedCount = 0
    var lettersGuessed = ""
    var revealedWord = ""
    var wordsToGuess = ["SWIFT", "DOG", "CAT"]
    var currentWordIndex = 0
    var wordToGuess = ""
    var display = ""
    var guessCount = 0
    var flower = 8
    var audioPlayer: AVAudioPlayer!


    
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
        
        wordsRemaining = wordsToGuess.count
        wordsInGameLabel.text = "Words in Game: \(wordsRemaining)"
        wordsRemainingLabel.text = "Words Remaining: \(wordsRemaining)"
        guessLetterButton.isEnabled = false
        currentWordIndex = Int.random(in: 0...wordsToGuess.count-1)
        wordToGuess = wordsToGuess[currentWordIndex]
        
        
        
        //this will create the dashes display for the word chosen
        createDashes()
      
    }
    
    func playSound(new : String) {
        if let sound = NSDataAsset(name: new) {
            do {
                try audioPlayer = AVAudioPlayer(data: sound.data)
                audioPlayer.play()
            } catch {
                print("ERROR: \(error.localizedDescription) Could not read data file sound0")
            }
            
        } else {
            print("Could not read data file sound0")
        }
    }
    
    @IBAction func guessLetterButtonPressed(_ sender: Any) {
        guessALetter(char: Character(guessedLetterTextField.text!))
        updateUIAfterGuess()

        
        
    }
    @IBAction func playAgainButtonPressed(_ sender: Any) {
        if wordsRemaining == 0 {
            wordsToGuess = ["SWIFT", "DOG", "CAT"]
            wordsRemaining = wordsToGuess.count
            wordsGuessedCount = 0
            wordsGuessedLabel.text = "Words Guessed: \(wordsGuessedCount)"
            wordsMissed = 0
            wordsMissedLabel.text = "Words Missed: \(wordsMissed)"
            wordsInGameLabel.text = "Words in Game: \(wordsRemaining)"
            wordsRemainingLabel.text = "Words Remaining: \(wordsRemaining)"
            
            
        }

        
        updateAfterWinOrLose()
    }
    
    @IBAction func doneKeyPressed(_ sender: UITextField) {
        guessALetter(char: Character(guessedLetterTextField.text!))
        updateUIAfterGuess()
        
    }
    
    @IBAction func guessedLetterFieldChanged(_ sender: UITextField) {
        let text = guessedLetterTextField.text
        
        guessedLetterTextField.text = lastCharacter(text: text!).uppercased()
       
        guessLetterButton.isEnabled = !text!.isEmpty
    }
}

