//
//  RunTracker.swift
//  TrackMate
//
//  Created by Simarjeet Kaur on 26/07/25.
//

import Foundation
import MapKit

class RunTracker : NSObject,ObservableObject{
    @Published var region = MKCoordinateRegion(center: .init(latitude: 22.5744 , longitude: 88.3629), span:.init(latitudeDelta: 0.01, longitudeDelta: 0.01))
    
    @Published var isRunning = false
    @Published var presentPauseView = false
    @Published var presentCountdown: Bool = false
    @Published var presentRunView : Bool = false
    @Published var distance = 0.0
    @Published var pace = 0.0
    @Published var elapsedTime = 0
    @Published var locations = [CLLocationCoordinate2D]()
    private var timer : Timer?
    
    //Location Tracking
    private var locationManager : CLLocationManager?
    private var startLocation: CLLocation?
    private var lastLocation : CLLocation?
    
    override init(){
        super.init()
        
        Task{
            await MainActor.run{
                locationManager=CLLocationManager()
                locationManager?.delegate = self
                locationManager?.requestWhenInUseAuthorization()
                locationManager?.startUpdatingLocation()
            }
        }
    }
    func startRun(){
        presentRunView = true
        isRunning = true
        startLocation = nil
        lastLocation = nil
        distance = 0.0
        pace = 0.0
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self]_ in
            guard let self else {return}
            self.elapsedTime += 1
            if self.distance>0 {
                pace=(Double(self.elapsedTime)/60) / (self.distance/1000)
            }
            
        }
        locationManager?.startUpdatingLocation()
    }
    
    func stopRun() {
        isRunning = false
        presentRunView = false
        presentPauseView = false
        locationManager?.stopUpdatingLocation()

        timer?.invalidate()
        timer = nil

        let finalTime = elapsedTime  // Capture current time

        Task {
            do {
                try await postToDatabase(finalTime: finalTime)
            } catch {
                print("Error posting to database:", error)
            }
            await MainActor.run {
                self.elapsedTime = 0  // Only reset time
            }
        }
    }

    func pauseRun(){
        isRunning=false
        presentRunView = false
        presentPauseView = true
        locationManager?.stopUpdatingLocation()
        timer?.invalidate()
        
    }
    
    func resumeRun(){
        isRunning = true
        presentPauseView = false
        presentRunView = true
        startLocation = nil
        lastLocation = nil
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self]_ in
            guard let self else {return}
            self.elapsedTime += 1
            if self.distance>0 {
                pace=(Double(self.elapsedTime)/60) / (self.distance/1000)
            }
            
        }
        locationManager?.startUpdatingLocation()
    }
    
    func postToDatabase(finalTime: Int) async throws {
        guard let userId = AuthService.shared.currentSession?.user.id else { return }
        let run = RunPayload(
            createdAt: .now,
            userId: userId,
            distance: distance,
            pace: pace,
            time: finalTime,
            route: convertToJSONCoordinates(locations: locations)
        )
        try await DatabaseService.shared.saveWorkout(run: run)
    }
    
}
        
        
        extension RunTracker : CLLocationManagerDelegate {
            func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
                guard let location = locations.last else { return }
                
                
                
                DispatchQueue.main.async{[weak self] in
                    self?.region.center = location.coordinate
                }
                
                self.locations.append(location.coordinate)
                
                if startLocation==nil{
                    startLocation=location
                    lastLocation=location
                    return
                }
                if let lastLocation{
                    distance += lastLocation.distance(from: location)
                }
                
                lastLocation=location
            }
            
            
        }
        func convertToJSONCoordinates(locations:[CLLocationCoordinate2D]) -> [GeoJSONCoordinate]{
            return locations.map{GeoJSONCoordinate(longitude: $0.longitude, latitude: $0.latitude)}
        }
