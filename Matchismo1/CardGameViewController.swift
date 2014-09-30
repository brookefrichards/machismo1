//
//  CardGameViewController.swift
//  Matchismo1
//
//  Created by Steve Liddle on 9/10/14.
//  Copyright (c) 2014 IS 543. All rights reserved.
//

import UIKit

class CardGameViewController : UIViewController {

    lazy var cards: [UIButton: Card]! = [UIButton: Card]()
    var game: CardMatchingGame!
    
    @IBOutlet weak var flipLabel: UILabel!
    @IBOutlet var cardButtons: [UIButton]! {
        didSet {
            game = CardMatchingGame(cardCount: cardButtons.count, deck: playingCardDeck())
        }
    }
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var matchResultLabel: UILabel!
    @IBOutlet weak var redeal: UIButton!
    @IBOutlet weak var typeSwitch: UISegmentedControl!
    @IBOutlet weak var historySliderUI: UISlider!

    var flipCount: Int = 0 {
        didSet {
            flipLabel.text = "Flips: \(flipCount)"
        }
    }

    @IBAction func deal(sender: UIButton) {
        game = CardMatchingGame(cardCount: cardButtons.count, deck: playingCardDeck())
        flipCount = 0
        game.setMatchType(typeSwitch.selectedSegmentIndex)
        typeSwitch.enabled = true
        for button in cardButtons {
            button.enabled = true
        }
        updateUI()
    }
    
    @IBAction func flipCard(sender: UIButton) {
        game.flipCardAtIndex(indexOfButton(sender))
        matchResultLabel.numberOfLines = 0
        typeSwitch.enabled = false
        ++flipCount
        updateUI()
    }
    
    @IBAction func sliderHistory(sender: UISlider) {
        matchResultLabel.text = game.getDescriptionAtIndex(sender.value)
        if Int(sender.value) != game.getMaxHistory() {
            matchResultLabel.alpha = 0.7
        } else {
            matchResultLabel.alpha = 1.0
        }
    }
    
    @IBAction func matchType(sender: UISegmentedControl) {
        game.setMatchType(sender.selectedSegmentIndex)
    }
    
    func updateUI() {
        let cardBack = UIImage(named: "CardBack")
        let cardFront = UIImage(named: "CardFront")
        for button in cardButtons {
            let card = game.cardAtIndex(indexOfButton(button))!
            if card.faceUp {
                button.setTitle(card.contents, forState: .Normal)
                button.setBackgroundImage(cardFront, forState: .Normal)
                button.enabled = !card.unplayable
                matchResultLabel.text = "match"
            } else {
                button.setTitle("", forState: .Normal)
                button.setBackgroundImage(cardBack, forState: .Normal)
                matchResultLabel.text = "Card"
            }
        }
        
        scoreLabel.text = "Score: \(game.currentScore())"
        matchResultLabel.text = "\(game.currentDescription())"
        
        //Reset History Slider Information
        historySliderUI.minimumValue = Float(game.getMinHistory())
        historySliderUI.maximumValue = Float(game.getMaxHistory())
        historySliderUI.value = Float(game.getMaxHistory())
        matchResultLabel.alpha = 1.0
    }
    
    func indexOfButton(button: UIButton) -> Int {
        for i in 0..<cardButtons.count {
            if button == cardButtons[i] {
                return i
            }
        }
        return -1
    }
}