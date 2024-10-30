//
//  HabitTrackerApp.swift
//  HabitTracker
//
//  Created by Cristina Poncela on 29/10/24.
//

import SwiftUI

@main
struct HabitTrackerApp: App {
    @StateObject private var authManager = AuthManager()
    
    var body: some Scene {
        WindowGroup {
            if authManager.isAuthenticated {
                ContentView() // Main app view for authenticated users
                    .environmentObject(authManager)
            } else {
                AuthView() // Login/Sign-up view
                    .environmentObject(authManager)
            }
        }
    }
}
