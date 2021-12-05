//
//  HomeView.swift
//  VaccineRegistration
//
//  Created by Jacob Templeton on 11/26/21.
//

import SwiftUI

struct HomeView: View
{
    @Environment(\.managedObjectContext) private var viewContext
    
    // Recieved Constants
    let records: FetchedResults<Person>
    let gradientLayer: LinearGradient
    let mainWidth: CGFloat
    let mainHeight: CGFloat
    
    private let cardWidthInset: CGFloat = 32
    private let cardHeight: CGFloat = 60
    
    // Holds unsubmitted form data until closure of app
    @StateObject var data = TemporaryData()
    
    // Edit and form button event handlers
    @State private var shouldPresentForm: Bool = false
    @State private var isEditing: Bool = false
    
    var body: some View
    {
        ZStack
        {
            // background
            // Layer 1
            getSineWave(
                width: mainWidth,
                height: mainHeight
            )
                .foregroundColor(Color(UIColor.systemIndigo.withAlphaComponent(0.3)))
            // Layer 2
            getSineWave(
                width: mainWidth,
                height: mainHeight
            )
                .foregroundColor(Color(UIColor.systemIndigo.withAlphaComponent(0.3)))
            // Layer 3
            getSineWave(
                width: mainWidth,
                height: mainHeight
            )
                .foregroundColor(Color(UIColor.systemIndigo.withAlphaComponent(0.3)))
            
            GeometryReader
            { mainView in
                // Lists all queried records in a scrollable view
                ScrollView(showsIndicators: false)
                {
                    VStack(spacing: 15)
                    {
                        ForEach(records, id: \.id)
                        { record in
                            GeometryReader
                            { item in
                                ZStack(alignment: .topLeading)
                                {
                                    // Call the card view for each person in the database
                                    ButtonOverlay(record: record, borderGradient: gradientLayer, mainWidth: mainWidth, mainHeight: mainHeight)
                                    
                                    // If the edit button is toggled, show delete button for each card
                                    if(isEditing)
                                    {
                                        Button(
                                            action:
                                            {
                                                if let index = records.firstIndex(of: record)
                                                {
                                                    deletePerson(offsets: IndexSet(integer: index))
                                                }
                                            },
                                            label:
                                            {
                                                Image(systemName: "minus.circle.fill")
                                                    .resizable()
                                                    .foregroundStyle(.white, .red)
                                                    .shadow(color: .red, radius: 3, x: 0, y: 0)
                                            }
                                        )
                                            .frame(width: 24, height: 24)
                                            .zIndex(1)
                                            .offset(x: -8, y: -8)
                                    }
                                }
                                .scaleEffect( // Falling out of view button animation
                                    scaleValue(
                                        mainMinY: mainView.frame(in: .global).minY,
                                        minY: item.frame(in: .global).minY
                                    ),
                                    anchor: .topTrailing
                                )
                                .opacity( // Fading out of view button animation
                                    Double(
                                        scaleValue(
                                            mainMinY: mainView.frame(in: .global).minY,
                                            minY: item.frame(in: .global).minY
                                        )
                                    )
                                )
                            }
                            .frame(width: mainWidth-cardWidthInset, height: cardHeight)
                            .padding([.bottom, .top], 12)
                        }
                        Spacer()
                    }
                    .padding()
                }
                .navigationBarColor(
                    backgroundColor: UIColor.systemIndigo.withAlphaComponent(0.5),
                    tintColor: UIColor.black,
                    shadowImage: "navBarShadow"
                )
                .navigationTitle(isEditing ? "Editor" : "Home")
                .toolbar
                {
                    ToolbarItem(placement: .navigationBarTrailing)
                    {
                        Button(isEditing ? "Done" : "Edit") // Edit button
                        {
                            isEditing.toggle()
                        }
                            .tint(.purple)
                            .font(Font.body.weight(.semibold))
                    }
                }
            }
            
            // Button to toggle the form view
            VStack
            {
                Spacer()
                HStack
                {
                    Spacer()
                    Button(
                        action:
                        {
                            self.shouldPresentForm.toggle()
                        },
                        label:
                        {
                            Image(systemName: "plus.circle")
                                .resizable()
                                .symbolRenderingMode(.palette)
                                .symbolVariant(.fill)
                                .font(Font.title.weight(.bold))
                                .foregroundStyle(
                                    Color.white,
                                    LinearGradient(stops: [
                                    Gradient.Stop(color: .purple, location: 0.4),
                                    Gradient.Stop(color: .blue, location: 0.9)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing)
                                )
                        }
                    )
                        .frame(width: 44, height: 44)
                        .padding([.bottom, .trailing], 20)
                }
            }
        }
        
        // Presents the form view when shouldPresentForm is true
        .fullScreenCover(isPresented: $shouldPresentForm, content: {
            NavigationView
            {
                FormView(data: data)
                    .navigationTitle("Registration Form")
            }
            .navigationBarColor(
                backgroundColor: UIColor.systemIndigo.withAlphaComponent(0.5),
                tintColor: UIColor.black,
                shadowImage: "navBarShadow"
            )
            Button(
                action:
                {
                    self.shouldPresentForm.toggle()
                },
                label:
                {
                    HStack(spacing: 4)
                    {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 22, weight: .semibold))
                            .foregroundColor(.black)
                        Text("Back")
                            .font(.system(size: 18))
                            .foregroundColor(.black)
                    }
                }
            )
                .padding(.bottom, 20)
        })
        .animation(.easeInOut, value: 1.0)
    }
    
    // Produces a scale value depending on position in frame - fall away animation
    private func scaleValue(mainMinY: CGFloat, minY: CGFloat) -> CGFloat
    {
        withAnimation(Animation.easeOut)
        {
            let minScale = (minY - 8) / mainMinY
            
            if(minScale < 1)
            {
                if(minScale < 0)
                {
                    return 0
                }
                return minScale
            }
            
            return 1
        }
    }

    // Deletes a person from the database
    private func deletePerson(offsets: IndexSet) {
        withAnimation {
            offsets.map { records[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Deletion error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}
