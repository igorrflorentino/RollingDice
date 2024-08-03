//
//  Models.swift
//  RollingDice
//
//  Created by Igor Florentino on 03/08/24.
//

import Foundation

struct Dice: Identifiable, Codable, Hashable {
	var id = UUID()
	var sides: Int
	
	func hash(into hasher: inout Hasher) {
		hasher.combine(id)
		hasher.combine(sides)
	}
	
	static func ==(lhs: Dice, rhs: Dice) -> Bool {
		lhs.id == rhs.id && lhs.sides == rhs.sides
	}
}

struct DiceResult: Identifiable, Codable {
	var id = UUID()
	var value: Int
}

struct RollResult: Identifiable, Codable {
	var id = UUID()
	var total: Int
	var diceResults: [DiceResult]
	var date: Date
}
