//
//  SeedOnboardingFlow.swift
//  SeedPhrase
//
//  Created by Muhammad Naeem Akram on 28/08/2025.
//

import SwiftUI

struct SeedOnboardingFlow: View {
    @StateObject private var vm = SeedOnboardingViewModel(
        generateSeedUseCase: GenerateSeedPhraseUseCase(
            repo: LocalWordlistRepository(),
            service: MnemonicService()
        ),
        verifySeedUseCase: VerifySeedPhraseUseCase()
    )
    @State private var showReveal = false
    @State private var showConfirm = false

    var body: some View {
        NavigationStack {
            ZStack {
                // Background gradient
                LinearGradient(
                    colors: [.blue.opacity(0.6), .purple.opacity(0.7), .black],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 24) {
                    VStack(spacing: 12) {
                        Text("🔐 Secret Recovery Phrase")
                            .font(.title.bold())
                            .foregroundColor(.white)
                        
                        Text("Generate and back up your seed phrase. It is the **only** way to recover your wallet.")
                            .font(.body)
                            .foregroundColor(.white.opacity(0.8))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    .padding()
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20))
                    .shadow(radius: 10)
                    
                    Spacer()
                    
                    Button {
                        vm.generateSeed()
                        showReveal = true
                    } label: {
                        Text("✨ Generate Seed Phrase")
                            .font(.headline)
                            .padding(.horizontal, 40)
                            .padding(.vertical, 16)
                            .background(
                                LinearGradient(
                                    colors: [.purple, .blue],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                            )
                            .foregroundColor(.white)
                            .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
                    }
                    .buttonStyle(ScaleButtonStyle()) // custom effect
                    
                    Spacer()
                }
                .padding()
            }
            .navigationDestination(isPresented: $showReveal) {
                RevealSeedView(vm: vm, onContinue: { showConfirm = true })
            }
            .navigationDestination(isPresented: $showConfirm) {
                SeedPhraseConfirmView(vm: vm)
            }
        }
    }
}


struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
    }
}
