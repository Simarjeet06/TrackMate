//
//  HomeView.swift
//  TrackMate2
//
//  Created by Simarjeet Kaur on 27/07/25.
//

import SwiftUI
import MapKit

        struct AreaMap : View{
            @Binding var region : MKCoordinateRegion
            
            var body :some View{
                
                let binding = Binding(
                    get : {self.region},
                    set : {newValue in
                        DispatchQueue.main.async{
                            self.region = newValue
                        }
                    }
                )
                return Map(coordinateRegion: binding,showsUserLocation: true)
                    .ignoresSafeArea()
            }
        }
        struct HomeView: View {
            @StateObject var runTracker = RunTracker()
            
            var body: some View {
                NavigationStack{
                        VStack{
                           ZStack(alignment:.bottom){
                               
                              /* Map(coordinateRegion: $runTracker.region, showsUserLocation: true)*/
                               AreaMap(region : $runTracker.region)
                            
                            Button {
                                runTracker.presentCountdown = true
                            } label: {
                                Text("Start")
                                    .bold()
                                    .font(.title)
                                    .foregroundColor(.black)
                                    .padding(26)
                                    .background(Color.yellow)
                                    .clipShape(.circle)
                                
                            }
                            .padding(.bottom,48)
                            
                        }
                           .frame(maxHeight:.infinity,alignment:.top)
                        .navigationTitle("Run")
                        .fullScreenCover(isPresented: $runTracker.presentCountdown) {
                            CountdownView()
                                .environmentObject(runTracker)
                        }
                            
                        .fullScreenCover(isPresented: $runTracker.presentRunView) {
                            RunView()
                                .environmentObject(runTracker)
                        }
                        .fullScreenCover(isPresented: $runTracker.presentPauseView) {
                            PauseView()
                                .environmentObject(runTracker)
                        }

                    }

                }
                    }

        }


#Preview {
    HomeView()
}
