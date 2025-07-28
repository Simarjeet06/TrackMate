//
//  ActivityView.swift
//  TrackMate2
//
//  Created by Simarjeet Kaur on 28/07/25.
//

import SwiftUI

struct ActivityView: View {
    @State var activities = [RunPayload]()
    var body: some View {
        NavigationStack {
            List {
                ForEach(activities) { activity in
                    NavigationLink {
                        ActivityItemView(run: activity)
                    } label: {
                        VStack(alignment:.leading){
                            Text("Morning Run")
                                .font(.title2)
                                .bold()
                            
                            Text(formatDate(date: activity.createdAt))
                                .font(.caption)
                            
                            HStack(spacing:24){
                                VStack{
                                    Text("Distance")
                                        .font(.caption)
                                    
                                    Text("\(activity.distance/1000,specifier: "%.2f") km")
                                        .bold()
                                }
                                VStack{
                                    Text("Pace")
                                        .font(.caption)
                                    Text("\(Int(activity.pace).convertDurationToString()) /km")
                                        .bold()
                                }
                                
                                VStack{
                                    Text("Time")
                                        .font(.caption)
                                    Text("\(activity.time.convertDurationToString())")
                                        .bold()
                                }
                                
                            }
                            .padding(.vertical)
                        }
                        .frame(maxWidth:.infinity,alignment:.leading)
                    }
                }
            }
                .listStyle(.plain)
                .navigationTitle("Activity")
                .toolbar{
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(role: .destructive) {
                            Task{
                                do{
                                    try await AuthService.shared.logout()
                                    
                                }catch{
                                    print(error.localizedDescription)
                                }
                            }
                        } label:{
                            Text("Logout")
                                .foregroundStyle(.red)
                        }
                    }
                }
                .onAppear{
                    Task{
                        do{
                            activities =  try await DatabaseService.shared.fetchWorkout()
                            
                            activities.sort(by: {$0.createdAt >= $1.createdAt})
                        }catch{
                            print(error.localizedDescription)
                        }
                    }
                }
                
            }
        }
    
    
    
    func formatDate(date : Date)->String{
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        return formatter.string(from: date)
        
    }
}

#Preview {
    ActivityView()
}
