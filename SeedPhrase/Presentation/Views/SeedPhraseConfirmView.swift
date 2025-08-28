//
//  SeedPhraseConfirmView.swift
//  SeedPhrase
//
//  Created by Muhammad Naeem Akram on 28/08/2025.
//

import SwiftUI

struct SeedPhraseConfirmView: View {
    @ObservedObject var vm: SeedOnboardingViewModel
    
    @Namespace private var wordAnimation
    @State private var shuffled: [String] = []
    
    // Adaptive columns for flexible layout
    private let columns = [GridItem(.adaptive(minimum: 120), spacing: 10)]
    
    var body: some View {
        ZStack {
            // Gradient background
            LinearGradient(colors: [.blue.opacity(0.7), .purple.opacity(0.8), .black],
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 20) {
                    Text("🔎 Confirm your seed phrase")
                        .font(.title2.bold())
                        .foregroundColor(.white)
                        .padding(.top, 10)
                    
                    // Selected slots (clickable to move back)
                    VStack {
                        LazyVGrid(columns: columns, spacing: 10) {
                            ForEach(0..<(vm.seedPhrase?.words.count ?? 0), id: \.self) { idx in
                                if idx < vm.userSelectedWords.count {
                                    let word = vm.userSelectedWords[idx]
                                    Button {
                                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                            vm.userSelectedWords.remove(at: idx)
                                            shuffled.append(word)
                                        }
                                    } label: {
                                        WordBox(number: idx + 1, word: word)
                                            .matchedGeometryEffect(id: word, in: wordAnimation)
                                    }
                                } else {
                                    WordBox(number: idx + 1, word: "_____", isPlaceholder: true)
                                }
                            }
                        }
                        .padding()
                    }
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20))
                    .shadow(radius: 8)
                    .padding(.horizontal)
                    
                    // Available Words Section
                    if !shuffled.isEmpty {
                        Text("Available Words")
                            .font(.headline)
                            .foregroundColor(.white.opacity(0.8))
                            .padding(.top, 4)
                        
                        LazyVGrid(columns: columns, spacing: 12) {
                            ForEach(shuffled, id: \.self) { word in
                                Button {
                                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                        vm.userSelectedWords.append(word)
                                        shuffled.removeAll { $0 == word }
                                    }
                                } label: {
                                    WordBox(number: 0, word: word)
                                        .matchedGeometryEffect(id: word, in: wordAnimation)
                                }
                            }
                        }
                        .padding()
                        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20))
                        .shadow(radius: 6)
                        .padding(.horizontal)
                    }
                    
                    // Verification result
                    if let result = vm.verificationResult {
                        Text(result ? "✅ Correct" : "❌ Incorrect")
                            .font(.headline)
                            .foregroundColor(result ? .green : .red)
                            .padding(.top, 6)
                            .transition(.opacity.combined(with: .scale))
                    }
                    
                    // Check button
                    Button {
                        vm.verify()
                    } label: {
                        Text("Check")
                            .font(.headline)
                            .padding(.horizontal, 40)
                            .padding(.vertical, 16)
                            .background(
                                LinearGradient(colors: [.purple, .blue],
                                               startPoint: .leading,
                                               endPoint: .trailing)
                                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                            )
                            .foregroundColor(.white)
                            .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)
                    }
                    .buttonStyle(ScaleButtonStyle())
                    .padding(.top, 8)
                    
                    Spacer(minLength: 20)
                }
                .padding()
            }
        }
        .onAppear {
            shuffled = vm.seedPhrase?.words.shuffled() ?? []
            vm.resetVerification()
        }
    }
}
