//
//  CardMatchingGame.swift
//  Matchismo1
//
//  Created by Brooke Frandsen on 9/17/14.
//  Copyright (c) 2014 IS 543. All rights reserved.
//

import Foundation

class CardMatchingGame {
    private var score = 0
    private var description = "Pick a card."
    private var type = 2
    private lazy var cards: [Card] = []
    private lazy var history: [String] = []
    
    let FLIP_COST = 1
    let MATCH_BONUS = 4
    let MISMATCH_PENALTY = 1
    
    init(cardCount: Int, deck: Deck) {
        for i in 0 ..< cardCount {
        if let card = deck.drawRandomCard() {
                cards.append(card)
            }
        }
    }
    
    func flipCardAtIndex(index: Int) {
        if let card = cardAtIndex(index) {
            if !card.unplayable { //If card clicked is playable
                if !card.faceUp { //If card clicked is face down
                    
                    description = "\(card.contents) flipped."
                    history.append(description)
                    
                    var matches: [Card] = []
                    var misMatches: [Card] = []
                    var matchScore = 0
                    var matchMade = false
                    
                    for otherCard in cards {
                        if otherCard.faceUp && !otherCard.unplayable { //If other card is face up, and not the card clicked on
                            
                            //Does it match the other card
                            if matches.count > 0 {
                                matchScore = card.match([otherCard, matches[0]])
                            } else {
                                matchScore = card.match([otherCard])
                            }
                            
                            // match tells how good a match it is, or 0 if mismatch
                            if matchScore > 0 {
                                
                                matches.append(otherCard)
                                
                            } else {
                                
                                misMatches.append(otherCard)
                                
                            }  
                            
                            // If there are as many cards matched (including current card) as the type of match
                            if matches.count == type-1 {
                                
                                score += matchScore * MATCH_BONUS
                                card.unplayable = true
                                
                                for card in matches {
                                    card.unplayable = true
                                }
                                
                                matches.append(card)
                                description = getMatchDescription(matches, matchType: type)
                                history.append(description)
                                matchMade = true
                                
                                // we've found the other face-up playable card, so stop looking
                                break
                            }
                        }
                    }// for otherCard in cards
                   
                    // If there was no match made, set mismatch description.
                    if matchMade == false {
                        if (misMatches + matches).count > 0 && (misMatches + matches).count >= type-1 {
                            description = getMismatchDescription([card] + matches + misMatches, matchType: type)
                            score += MISMATCH_PENALTY
                        }
                        history.append(description)
                    }
                    
                // always charge a cost to flip
                score -= FLIP_COST
                    
            }// if card is face down end
                card.faceUp = !card.faceUp
            }
        }
    }
    
    func cardAtIndex(index: Int) -> Card? {
        if index >= 0 && index < cards.count {
            return cards[index]
        }
        
        return nil
    }
    
    func currentScore() -> Int {
        return score
    }
    
    func currentDescription() -> String {
        return description
    }
    
    func getDescriptionAtIndex(index: Float) -> String{
        if(Int(index) <= getMaxHistory() && Int(index) >= getMinHistory()) {
            return history[Int(index)]
        } else {
            return ""
        }
    }
    
    func setMatchType(type: Int) {
        //Adding 2, for base starting at 2 instead of 0.
        self.type = type+2
    }
    
    private func getMatchDescription(cards: [Card], matchType: Int) -> String {
        var output = ""
        for (index, card) in enumerate(cards) {
            if index == cards.count-1 {
                output += " and \(card.contents)"
            } else {
                output += "\(card.contents)"
                if index != cards.count-2 {
                    output += ", "
                }
            }
        }
        output += " match!"
        return output
    }
    
    private func getMismatchDescription(cards: [Card], matchType: Int) -> String {
        var output = ""
        for (index, card) in enumerate(cards) {
            if index == cards.count-1 {
                output += " and \(card.contents)"
            } else {
                output += "\(card.contents)"
                if index != cards.count-2 {
                    output += ", "
                }
            }
        }
        output += " don't match. \(MISMATCH_PENALTY) point penalty"
        return output
    }
    
    func getMinHistory() -> Int {
        return 0
    }
    
    func getMaxHistory() -> Int {
        return history.count-1
    }

}
