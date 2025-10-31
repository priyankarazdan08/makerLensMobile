//
//  UserAvatar.swift
//  makerLens
//
//  Created by Priyanka Razdan on 8/30/25.
//


import SwiftUI

struct UserAvatar: View {
    let user: User?
    let size: CGFloat
    var onTap: (() -> Void)? = nil
    
    init(user: User?, size: CGFloat = 32, onTap: (() -> Void)? = nil) {
        self.user = user
        self.size = size
        self.onTap = onTap
    }
    
    var body: some View {
        Button(action: {
            onTap?()
        }) {
            Circle()
                .fill(AppConstants.Colors.lightTeal)
                .frame(width: size, height: size)
                .overlay(
                    Group {
                        if let user = user, let firstLetter = user.name.first {
                            Text(String(firstLetter))
                                .font(.system(size: size * 0.4, weight: .medium))
                                .foregroundColor(.white)
                        } else {
                            Image(systemName: "person.fill")
                                .font(.system(size: size * 0.4))
                                .foregroundColor(.white)
                        }
                    }
                )
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(onTap == nil)
    }
}
