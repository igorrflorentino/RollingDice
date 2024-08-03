//
//  ContentView.swift
//  RollingDice
//
//  Created by Igor Florentino on 03/08/24.
//
import SwiftUI

struct ContentView: View {
	@StateObject private var viewModel = DiceViewModel()
	
	var body: some View {
		NavigationView {
			VStack {
				ScrollView {
					LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 5)) {
						ForEach(viewModel.currentRolls) { diceResult in
							Text("\(diceResult.value)")
								.font(.largeTitle)
								.frame(width: 60, height: 60)
								.background(Color.gray.opacity(0.2))
								.cornerRadius(8)
						}
					}
					.padding()
				}
				.frame(maxHeight: 300)  // Adjust height as needed
				
				Text("Total: \(viewModel.currentRolls.reduce(0) { $0 + $1.value })")
					.font(.title)
					.padding()
				
				Button(action: viewModel.rollDice) {
					Text("Roll Dice")
						.padding()
						.background(Color.blue)
						.foregroundColor(.white)
						.cornerRadius(10)
				}
				.disabled(viewModel.rolling)
				.padding()
				
				Stepper(value: $viewModel.numberOfDice, in: 1...25) {
					Text("Number of Dice: \(viewModel.numberOfDice)")
				}
				.padding()
				.disabled(viewModel.rolling)
				
				Picker("Type of Dice", selection: $viewModel.diceType) {
					ForEach(viewModel.diceOptions, id: \.self) { dice in
						Text("D\(dice.sides)").tag(dice)
					}
				}
				.pickerStyle(SegmentedPickerStyle())
				.padding()
				.disabled(viewModel.rolling)
				
				Button(action: { viewModel.showHistory.toggle() }) {
					Text("Show History")
				}
				.padding()
				.disabled(viewModel.rolling)
				
				Spacer()
			}
			.navigationTitle("Dice Roller")
			.sheet(isPresented: $viewModel.showHistory) {
				HistoryView(viewModel: viewModel)
			}
		}
		.onAppear {
			viewModel.loadResults()
		}
	}
}

#Preview {
    ContentView()
}
