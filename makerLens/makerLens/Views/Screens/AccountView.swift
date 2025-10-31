//
//  AccountView.swift
//  makerLens
//
//  Created by Priyanka Razdan on 8/30/25.
//

import SwiftUI

struct AccountView: View {
    @EnvironmentObject var firebaseService: FirebaseService
    @Environment(\.dismiss) var dismiss
    @State private var isEditing = false
    @State private var editedName: String = ""
    @State private var editedEmail: String = ""
    @State private var isSaving = false
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var showSignOutConfirmation = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: AppConstants.Spacing.xl) {
                    // Profile Header
                    VStack(spacing: AppConstants.Spacing.md) {
                        UserAvatar(user: firebaseService.currentUser, size: 100)
                        
                        if isEditing {
                            VStack(spacing: AppConstants.Spacing.sm) {
                                TextField("Name", text: $editedName)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .font(AppConstants.Fonts.body)
                                
                                TextField("Email", text: $editedEmail)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .keyboardType(.emailAddress)
                                    .autocapitalization(.none)
                                    .font(AppConstants.Fonts.body)
                            }
                            .padding(.horizontal, AppConstants.Spacing.xl)
                        } else {
                            Text(firebaseService.currentUser?.name ?? "User")
                                .font(AppConstants.Fonts.title)
                                .fontWeight(.bold)
                            
                            Text(firebaseService.currentUser?.email ?? "")
                                .font(AppConstants.Fonts.body)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.top, AppConstants.Spacing.lg)
                    
                    // Stats Cards
                    if let user = firebaseService.currentUser {
                        VStack(spacing: AppConstants.Spacing.md) {
                            // Points & Scans Row
                            HStack(spacing: AppConstants.Spacing.md) {
                                StatCard(
                                    icon: "star.fill",
                                    iconColor: AppConstants.Colors.primaryPurple,
                                    title: "Total Points",
                                    value: "\(user.totalPoints)"
                                )
                                
                                StatCard(
                                    icon: "camera.fill",
                                    iconColor: AppConstants.Colors.darkTeal,
                                    title: "Total Scans",
                                    value: "\(user.totalScans)"
                                )
                            }
                            
                            // Streak & Legacy Points Row
                            HStack(spacing: AppConstants.Spacing.md) {
                                StatCard(
                                    icon: "flame.fill",
                                    iconColor: .orange,
                                    title: "Day Streak",
                                    value: "\(user.streak)",
                                    subtitle: "\(String(format: "%.1f", user.streakMultiplier))x multiplier"
                                )
                                
                                StatCard(
                                    icon: "trophy.fill",
                                    iconColor: .yellow,
                                    title: "Legacy Points",
                                    value: "\(user.points)"
                                )
                            }
                            
                            // Last Scan Date
                            if let lastScan = user.lastScanDate {
                                HStack {
                                    Image(systemName: "clock.fill")
                                        .foregroundColor(.secondary)
                                    Text("Last scan: \(formatDate(lastScan))")
                                        .font(AppConstants.Fonts.caption)
                                        .foregroundColor(.secondary)
                                }
                                .padding(.top, AppConstants.Spacing.sm)
                            }
                        }
                        .padding(.horizontal, AppConstants.Spacing.lg)
                    }
                    
                    // Action Buttons
                    VStack(spacing: AppConstants.Spacing.md) {
                        if isEditing {
                            Button(action: saveChanges) {
                                if isSaving {
                                    ProgressView()
                                        .tint(.white)
                                        .frame(maxWidth: .infinity)
                                } else {
                                    Text("Save Changes")
                                        .frame(maxWidth: .infinity)
                                }
                            }
                            .primaryButtonStyle()
                            .disabled(isSaving)
                            
                            Button(action: {
                                isEditing = false
                                resetFields()
                            }) {
                                Text("Cancel")
                                    .frame(maxWidth: .infinity)
                            }
                            .secondaryButtonStyle()
                        } else {
                            Button(action: {
                                isEditing = true
                                editedName = firebaseService.currentUser?.name ?? ""
                                editedEmail = firebaseService.currentUser?.email ?? ""
                            }) {
                                HStack {
                                    Image(systemName: "pencil")
                                    Text("Edit Profile")
                                }
                                .frame(maxWidth: .infinity)
                            }
                            .primaryButtonStyle()
                        }
                        
                        Button(action: {
                            showSignOutConfirmation = true
                        }) {
                            HStack {
                                Image(systemName: "rectangle.portrait.and.arrow.right")
                                Text("Sign Out")
                            }
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity)
                        }
                        .secondaryButtonStyle()
                    }
                    .padding(.horizontal, AppConstants.Spacing.lg)
                    .padding(.bottom, AppConstants.Spacing.xl)
                }
            }
            .navigationTitle("Account")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            .alert("Error", isPresented: $showError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
            .confirmationDialog("Sign Out", isPresented: $showSignOutConfirmation) {
                Button("Sign Out", role: .destructive) {
                    signOut()
                }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("Are you sure you want to sign out?")
            }
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: date, relativeTo: Date())
    }
    
    private func resetFields() {
        editedName = firebaseService.currentUser?.name ?? ""
        editedEmail = firebaseService.currentUser?.email ?? ""
    }
    
    private func saveChanges() {
        guard !editedName.isEmpty, !editedEmail.isEmpty else {
            errorMessage = "Name and email cannot be empty"
            showError = true
            return
        }
        
        isSaving = true
        
        Task {
            do {
                try await firebaseService.updateUserProfile(name: editedName, email: editedEmail)
                await MainActor.run {
                    isEditing = false
                    isSaving = false
                }
            } catch {
                await MainActor.run {
                    errorMessage = error.localizedDescription
                    showError = true
                    isSaving = false
                }
            }
        }
    }
    
    private func signOut() {
        Task {
            do {
                try firebaseService.signOut()
                await MainActor.run {
                    dismiss()
                }
            } catch {
                await MainActor.run {
                    errorMessage = error.localizedDescription
                    showError = true
                }
            }
        }
    }
}

// MARK: - Stat Card Component
struct StatCard: View {
    let icon: String
    let iconColor: Color
    let title: String
    let value: String
    var subtitle: String? = nil
    
    var body: some View {
        VStack(spacing: AppConstants.Spacing.sm) {
            Image(systemName: icon)
                .font(.system(size: 30))
                .foregroundColor(iconColor)
            
            Text(value)
                .font(AppConstants.Fonts.title)
                .fontWeight(.bold)
            
            Text(title)
                .font(AppConstants.Fonts.caption)
                .foregroundColor(.secondary)
            
            if let subtitle = subtitle {
                Text(subtitle)
                    .font(.system(size: 11))
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(AppConstants.Spacing.md)
        .background(Color(.systemBackground))
        .cornerRadius(AppConstants.CornerRadius.md)
        .shadow(color: AppConstants.Shadow.light, radius: 2, x: 0, y: 1)
    }
}

// MARK: - Preview
struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView()
            .environmentObject(FirebaseService.shared)
    }
}
