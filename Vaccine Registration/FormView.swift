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
        NavigationView {
            VStack(alignment: .leading){
                TextField("Name:", text: $name)
                    .font(.title2)
                
                Spacer()
                
                ZStack(alignment: .leading) {
                    DatePicker("Birthday", selection: $birthday, displayedComponents: [.date])
                        .datePickerStyle(CompactDatePickerStyle())
                        .labelsHidden()
                    Image(systemName: "calendar")
                        .resizable()
                        .frame(width: 32, height: 32, alignment: .leading)
                        .userInteractionDisabled()
                }
                
                Spacer()
                
                ZStack(alignment: .leading) {
                    DatePicker("VaccineDate", selection: $dateOfVaccine, displayedComponents: [.date])
                        .datePickerStyle(CompactDatePickerStyle())
                        .labelsHidden()
                    Image(systemName: "calendar")
                        .resizable()
                        .frame(width: 32, height: 32, alignment: .leading)
                        .userInteractionDisabled()
                }
            }
            .padding()
            
            
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

