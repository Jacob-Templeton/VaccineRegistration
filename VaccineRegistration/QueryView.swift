//
//  QueryView.swift
//  Vaccine Registration
//
//  Created by Jacob Templeton on 11/24/21.
//

import SwiftUI
import CoreData

struct QueryView: View
{
    
    @Environment(\.managedObjectContext) private var viewContext
    
    let records: FetchedResults<Person>
    
    var body: some View
    {
        List
        {
            ForEach(records, id: \.id) { record in
                NavigationLink
                {
                    VStack(alignment: .leading)
                    {
                        Group
                        {
                            Group
                            {
                                Text("**ID:** \(record.id)")
                                Spacer()
                                Text("**Name:** \(record.name)")
                                Spacer()
                                Text("**Birthdate:** \(record.birthday)")
                                Spacer()
                            }
                            Group
                            {
                                Text("**Vaccination Date:** \(record.dateOfVaccine)")
                                Spacer()
                                Text("**Gender:** \(record.gender)")
                                Spacer()
                                Text("**Vaccination Type:** \(record.typeOfVaccine)")
                                Spacer()
                            }
                        }
                    }
                .navigationTitle("\(record.name)")
                .padding(EdgeInsets(top: 20, leading: 10, bottom: 20, trailing: 10))
                } label: {
                    Text("\(record.name)'s Vaccination Record")
                }
            }
            .onDelete(perform: deletePerson)
        }
        .toolbar
        {
            ToolbarItem(placement: .navigationBarTrailing)
            {
                EditButton()
                    .tint(.purple)
                    .font(Font.body.weight(.semibold))
            }
        }
    }
    
    private func deletePerson(offsets: IndexSet)
    {
        withAnimation {
            offsets.map { records[$0] }.forEach(viewContext.delete)

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
