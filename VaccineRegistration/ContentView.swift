//
//  ContentView.swift
//  Vaccine Registration
//
//  Created by Jacob Templeton on 11/22/21.
//

import SwiftUI

struct ContentView: View
{
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
    
    private var records: FetchedResults<Person>

    @State private var query: String = ""
    
    var body: some View
    {
        NavigationView
        {
            HomeView(records: records)
                .navigationTitle("Home")
        }
        .searchable(text: $query, placement: .navigationBarDrawer, prompt: "Search for people")
    }
}

struct ContentView_Previews: PreviewProvider
{
    static var previews: some View
    {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
