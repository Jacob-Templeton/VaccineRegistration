//
//  FormView.swift
//  Vaccine Registration
//
//  Created by Jacob Templeton on 11/24/21.
//

import SwiftUI
import CoreData

class TemporaryData : ObservableObject // Temporarily holds unsubmitted data until the app is closed
{
    @Published var name: String = ""
    @Published var birthday = Date()
    @Published var dateOfVaccine = Date()
    @Published var gender: String = ""
    @Published var typeOfVaccine: String = ""
    @Published var id: UUID = UUID()
}

@available(iOS 15.0, *)
struct FormView : View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @StateObject var data: TemporaryData
    
    // MARK: - Focus states for input error alert handling
    @FocusState private var focusedName: Bool
    @FocusState private var focusedGender: Bool
    @FocusState private var focusedVaccineType: Bool
    
    @State private var isSubmitted: Bool = false
    
    // MARK: - Color Presets
    private let purpleRed = [
        Gradient.Stop(color: .purple, location: 0.2),
        Gradient.Stop(color: .gray  , location: 0.4),
        Gradient.Stop(color: .red   , location: 0.6)
    ]
    
    var body : some View
    {
        VStack
        {
            Form
            {
                Section(header: Text("Personal Info"))
                {
                    VStack(alignment: .leading)
                    {
                        // Name field
                        TextField("Full Name:", text: $data.name)
                            .focused($focusedName)
                        
                        // Displays name errors
                        if(!focusedName)
                        {
                            if(data.name.isEmpty)
                            {
                                Text("Enter a name")
                                    .foregroundStyle(.secondary)
                                    .foregroundGradient(stops: purpleRed)
                            }
                            else if(!data.name.isAlpha)
                            {
                                Text("Only include letters in your name")
                                    .foregroundStyle(.secondary)
                                    .foregroundGradient(stops: purpleRed)
                            }
                        }
                    }
                    
                    // Birthday date picker
                    DatePicker(
                        selection: $data.birthday,
                        in: ...Date(),
                        displayedComponents: [.date]
                    )
                    {
                        Text("Birthdate")
                            .foregroundColor(.purple)
                            .font(Font.body.weight(.semibold))
                    }
                    .accentColor(Color.pink)
                    
                    // Date of vaccine picker
                    DatePicker(
                        selection: $data.dateOfVaccine,
                        in: Date()...,
                        displayedComponents: [.date]
                    )
                    {
                        Text("Vaccine Date")
                            .foregroundColor(.purple)
                            .font(Font.body.weight(.semibold))
                    }
                    .accentColor(Color.pink)
                    
                    // Gender option menu
                    VStack(alignment: .leading)
                    {
                        HStack
                        {
                            Menu
                            {
                                Button("Male"   , action: { data.gender = "Male"   })
                                Button("Female" , action: { data.gender = "Female" })
                                Button("Other"  , action: { data.gender = "Other"  })
                            }
                            label:
                            {
                                Text("Gender")
                                Image(systemName: "person")
                            }
                            .font(Font.body.weight(.semibold))
                            .foregroundColor(.purple)
                            Spacer()
                            Text("\(data.gender)")
                        }
                        
                        // Displays unselected gender type error
                        if(!focusedGender)
                        {
                            if(data.gender.isEmpty)
                            {
                                Text("Select a gender")
                                    .foregroundStyle(.secondary)
                                    .foregroundGradient(stops: purpleRed)
                            }
                        }
                    }
                    
                    // Vaccine option menu
                    VStack(alignment: .leading)
                    {
                        HStack
                        {
                            Menu
                            {
                                Button("Hepatitis A"                 , action: { data.typeOfVaccine = "Hepatitis A" })
                                Button("Hepatitis B"                 , action: { data.typeOfVaccine = "Hepatitis B" })
                                Button("Coronavirus"                 , action: { data.typeOfVaccine = "Coronavirus" })
                                Button("Measles, Mumps, and Rubella" , action: { data.typeOfVaccine = "MMR"         })
                                Button("Chickenpox"                  , action: { data.typeOfVaccine = "Chickenpox"  })
                                Button("Polio"                       , action: { data.typeOfVaccine = "Polio"       })
                            }
                            label:
                            {
                                Text("Vaccine Type")
                                Image(systemName: "text.magnifyingglass")
                            }
                            .font(Font.body.weight(.semibold))
                            .foregroundColor(.purple)
                            
                            Spacer()
                            Text("\(data.typeOfVaccine)")
                        }
                        
                        // Displays unselected vaccine type error
                        if(!focusedVaccineType)
                        {
                            if(data.typeOfVaccine.isEmpty)
                            {
                                Text("Select a vaccine type")
                                    .foregroundStyle(.secondary)
                                    .foregroundGradient(stops: purpleRed)
                            }
                        }
                    }
                }
            }
            .onTapGesture {
                hideKeyboard()
            }
            
            // Submit button
            LargeButton(
                title: "Submit",
                backgroundColor: .purple,
                action:
                {
                    addPerson(); // Submit form to database
                    data.name          = ""     ; // Start reset of form
                    data.birthday      = Date() ;
                    data.dateOfVaccine = Date() ;
                    data.gender        = ""     ;
                    data.typeOfVaccine = ""     ;
                    data.id            = UUID() ;
                    isSubmitted        = true   ; // End reset of form
                }
            )
                // Disables the button when there are any errors in the input
                .disabled(data.name.isEmpty || data.gender.isEmpty || data.typeOfVaccine.isEmpty || !data.name.isAlpha)
                .tint(.purple)
                .alert(isPresented: $isSubmitted)
                {
                    Alert(title: Text("Form Submitted"), dismissButton: .default(Text("Okay")))
                }
        }
    }
    
    // Adds a person to the database
    private func addPerson()
    {
        withAnimation
        {
            let newPerson = Person(context: viewContext)
            newPerson.name          = data.name
            newPerson.birthday      = data.birthday
            newPerson.dateOfVaccine = data.dateOfVaccine
            newPerson.gender        = data.gender
            newPerson.typeOfVaccine = data.typeOfVaccine
            newPerson.id            = data.id

            do
            {
                try viewContext.save()
            }
            catch
            {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

