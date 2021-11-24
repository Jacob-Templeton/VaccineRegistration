//
//  QueryView.swift
//  Vaccine Registration
//
//  Created by Jacob Templeton on 11/24/21.
//

import SwiftUI

struct QueryView: View {
    
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        entity: Person.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Person.name, ascending: true),
            NSSortDescriptor(keyPath: \Person.birthday, ascending: true),
            NSSortDescriptor(keyPath: \Person.dateOfVaccine, ascending: true),
            NSSortDescriptor(keyPath: \Person.gender, ascending: true),
            NSSortDescriptor(keyPath: \Person.typeOfVaccine, ascending: true)
        ],
        animation: .default)
    
    private var people: FetchedResults<Person> // ITEMS
    
    var body: some View {
        
        List {
            ForEach(people) { Person in
                NavigationLink {
                    Text("Item at \(Person.birthday)")
                } label: {
                    Text("PlaceHolder")
                }
            }
            .onDelete(perform: deletePerson)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                EditButton()
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

struct QueryView_Previews: PreviewProvider {
    static var previews: some View {
        QueryView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
