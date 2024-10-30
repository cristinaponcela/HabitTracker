//
//  ContentView.swift
//  HabitTracker
//
//  Created by Cristina Poncela on 29/10/24.
//
import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authManager: AuthManager
    
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
                    Image(systemName: "chevron.left")
                        .font(.title)
                        .padding(.horizontal)
                }
                
                VStack(spacing: 4) {
                    Text(formattedDayOfWeek)
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text(formattedDateWithSuffix)
                        .font(.headline)
                        .foregroundColor(.secondary)
                }
                
                Button(action: {
                    changeDate(by: 1)
                }) {
                    Image(systemName: "chevron.right")
                        .font(.title)
                        .padding(.horizontal)
                }
            }
            .padding()
            
            // Scrollable view of hourly slots with a current time indicator
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(spacing: 0) {
                        ForEach(0..<24, id: \.self) { hour in
                            HStack(spacing: 4) {
                                Text(hourText(for: hour))
                                    .font(.headline)
                                    .frame(width: 60, alignment: .leading)
                                
                                // Normal hourly line
                                Rectangle()
                                    .fill(Color.gray)
                                    .frame(height: 1)
                                    .frame(maxWidth: .infinity)
                                    .padding(.trailing, 10)
                            }
                            .frame(height: 60)
                            .id(hour)
                            
                            // Check if this is the current hour, then add a time line indicator
                            if hour == currentHour {
                                currentTimeIndicator
                            }
                        }
                    }
                    .padding(.horizontal)
                    .onAppear {
                        // Scroll to the current hour on appear
                        proxy.scrollTo(currentHour, anchor: .top)
                    }
                    .onChange(of: currentDate) { _ in
                        // Reset scroll to the current hour when date changes
                        proxy.scrollTo(currentHour, anchor: .top)
                    }
                }
            }
        }
        .contentShape(Rectangle())
        .gesture(
            DragGesture()
                .onEnded { value in
                    if value.translation.width < 0 {
                        changeDate(by: 1)
                    } else if value.translation.width > 0 {
                        changeDate(by: -1)
                    }
                }
        )
    }
    
    // A view for the current time indicator line
    private var currentTimeIndicator: some View {
        HStack(spacing: 4) {
            // Display current time in red color
            Text(currentTimeText)
                .font(.headline)
                .foregroundColor(.red)
                .frame(width: 60, alignment: .leading)
            
            Rectangle()
                .fill(Color.red)
                .frame(height: 1)
                .frame(maxWidth: .infinity)
                .padding(.trailing, 10)
        }
        .padding(.bottom, 10) // Optional: Add some space to separate the current time line
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
        formatter.dateFormat = "EEEE"
        return formatter.string(from: currentDate).uppercased()
    }
    
    // Formatted date with ordinal suffix (e.g., "3rd October")
    private var formattedDateWithSuffix: String {
        let day = Calendar.current.component(.day, from: currentDate)
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        
        return "\(day.ordinalSuffix()) \(formatter.string(from: currentDate))"
    }
    
    // Function to format the hour in 24-hour format
    private func hourText(for hour: Int) -> String {
        let date = Calendar.current.date(bySettingHour: hour, minute: 0, second: 0, of: currentDate) ?? Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
    
    // Function to get the current time in HH:mm format
    private var currentTimeText: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: currentDate)
    }
    
    // Current hour and time values
    private var currentHour: Int {
        let calendar = Calendar.current
        return calendar.component(.hour, from: currentDate)
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
    @EnvironmentObject var authManager: AuthManager
    
    var body: some View {
        VStack {
            Text("Friends List View")
                .font(.largeTitle)
                .padding()
            
            Spacer()
            
            Button(action: {
                authManager.logOut()
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
