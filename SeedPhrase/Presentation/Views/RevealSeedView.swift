//
//  RevealSeedView.swift
//  SeedPhrase
//
//  Created by Muhammad Naeem Akram on 28/08/2025.
//

import SwiftUI

struct RevealSeedView: View {
    @ObservedObject var vm: SeedOnboardingViewModel
    var onContinue: () -> Void
    
    @State private var revealed = false
    @State private var animateWords = false
    
    private let columns = [GridItem(.adaptive(minimum: 110), spacing: 10)]
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [.purple.opacity(0.8), .black], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("📝 Write down your phrase")
                    .font(.title3.bold())
                    .foregroundColor(.white)
                
                if revealed, let words = vm.seedPhrase?.words {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 10) {
                            ForEach(Array(words.enumerated()), id: \.offset) { idx, word in
                                WordBox(number: idx + 1, word: word)
                                    .opacity(animateWords ? 1 : 0)
                                    .offset(y: animateWords ? 0 : 20)
                                    .animation(
                                        .spring(response: 0.5, dampingFraction: 0.7)
                                        .delay(Double(idx) * 0.05), // staggered effect
                                        value: animateWords
                                    )
                            }
                        }
                        .padding()
                    }
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20))
                    .shadow(radius: 6)
                } else {
                    Text("Tap **Reveal** to see your phrase")
                        .foregroundColor(.white.opacity(0.7))
                        .padding()
                }
                
                Spacer()
                
                Button {
                    if revealed {
                        onContinue()
                    } else {
                        revealed = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            animateWords = true
                        }
                    }
                } label: {
                    Text(revealed ? "Continue ➡️" : "👀 Reveal")
                        .font(.headline)
                        .padding(.horizontal, 40)
                        .padding(.vertical, 16)
                        .background(
                            LinearGradient(colors: [.blue, .purple], startPoint: .leading, endPoint: .trailing)
                                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        )
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)
                }
                .buttonStyle(ScaleButtonStyle())
            }
            .padding()
        }
    }
}
