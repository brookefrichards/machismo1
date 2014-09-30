//
//  PlayingCardDeck.swift
//  Matchismo1
//
//  Created by Brooke Frandsen on 9/13/14.
//  Copyright (c) 2014 IS 543. All rights reserved.
//

import Foundation

class playingCardDeck: Deck {
    override init() {
        super.init()
        for suit in playingCard.validSuits() {
            for rank in 1...playingCard.maxRank() {
                var card = playingCard()
                
                card.rank = rank
                card.suit = suit
                
                addCard(card, atTop: true)
            }
        }
    }
    

}
