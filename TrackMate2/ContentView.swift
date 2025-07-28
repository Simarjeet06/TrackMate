//
//  ContentView.swift
//  TrackMate2
//
//  Created by Simarjeet Kaur on 27/07/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        
        if let session = AuthService.shared.currentSession {
            RunClubTabView()
        }
        else{
            LoginView()
        }
    }
}
#Preview {
    ContentView()
}
