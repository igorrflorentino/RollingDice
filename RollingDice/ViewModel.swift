//
//  ViewModel.swift
//  RollingDice
//
//  Created by Igor Florentino on 03/08/24.
//

import SwiftUI
import Combine

class DiceViewModel: ObservableObject {
	@Published var numberOfDice: Int = 1
	@Published var diceType: Dice = Dice(sides: 6)
	@Published var rollResults: [RollResult] = []
	@Published var currentRolls: [DiceResult] = []
	@Published var rolling = false
	@Published var showHistory = false
	@Published var showResetConfirmation = false
	
	var timer: Timer?
	
	let diceOptions: [Dice] = [4, 6, 8, 10, 12, 20, 100].map { Dice(sides: $0) }
	
	var selectedNumberOfDice: Int {
		get { numberOfDice - 1 }
		set { numberOfDice = newValue + 1 }
	}
	
	func rollDice() {
		rolling = true
		var counter = 0
		currentRolls = Array(repeating: DiceResult(value: 0), count: numberOfDice)
		timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
			for i in 0..<self.numberOfDice {
				self.currentRolls[i] = DiceResult(value: Int.random(in: 1...self.diceType.sides))
			}
			counter += 1
			if counter >= 20 {
				timer.invalidate()
				self.finalizeRoll()
				self.rolling = false
			}
		}
		triggerHapticFeedback()
	}
	
	private func finalizeRoll() {
		for i in 0..<numberOfDice {
			currentRolls[i] = DiceResult(value: Int.random(in: 1...diceType.sides))
		}
		let total = currentRolls.reduce(0) { $0 + $1.value }
		let result = RollResult(total: total, diceResults: currentRolls, date: Date())
		rollResults.append(result)
		saveResults()
	}
	
	private func triggerHapticFeedback() {
		let generator = UIImpactFeedbackGenerator(style: .medium)
		generator.impactOccurred()
	}
	
	private func saveResults() {
		guard let data = try? JSONEncoder().encode(rollResults) else { return }
		UserDefaults.standard.set(data, forKey: "rollResults")
	}
	
	func loadResults() {
		guard let data = UserDefaults.standard.data(forKey: "rollResults"),
			  let results = try? JSONDecoder().decode([RollResult].self, from: data) else { return }
		rollResults = results
	}
	
	func resetResults() {
		rollResults.removeAll()
		saveResults()
	}
}
