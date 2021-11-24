//
//  FormView.swift
//  Vaccine Registration
//
//  Created by Jacob Templeton on 11/24/21.
//

import SwiftUI
import CoreData

struct FormView : View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var name: String = ""
    @State private var birthday = Date()
    @State private var dateOfVaccine = Date()
    @State private var gender: String = ""
    @State private var typeOfVaccine: String = ""
    
    var body : some View {
        Form {
            Section(header: Text("Personal Info")){
                TextField("Full Name:", text: $name)
                
                DatePicker("Birthdate", selection: $birthday, displayedComponents: .date)
            
                DatePicker("Vaccine Date", selection: $dateOfVaccine, displayedComponents: .date)
                
                Menu("Gender") {
                    Button("Male", action: {gender = "Male"})
                    Button("Female", action: {gender = "Female"})
                    Button("Other", action: {gender = "Other"})
                }
                
                Menu("Vaccine Type") {
                    Button("Hepatitis A", action: {typeOfVaccine = "Hepatitis A"})
                    Button("Hepatitis B", action: {typeOfVaccine = "Hepatitis B"})
                    Button("Coronavirus", action: {typeOfVaccine = "Coronavirus"})
                    Button("Measles, Mumps, and Rubella", action: {typeOfVaccine = "MMR"})
                    Button("Chickenpox", action: {typeOfVaccine = "Chickenpox"})
                    Button("Polio", action: {typeOfVaccine = "Polio"})
                }
            }
        }
        .accentColor(.red)
        .onTapGesture {
            hideKeyboard()
        }
        
    }
    
    private func addPerson() {
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
}

struct FormView_Previews: PreviewProvider {
    static var previews: some View {
        FormView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

