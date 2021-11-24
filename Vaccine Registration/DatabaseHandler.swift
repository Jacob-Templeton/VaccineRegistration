//
//  DatabaseHandler.swift
//  Vaccine Registration
//
//  Created by Jacob Templeton on 11/24/21.
//

import SwiftUI
import CoreData

struct HandlePerson: View {
    private func addPerson(name: String, birthday: Date, dateOfVaccine: Date, gender: String, typeOfVaccine: String) {
        withAnimation {
            let newPerson = Person(context: viewContext)
            newPerson.name = name
            newPerson.birthday = birthday
            newPerson.dateOfVaccine = dateOfVaccine
            newPerson.gender = gender
            newPerson.typeOfVaccine = typeOfVaccine

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deletePerson(offsets: IndexSet) {
        withAnimation {
            offsets.map { people[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}
