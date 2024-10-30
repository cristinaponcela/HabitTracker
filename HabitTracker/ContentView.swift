//
//  ContentView.swift
//  HabitTracker
//
//  Created by Cristina Poncela on 29/10/24.
//
import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authManager: AuthManager // Access auth manager
    
    var body: some View {
        TabView {
            CalendarView()
                .tabItem {
                    Image(systemName: "calendar")
                    Text("Calendar")
                }

            FriendsListView()
                .tabItem {
                    Image(systemName: "person.3")
                    Text("Friends List")
                }
        }
    }
}

struct CalendarView: View {
    @State private var currentDate = Date()
    
    var body: some View {
        VStack {
            // Navigation arrows and date
            HStack {
                Button(action: {
                    changeDate(by: -1)
                }) {
                    Image(systemName: "chevron.left") // Updated icon
                        .font(.title)
                        .padding(.horizontal)
                }
                
                VStack(spacing: 4) {
                    // Day of the week
                    Text(formattedDayOfWeek)
                        .font(.title)
                        .fontWeight(.bold)
                    
                    // Date with ordinal suffix
                    Text(formattedDateWithSuffix)
                        .font(.headline)
                        .foregroundColor(.secondary)
                }
                
                Button(action: {
                    changeDate(by: 1)
                }) {
                    Image(systemName: "chevron.right") // Updated icon
                        .font(.title)
                        .padding(.horizontal)
                }
            }
            
            Spacer()
        }
        .contentShape(Rectangle()) // Make the entire VStack tappable/swipeable
        .gesture(
            DragGesture()
                .onEnded { value in
                    if value.translation.width < 0 { // Swipe left
                        changeDate(by: 1)
                    } else if value.translation.width > 0 { // Swipe right
                        changeDate(by: -1)
                    }
                }
        )
    }
    
    // Function to change date by a specified number of days
    private func changeDate(by days: Int) {
        if let newDate = Calendar.current.date(byAdding: .day, value: days, to: currentDate) {
            currentDate = newDate
        }
    }
    
    // Formatted day of the week (e.g., "THURSDAY")
    private var formattedDayOfWeek: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE" // Full day name
        return formatter.string(from: currentDate).uppercased()
    }
    
    // Formatted date with ordinal suffix (e.g., "3rd October")
    private var formattedDateWithSuffix: String {
        let day = Calendar.current.component(.day, from: currentDate)
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM" // Month name
        
        return "\(day.ordinalSuffix()) \(formatter.string(from: currentDate))"
    }
}

// Extension to add ordinal suffix (e.g., "1st", "2nd", "3rd")
extension Int {
    func ordinalSuffix() -> String {
        let suffix: String
        switch self % 10 {
        case 1: suffix = (self % 100 == 11) ? "th" : "st"
        case 2: suffix = (self % 100 == 12) ? "th" : "nd"
        case 3: suffix = (self % 100 == 13) ? "th" : "rd"
        default: suffix = "th"
        }
        return "\(self)\(suffix)"
    }
}


struct FriendsListView: View {
    @EnvironmentObject var authManager: AuthManager // Access auth manager for log out
    
    var body: some View {
        VStack {
            Text("Friends List View")
                .font(.largeTitle)
                .padding()
            
            Spacer()
            
            Button(action: {
                authManager.logOut() // Trigger log out action
            }) {
                Text("Log Out")
                    .foregroundColor(.red)
                    .padding()
                    .background(Color(.systemGray5))
                    .cornerRadius(10)
            }
            .padding(.bottom)
        }
    }
}
