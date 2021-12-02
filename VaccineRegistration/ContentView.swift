//
//  ContentView.swift
//  Vaccine Registration
//
//  Created by Jacob Templeton on 11/22/21.
//

import SwiftUI

// MARK: - Root view
struct ContentView: View
{
    private let sessionGradient = LinearGradient(
        stops: customGradients.linear[Int.random(in: 0..<customGradients.linear.count)].stops,
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    // Fetch data
    @FetchRequest(
        entity: Person.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Person.id, ascending: true),
            NSSortDescriptor(keyPath: \Person.name, ascending: true),
            NSSortDescriptor(keyPath: \Person.gender, ascending: false),
            NSSortDescriptor(keyPath: \Person.birthday, ascending: false),
            NSSortDescriptor(keyPath: \Person.dateOfVaccine, ascending: false),
            NSSortDescriptor(keyPath: \Person.typeOfVaccine, ascending: false)
        ],
        animation: .default)
    
    // Hold feteched data
    private var records: FetchedResults<Person>
    
    private let orientationChanged = NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)
            .makeConnectable()
            .autoconnect()
    
    @State private var orientation = UIDeviceOrientation.unknown
    
    @State private var mainWidth: CGFloat = UIScreen.main.bounds.width
    @State private var mainHeight: CGFloat = UIScreen.main.bounds.height
    
    @State private var query: String = ""
    
    var body: some View
    {
        Group
        {
            NavigationView
            {
                HomeView(records: records, gradientLayer: sessionGradient, mainWidth: mainWidth, mainHeight: mainHeight)
            }
            .searchable(text: $query, prompt: "Search for people")
            .searchBarModifier(backgroundColor: UIColor.white, tintColor: UIColor.systemIndigo.withAlphaComponent(0.5))
            .onChange(of: query)
            { newValue in
                // Filter record links by name from query input
                records.nsPredicate = newValue.isEmpty ? nil : NSPredicate(format: "name CONTAINS[c] %@", newValue)
            }
        }
        // Update orientation throughout app
        .onRotate
        { newOrientation in
            self.orientation = newOrientation
            self.mainWidth = UIScreen.main.bounds.width
            self.mainHeight = UIScreen.main.bounds.height
        }
    }
}

// Device rotation input handler
struct DeviceRotationViewModifier: ViewModifier {
    let action: (UIDeviceOrientation) -> Void

    func body(content: Content) -> some View {
        content
            .onAppear()
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                action(UIDevice.current.orientation)
            }
    }
}

// Consise call to DeviceRotationViewModifier
extension View {
    func onRotate(perform action: @escaping (UIDeviceOrientation) -> Void) -> some View {
        self.modifier(DeviceRotationViewModifier(action: action))
    }
}

// Gradient presets
class customGradients
{
    static let linear: [aGradient] = [
        aGradient(id: 1, name: "flame", stops: [
            Gradient.Stop(color: .yellow, location: 0.1 ),
            Gradient.Stop(color: .orange, location: 0.4 ),
            Gradient.Stop(color: .red   , location: 0.6 ),
            Gradient.Stop(color: .black , location: 0.8 )]),
        
        aGradient(id: 2, name: "reverseFlame", stops: [
            Gradient.Stop(color: .black , location: 0.2 ),
            Gradient.Stop(color: .red   , location: 0.4 ),
            Gradient.Stop(color: .orange, location: 0.7 ),
            Gradient.Stop(color: .yellow, location: 0.9 )]),
        
        aGradient(id: 3, name: "rainbow", stops: [
            Gradient.Stop(color: .red   , location: 0.1 ),
            Gradient.Stop(color: .orange, location: 0.25),
            Gradient.Stop(color: .yellow, location: 0.4 ),
            Gradient.Stop(color: .green , location: 0.6 ),
            Gradient.Stop(color: .blue  , location: 0.75),
            Gradient.Stop(color: .purple, location: 0.9 )]),
        
        aGradient(id: 4, name: "reverseRainbow", stops: [
            Gradient.Stop(color: .purple, location: 0.1 ),
            Gradient.Stop(color: .blue  , location: 0.25),
            Gradient.Stop(color: .green , location: 0.4 ),
            Gradient.Stop(color: .yellow, location: 0.6 ),
            Gradient.Stop(color: .orange, location: 0.75),
            Gradient.Stop(color: .red   , location: 0.9 )]),
        
        aGradient(id: 5, name: "redBlue", stops: [
            Gradient.Stop(color: .red   , location: 0.1 ),
            Gradient.Stop(color: .purple, location: 0.6 ),
            Gradient.Stop(color: .blue  , location: 1   )]),
        
        aGradient(id: 6, name: "blueRed", stops: [
            Gradient.Stop(color: .blue  , location: 0.1 ),
            Gradient.Stop(color: .purple, location: 0.6 ),
            Gradient.Stop(color: .red   , location: 1   )])
    ]
}
