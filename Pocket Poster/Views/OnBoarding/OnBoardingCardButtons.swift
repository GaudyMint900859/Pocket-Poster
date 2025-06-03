//
//  OnBoardingCardButtons.swift
//  Pocket Poster
//
//  Created by lemin on 5/31/25.
//

import SwiftUI

struct OnBoardingCardButtons: View {
    @Binding var isFinished: Bool
    
    @Binding var idx: Int
    @Binding var isAnimating: Bool
    
    var showDismiss: Bool
    var showFinish: Bool
    
    var body: some View {
        HStack {
            // MARK: Dismiss Button
            if showDismiss {
                Button(action: {
                    playFinishAnimation()
                }) {
                    HStack(spacing: 8) {
                        Image(systemName: "x.circle")
                            .imageScale(.large)
                        
                        Text("Skip")
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(
                        Capsule().strokeBorder(Color.white, lineWidth: 1.25)
                    )
                }
                .accentColor(Color.white)
                .accessibilityIdentifier("OnBoardingSkip")
            }
            
            // MARK: Next Button
            Button(action: {
                if showFinish {
                    playFinishAnimation()
                } else {
                    // move to next
                    isAnimating = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                        idx += 1
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                            isAnimating = true
                        })
                    })
                }
            }) {
                HStack(spacing: 8) {
                    Text(showFinish ? "Finish" : "Next")

                    Image(systemName: showFinish ? "checkmark.circle" : "arrow.right.circle")
                        .imageScale(.large)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(
                    Capsule().strokeBorder(Color.white, lineWidth: 1.25)
                )
            }
            .accentColor(Color.white)
            .accessibilityIdentifier("OnBoardingNext")
        }
    }
    
    func playFinishAnimation() {
        isAnimating = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            isFinished = true
        })
    }
}

struct OnBoardingCardView: View {
    var info: OnBoardingPage
    var pageCount: Int
    @Binding var idx: Int
    @Binding var isFinished: Bool
    
    @State private var isAnimating: Bool = false
    @State private var imgCornerRadius: CGFloat = 10.0
    
    var body: some View {
        VStack(spacing: 20) {
            // Image
            Image(info.image)
                .resizable()
                .scaledToFit()
                .clipShape(RoundedRectangle(cornerRadius: imgCornerRadius))
                .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.15), radius: 8, x: 6, y: 8)
                .scaleEffect(isAnimating ? 1.0 : 0.6)
            
            // Title
            Text(info.title)
                .foregroundColor(Color.white)
                .multilineTextAlignment(.center)
                .font(.largeTitle)
                .fontWeight(.heavy)
                .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.15), radius: 2, x: 2, y: 2)
            
            // Description
            Text(info.description)
                .foregroundColor(Color.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 16)
                .frame(maxWidth: 480)
            
            // Link Button
            if let url = info.link, let linkName = info.linkName {
                Link(destination: url) {
                    HStack(spacing: 8) {
                        Image(systemName: "link.circle")
                            .imageScale(.large)
                        
                        Text(linkName)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(
                        Capsule().strokeBorder(Color.white, lineWidth: 1.25)
                    )
                }
                .accentColor(Color.white)
            }
            
            OnBoardingCardButtons(isFinished: $isFinished, idx: $idx, isAnimating: $isAnimating, showDismiss: idx == 0, showFinish: idx == pageCount-1)
        }
        .opacity(isAnimating ? 1.0 : 0.0)
        .animation(.easeOut(duration: 0.5), value: isAnimating)
        .onAppear {
            isAnimating = true
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 25)
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
        .background(LinearGradient(gradient: Gradient(colors: info.gradientColors), startPoint: .top, endPoint: .bottom).ignoresSafeArea())
    }
}
