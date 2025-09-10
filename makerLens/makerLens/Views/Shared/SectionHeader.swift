//
//  SectionHeader.swift
//  makerLens
//
//  Created by Priyanka Razdan on 9/1/25.
//


import SwiftUI

struct SectionHeader: View {
    let title: String
    let actionTitle: String?
    let onAction: (() -> Void)?
    
    init(title: String, actionTitle: String? = nil, onAction: (() -> Void)? = nil) {
        self.title = title
        self.actionTitle = actionTitle
        self.onAction = onAction
    }
    
    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .foregroundColor(.primary)
            
            Spacer()
            
            if let actionTitle = actionTitle, let onAction = onAction {
                Button(actionTitle) {
                    onAction()
                }
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(AppConstants.Colors.primaryPurple)
            }
        }
        .padding(.horizontal, AppConstants.Spacing.lg)
    }
}