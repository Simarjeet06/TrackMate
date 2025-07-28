//
//  AuthService.swift
//  TrackMate2
//
//  Created by Simarjeet Kaur on 27/07/25.
//

import Foundation
import Supabase


struct Secrets{
    static let supabaseURL=URL(string:"https://qqfzimfksvybprcoclcl.supabase.co")!
    static let supabaseKey="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFxZnppbWZrc3Z5YnByY29jbGNsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTM1MTM2NzEsImV4cCI6MjA2OTA4OTY3MX0.1DwdFrNTC6Ooz73KFJSbBIbRVZekUvLgNc_mNxmdWKs"
}
@Observable
final class AuthService{
    
    static let shared = AuthService()
    private var supabase = SupabaseClient(supabaseURL: Secrets.supabaseURL,
                                          supabaseKey: Secrets.supabaseKey)
    
    var currentSession: Session?
    private init(){
        Task{
            currentSession = try? await supabase.auth.session
        }
    }
    
    func magicLinkLogin(email : String) async throws  {
        try await supabase.auth.signInWithOTP(
          email: email,
          redirectTo: URL(string: "com.track-mate://login-callback")!
        )
    }
    
    func handleOpenURL(_ url: URL) async throws {
        currentSession = try await supabase.auth.session(from: url)
    }
    func logout() async throws {
        try await supabase.auth.signOut()
        currentSession = nil
    }
    
}
