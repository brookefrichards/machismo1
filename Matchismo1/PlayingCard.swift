//
//  PlayingCard.swift
//  Matchismo1
//
//  Created by Brooke Frandsen on 9/13/14.
//  Copyright (c) 2014 IS 543. All rights reserved.
//

import Foundation

class playingCard: Card {
    var suit: String! {
        didSet {
            if !contains(playingCard.validSuits(), suit) {
                suit = "?"
            }
            contents = "\(playingCard.rankStrings()[rank])\(suit)"
        }
    }
    
    var rank: Int! {
        didSet {
            if rank < 0 || rank > playingCard.maxRank() {
                rank = 0
            }
            contents = "\(playingCard.rankStrings()[rank])\(suit)"
        }
    }
    
    class func validSuits() -> [String] {
        return ["♥︎", "♦︎", "♠︎", "♣︎"]
    }
    
    private class func rankStrings() -> [String] {
        return ["?", "A", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K"]
    }
    
    class func maxRank() -> Int {
        return rankStrings().count - 1
    }
    
    let RANK_MATCH_SCORE = 4
    let RANK_MATCH_SCORE_3 = 12
    let SUIT_MATCH_SCORE = 2
    let SUIT_MATCH_SCORE_3 = 6
    
    override func match(otherCards: [Card]!) -> Int {
        var score = 0
        if otherCards.count == 1 {
            if let otherCard = otherCards.last as? playingCard {
                if otherCard.suit == suit {

                    score = SUIT_MATCH_SCORE
                } else if otherCard.rank == rank {
                    score = RANK_MATCH_SCORE
                }
            }
        } else if otherCards.count == 2 {
            let otherCard1 = otherCards[0] as? playingCard
            let otherCard2 = otherCards[1] as? playingCard
            if otherCard1 != nil && otherCard2 != nil {
                if otherCard1?.suit == suit && otherCard2?.suit == suit {
                    score = SUIT_MATCH_SCORE
                } else if otherCard1?.rank == rank && otherCard2?.rank == rank {
                    score = RANK_MATCH_SCORE
                }
            }
            
        }
        return score
    }
    
}