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
    
    let records: FetchedResults<Person>
    
    static let customLinearGradients: [aGradient] = [
        aGradient(id: 1, name: "flame", stops: [
            Gradient.Stop(color: .yellow, location: 0.1 ),
            Gradient.Stop(color: .orange, location: 0.4 ),
            Gradient.Stop(color: .red   , location: 0.6 ),
            Gradient.Stop(color: .black , location: 0.8 )]),
        
        aGradient(id: 2, name: "reverseFlame", stops: [
            Gradient.Stop(color: .black , location: 0.2 ),
            Gradient.Stop(color: .red   , location: 0.4 ),
            Gradient.Stop(color: .orange, location: 0.7 ),
            Gradient.Stop(color: .yellow, location: 0.9 )]),
        
        aGradient(id: 3, name: "rainbow", stops: [
            Gradient.Stop(color: .red   , location: 0.1 ),
            Gradient.Stop(color: .orange, location: 0.25),
            Gradient.Stop(color: .yellow, location: 0.4 ),
            Gradient.Stop(color: .green , location: 0.6 ),
            Gradient.Stop(color: .blue  , location: 0.75),
            Gradient.Stop(color: .purple, location: 0.9 )]),
        
        aGradient(id: 4, name: "reverseRainbow", stops: [
            Gradient.Stop(color: .purple, location: 0.1 ),
            Gradient.Stop(color: .blue  , location: 0.25),
            Gradient.Stop(color: .green , location: 0.4 ),
            Gradient.Stop(color: .yellow, location: 0.6 ),
            Gradient.Stop(color: .orange, location: 0.75),
            Gradient.Stop(color: .red   , location: 0.9 )]),
        
        aGradient(id: 5, name: "redBlue", stops: [
            Gradient.Stop(color: .red   , location: 0.1 ),
            Gradient.Stop(color: .purple, location: 0.6 ),
            Gradient.Stop(color: .blue  , location: 1   )]),
        
        aGradient(id: 6, name: "blueRed", stops: [
            Gradient.Stop(color: .blue  , location: 0.1 ),
            Gradient.Stop(color: .purple, location: 0.6 ),
            Gradient.Stop(color: .red   , location: 1   )])
    ]
    
    private let gradientLayer = LinearGradient(
        stops: customLinearGradients[Int.random(in: 0..<customLinearGradients.count)].stops,
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    let cardWidth: CGFloat = 344
    let cardHeight: CGFloat = 60
    
    @StateObject var data = TemporaryData()
    
    @State private var shouldPresentForm = false
    @State private var isEditing = false
    
    var body: some View
    {
        ZStack
        {
            // background
            // Layer 1
            getSineWave(
                width: UIScreen.main.bounds.width,
                height: UIScreen.main.bounds.height
            )
                .foregroundColor(Color(UIColor.systemIndigo.withAlphaComponent(0.3)))
            // Layer 2
            getSineWave(
                width: UIScreen.main.bounds.width,
                height: UIScreen.main.bounds.height
            )
                .foregroundColor(Color(UIColor.systemIndigo.withAlphaComponent(0.3)))
            // Layer 3
            getSineWave(
                width: UIScreen.main.bounds.width,
                height: UIScreen.main.bounds.height
            )
                .foregroundColor(Color(UIColor.systemIndigo.withAlphaComponent(0.3)))
            
            GeometryReader
            { mainView in
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
                                    ButtonOverlay(record: record, borderGradient: gradientLayer)
                                    
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
                                                    .frame(width: 20, height: 20)
                                                    .foregroundStyle(.white, .red)
                                                    .shadow(color: .red, radius: 3, x: 0, y: 0)
                                            }
                                        )
                                            .zIndex(1)
                                            .offset(x: -6, y: -6)
                                    }
                                }
                                .scaleEffect(
                                    scaleValue(
                                        mainMinY: mainView.frame(in: .global).minY,
                                        minY: item.frame(in: .global).minY
                                    ),
                                    anchor: .topTrailing
                                )
                                .opacity(
                                    Double(
                                        scaleValue(
                                            mainMinY: mainView.frame(in: .global).minY,
                                            minY: item.frame(in: .global).minY
                                        )
                                    )
                                )
                            }
                            .frame(width: cardWidth, height: cardHeight)
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
                        Button(isEditing ? "Done" : "Edit")
                        {
                            isEditing.toggle()
                        }
                            .tint(.purple)
                            .font(Font.body.weight(.semibold))
                    }
                }
            }
            
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
                                .symbolRenderingMode(.palette)
                                .symbolVariant(.fill)
                                .font(.system(size: 44, weight: .bold))
                                .foregroundStyle(
                                    Color.white,
                                    LinearGradient(stops: [
                                    Gradient.Stop(color: .purple, location: 0.4),
                                    Gradient.Stop(color: .blue, location: 0.9)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing)
                                )
                                .frame(width: 24, height: 24)
                        }
                    )
                        .padding([.bottom, .trailing], 30)
                }
            }
        }
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

    private func deletePerson(offsets: IndexSet) {
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
