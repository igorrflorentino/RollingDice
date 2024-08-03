//
//  HistoryView.swift
//  RollingDice
//
//  Created by Igor Florentino on 03/08/24.
//

import SwiftUI

struct HistoryView: View {
	@ObservedObject var viewModel: DiceViewModel
	
	var body: some View {
		NavigationView {
			List {
				ForEach(viewModel.rollResults) { result in
					VStack(alignment: .leading) {
						LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 5)) {
							ForEach(result.diceResults) { diceResult in
								Text("\(diceResult.value)")
									.padding(5)
									.frame(width: 60, height: 60)
									.background(Color.gray.opacity(0.2))
									.cornerRadius(5)
							}
						}
						.padding(.bottom, 5)
						
						Text("Total: \(result.total)")
							.font(.headline)
						
						Text("Date: \(result.date, style: .date)")
							.font(.subheadline)
							.foregroundColor(.gray)
					}
					.padding(.vertical, 5)
				}
			}
			.navigationTitle("Roll History")
			.toolbar {
				ToolbarItem(placement: .navigationBarTrailing) {
					Button("Reset") {
						viewModel.showResetConfirmation = true
					}
				}
			}
			.alert(isPresented: $viewModel.showResetConfirmation) {
				Alert(
					title: Text("Reset History"),
					message: Text("Are you sure you want to reset the history? This action cannot be undone."),
					primaryButton: .destructive(Text("Reset")) {
						viewModel.resetResults()
					},
					secondaryButton: .cancel()
				)
			}
		}
	}
}

#Preview {
	HistoryView(viewModel: DiceViewModel())
}
