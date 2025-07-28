//
//  DatabaseService.swift
//  TrackMate2
//
//  Created by Simarjeet Kaur on 28/07/25.
//

import Foundation
import Supabase

struct Table{
    static let workouts = "workouts"
}
struct RunPayload: Identifiable , Codable{
    var id : Int?
    let createdAt : Date
    let userId : UUID
    let distance : Double
    let pace : Double
    let time : Int
    let route :[GeoJSONCoordinate]
    
    enum CodingKeys : String, CodingKey {
        case id,distance,pace,time,route
        case createdAt = "created_at"
        case userId = "user_id"
    }
}
struct GeoJSONCoordinate : Codable{
    let longitude : Double
    let latitude : Double
}
final class DatabaseService {
    
    static let shared = DatabaseService()
    private var supabase = SupabaseClient(supabaseURL: Secrets.supabaseURL, supabaseKey: Secrets.supabaseKey)
    
    
    private init() {}
    //CRUD
    
    func saveWorkout(run : RunPayload) async throws{
        let _  = try await supabase.from(Table.workouts).insert(run).execute().value
        
    }
    
    func fetchWorkout() async throws -> [RunPayload] {
        return try await supabase.from(Table.workouts).select().execute().value
    }
}
