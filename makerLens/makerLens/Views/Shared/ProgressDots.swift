//
//  ProgressDots.swift
//  makerLens
//
//  Created by Priyanka Razdan on 8/30/25.
//


import SwiftUI

struct ProgressDots: View {
    let currentStep: Int
    let totalSteps: Int
    
    var body: some View {
        HStack(spacing: AppConstants.Spacing.xs) {
            ForEach(1...totalSteps, id: \.self) { step in
                Circle()
                    .fill(step <= currentStep ? AppConstants.Colors.primaryPurple : AppConstants.Colors.lightTeal.opacity(0.3))
                    .frame(width: 8, height: 8)
                    .scaleEffect(step == currentStep ? 1.2 : 1.0)
                    .animation(AppConstants.Animation.quick, value: currentStep)
            }
        }
    }
}