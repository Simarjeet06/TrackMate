//
//  PauseView.swift
//  TrackMate
//
//  Created by Simarjeet Kaur on 26/07/25.
//

import SwiftUI
import MapKit
import AudioToolbox

struct PauseView: View {
    @EnvironmentObject var runTracker : RunTracker
    var body: some View {
        VStack{
            AreaMap(region: $runTracker.region)
                .ignoresSafeArea()
                .frame(height: 300)
            
            HStack{
                VStack{
                    Text("\(runTracker.distance/1000 , specifier: "%.2f") km")
                        .font(.title3)
                        .bold()
                    
                    Text("km")
                }
                .frame(maxWidth: .infinity)
                
                
                VStack{
                    Text("\(runTracker.pace , specifier: "%.2f") min")
                        .font(.title3)
                        .bold()
                    
                    Text("Avg Pace")
                    
                }
                .frame(maxWidth: .infinity)
                
                VStack{
                    Text("\(runTracker.elapsedTime.convertDurationToString())")
                        .font(.title3)
                        .bold()
                    
                    Text("Time")
                }
                .frame(maxWidth: .infinity)
            }
            .padding()
            
            HStack{
                VStack{
                    Text("0")
                        .font(.title3)
                        .bold()
                    
                    Text("Calories")
                }
                .frame(maxWidth: .infinity)
                
                
                VStack{
                    Text("0f")
                        .font(.title3)
                        .bold()
                    
                    Text("Elevation")
                    
                }
                .frame(maxWidth: .infinity)
                
                VStack{
                    Text("65")
                        .font(.title3)
                        .bold()
                    
                    Text("BPM")
                }
                .frame(maxWidth: .infinity)
            }
            .padding()
            
            HStack{
                Button {
                    //no action on tap of stop button
                } label: {
                    Image(systemName: "stop.fill")
                        .font(.largeTitle)
                        .foregroundStyle(.white)
                        .padding(40)
                        .background(.black)
                        .clipShape(.circle)
    
                }
                .frame(maxWidth:.infinity)
                .simultaneousGesture(LongPressGesture().onEnded({ _ in
                    withAnimation{
                        runTracker.stopRun()
                        AudioServicesPlayAlertSoundWithCompletion(SystemSoundID(kSystemSoundID_Vibrate)) {
                            
                        }
                    }
                }))

                Button {
                    withAnimation {
                        runTracker.resumeRun()
                    }
                } label: {
                    Image(systemName: "play.fill")
                        .font(.largeTitle)
                        .foregroundStyle(.white)
                        .padding(40)
                        .background(.black)
                        .clipShape(.circle)
    
                }
                .frame(maxWidth:.infinity)

            }
            .frame(maxHeight:.infinity,alignment: .bottom)
        }
        .frame(maxHeight: .infinity , alignment: .top)
    }
}

#Preview {
    PauseView()
        .environmentObject(RunTracker())
}

