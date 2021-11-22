//
//  Vaccine_RegistrationApp.swift
//  Vaccine Registration
//
//  Created by Jacob Templeton on 11/22/21.
//

import SwiftUI

@main
struct Vaccine_RegistrationApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
