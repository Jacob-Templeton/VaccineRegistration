//
//  FormView.swift
//  Vaccine Registration
//
//  Created by Jacob Templeton on 11/24/21.
//

import SwiftUI
import CoreData

class TemporaryData : ObservableObject {
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
    
    @FocusState private var focusedName: Bool
    @FocusState private var focusedGender: Bool
    @FocusState private var focusedVaccineType: Bool
    
    @State private var isSubmitted: Bool = false
    
    // MARK: - Color Presets
    private let purpleRed = [Gradient.Stop(color: .purple, location: 0.2), Gradient.Stop(color: .gray, location: 0.4), Gradient.Stop(color: .red, location: 0.6)]
    
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
                        TextField("Full Name:", text: $data.name)
                            .focused($focusedName)
                        
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
                    
                    DatePicker(selection: $data.birthday, in: ...Date(), displayedComponents: [.date]){
                        Text("Birthdate")
                            .foregroundColor(.purple)
                            .font(Font.body.weight(.semibold))
                    }
                    
                    DatePicker (
                        selection: $data.dateOfVaccine,
                        in: Date()...,
                        displayedComponents: [.date] )
                    {
                        Text("Vaccine Date")
                            .foregroundColor(.purple)
                            .font(Font.body.weight(.semibold))
                    }
                        
                    VStack(alignment: .leading)
                    {
                        HStack
                        {
                            Menu {
                                Button("Male", action: {data.gender = "Male"})
                                Button("Female", action: {data.gender = "Female"})
                                Button("Other", action: {data.gender = "Other"})
                            } label: {
                                Text("Gender")
                                Image(systemName: "person")
                            }
                            .font(Font.body.weight(.semibold))
                            .foregroundColor(.purple)
                            Spacer()
                            Text("\(data.gender)")
                        }
                        
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
                    
                    VStack(alignment: .leading)
                    {
                        HStack
                        {
                            Menu {
                                Button("Hepatitis A", action: {data.typeOfVaccine = "Hepatitis A"})
                                Button("Hepatitis B", action: {data.typeOfVaccine = "Hepatitis B"})
                                Button("Coronavirus", action: {data.typeOfVaccine = "Coronavirus"})
                                Button("Measles, Mumps, and Rubella", action: {data.typeOfVaccine = "MMR"})
                                Button("Chickenpox", action: {data.typeOfVaccine = "Chickenpox"})
                                Button("Polio", action: {data.typeOfVaccine = "Polio"})
                            } label: {
                                Text("Vaccine Type")
                                Image(systemName: "text.magnifyingglass")
                            }
                            .font(Font.body.weight(.semibold))
                            .foregroundColor(.purple)
                            
                            Spacer()
                            Text("\(data.typeOfVaccine)")
                        }
                        
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
            
            LargeButton(title: "Submit", backgroundColor: .purple, action: {
                addPerson();
                data.name = "";
                data.birthday = Date();
                data.dateOfVaccine = Date();
                data.gender = "";
                data.typeOfVaccine = "";
                data.id = UUID()
                isSubmitted = true;
            })
                .disabled(data.name.isEmpty || data.gender.isEmpty || data.typeOfVaccine.isEmpty || !data.name.isAlpha)
                .tint(.purple)
                .alert(isPresented: $isSubmitted) {
                    Alert(title: Text("Form Submitted"), dismissButton: .default(Text("Okay")))
            }
        }
    }
    
    private func addPerson()
    {
        withAnimation {
            let newPerson = Person(context: viewContext)
            newPerson.name = data.name
            newPerson.birthday = data.birthday
            newPerson.dateOfVaccine = data.dateOfVaccine
            newPerson.gender = data.gender
            newPerson.typeOfVaccine = data.typeOfVaccine
            newPerson.id = data.id

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

struct LargeButtonStyle: ButtonStyle
{
    
    let backgroundColor: Color
    let foregroundColor: Color
    let isDisabled: Bool
    
    func makeBody(configuration: Self.Configuration) -> some View
    {

        let currentForegroundColor = isDisabled || configuration.isPressed ? foregroundColor.opacity(0.3) : foregroundColor
        return configuration.label
            .padding()
            .foregroundColor(currentForegroundColor)
            .background(isDisabled || configuration.isPressed ? backgroundColor.opacity(0.3) : backgroundColor)
            // This is the key part, we are using both an overlay as well as cornerRadius
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(currentForegroundColor, lineWidth: 1)
            )
            .padding([.top, .bottom], 10)
            .font(Font.system(size: 19, weight: .semibold))
    }
}

struct LargeButton: View
{
    
    private static let buttonHorizontalMargins: CGFloat = 20
    
    var backgroundColor: Color
    var foregroundColor: Color
    
    private let title: String
    private let action: () -> Void
    
    @Environment(\.isEnabled) private var isEnabled: Bool
    
    init(title: String,
         disabled: Bool = false,
         backgroundColor: Color = Color.green,
         foregroundColor: Color = Color.white,
         action: @escaping () -> Void)
    {
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
        self.title = title
        self.action = action
    }
    
    var body: some View
    {
        HStack
        {
            Spacer(minLength: LargeButton.buttonHorizontalMargins)
            Button(action:self.action)
            {
                Text(self.title)
                    .frame(maxWidth:.infinity)
            }
            .buttonStyle(LargeButtonStyle(backgroundColor: backgroundColor,
                                          foregroundColor: foregroundColor,
                                          isDisabled: !isEnabled))
                .disabled(!isEnabled)
            Spacer(minLength: LargeButton.buttonHorizontalMargins)
        }
        .frame(maxWidth:.infinity)
    }
}


extension String
{
    var isAlpha: Bool
    {
        return !isEmpty && range(of: "[^a-zA-Z\\s]", options: .regularExpression) == nil
    }
}

