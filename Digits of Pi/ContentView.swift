//
//  ContentView.swift
//  Digits of Pi
//
//  Created by Mike Griebling on 19.08.2024.
//  Enhanced by Mike Griebling on 1 Nov 2026
//

import SwiftUI

struct ContentView: View {
    @State private var digits: Double = 100
	@State private var finalDigits: Double = 100
    @State private var pi = ""
    @State private var change = false
    @State private var isCopied = false
	@State private var isCalculating = false
    
    var body: some View {
        VStack {
			HStack {
				Slider(value: $digits, in: 100...1_000_000, step: 100,
					   onEditingChanged: { editing in
					if !editing {
						finalDigits = digits
						print("Released with value: \(finalDigits)")
					}
				})
				.task(id: finalDigits) {
					do {
						try Task.checkCancellation()
						print("Calculating pi for \(finalDigits) digits...")
						pi = ""
						isCalculating = true
						pi = await computePi(digits)
						isCalculating = false
					} catch {
						// task cancelled - do nothing
					}
				}
				Text("\(Int(digits)) digits")
			}
			.padding()
            ZStack {
                if isCopied {
                    // Shows up only when copy is done
                    Text("Copied successfully!")
                        .foregroundColor(.white)
                        .bold()
                        .font(.largeTitle)
                        .background(Color.black.cornerRadius(7))
                        .opacity(1)
                }
				
				if isCalculating {
					Color(.textColor).opacity(0.15)
						.ignoresSafeArea()
					ProgressView("Calculating pi...")
						.progressViewStyle(.circular)
						.padding(20)
						.background(.ultraThinMaterial)
						.cornerRadius(10)
						.shadow(radius: 10)
				}
                
				ScrollView {
					TextEditor(text: .constant(pi))
						.lineLimit(nil)
						.fixedSize(horizontal: false, vertical: true)
						.multilineTextAlignment(.leading)
						.onTapGesture(count: 2) {
#if os(macOS)
							let pastboard = NSPasteboard.general
							pastboard.clearContents()
							pastboard.setString(pi, forType: .string)
#else
							UIPasteboard.general.string = pi
#endif
							isCopied = true
							DispatchQueue.main.asyncAfter(wallDeadline: .now()+3) {
								isCopied = false
							}
						}
						.font(.system(size: 15, design: .monospaced))
				}
			}
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
