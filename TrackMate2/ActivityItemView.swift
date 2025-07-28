//
//  ActivityItemView.swift
//  TrackMate2
//
//  Created by Simarjeet Kaur on 28/07/25.
//

import SwiftUI
import MapKit

struct ActivityItemView: View {

     var run : RunPayload
    var body: some View {
        VStack(alignment:.leading){
            Text("Morning Run")
                .font(.title2)
                .bold()
            
            Text(run.createdAt.formatDate())
                .font(.caption)
            
            HStack(spacing:24){
                VStack{
                    Text("Distance")
                        .font(.caption)
                    
                    Text("\(run.distance/1000,specifier: "%.2f") km")
                        .bold()
                }
                VStack{
                    Text("Pace")
                        .font(.caption)
                    Text("\(Int(run.pace).convertDurationToString()) /km")
                        .bold()
                }
                
                VStack{
                    Text("Time")
                        .font(.caption)
                    Text("\(run.time.convertDurationToString())")
                        .bold()
                }
                
            }
            .padding(.vertical)
            Map{
                MapPolygon(coordinates: convertToRouteCoordinates(geoJsons: run.route))
                    .stroke(.yellow, style: StrokeStyle(lineWidth: 3,lineCap: .round,lineJoin: .round))
            }
        }
        .frame(maxWidth:.infinity,maxHeight:.infinity,alignment:.leading)
    }
    
    
    func convertToRouteCoordinates(geoJsons:[GeoJSONCoordinate]) -> [CLLocationCoordinate2D]{
        return geoJsons.map{CLLocationCoordinate2D( latitude: $0.latitude,longitude: $0.longitude)}
    }
    
}
#Preview {
    ActivityItemView(run:RunPayload(createdAt: .now, userId: .init(),distance: 12313, pace: 12, time: 1241, route: [GeoJSONCoordinate(longitude: 88.2, latitude: 22.4)]))
}
