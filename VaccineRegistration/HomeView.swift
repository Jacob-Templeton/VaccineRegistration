//
//  HomeView.swift
//  VaccineRegistration
//
//  Created by Jacob Templeton on 11/26/21.
//

import SwiftUI

struct aGradient: Identifiable
{
    var id: Int
    var name: String
    var stops: [Gradient.Stop]
}

struct HomeView: View
{
    @Environment(\.managedObjectContext) private var viewContext
    
    let records: FetchedResults<Person>
    
    // MARK: - Color Presets
    private let purpleGreen = [Gradient.Stop(color: .purple, location: 0.2), Gradient.Stop(color: .blue, location: 0.4), Gradient.Stop(color: .green, location: 0.6)]
    
    let gradients: [aGradient] = [
            aGradient(id: 1, name: "flame", stops: [
                Gradient.Stop(color: .yellow, location: 0.1),
                Gradient.Stop(color: .orange, location: 0.4),
                Gradient.Stop(color: .red, location: 0.6),
                Gradient.Stop(color: .black, location: 0.8)]),
            
            aGradient(id: 2, name: "reverseFlame", stops: [
                Gradient.Stop(color: .black, location: 0.2),
                Gradient.Stop(color: .red, location: 0.4),
                Gradient.Stop(color: .orange, location: 0.7),
                Gradient.Stop(color: .yellow, location: 0.9)]),
            
            aGradient(id: 3, name: "rainbow", stops: [
                Gradient.Stop(color: .red, location: 0.1),
                Gradient.Stop(color: .orange, location: 0.25),
                Gradient.Stop(color: .yellow, location: 0.4),
                Gradient.Stop(color: .green, location: 0.6),
                Gradient.Stop(color: .blue, location: 0.75),
                Gradient.Stop(color: .purple, location: 0.9)]),
            
            aGradient(id: 4, name: "reverseRainbow", stops: [
                Gradient.Stop(color: .purple, location: 0.1),
                Gradient.Stop(color: .blue, location: 0.25),
                Gradient.Stop(color: .green, location: 0.4),
                Gradient.Stop(color: .yellow, location: 0.6),
                Gradient.Stop(color: .orange, location: 0.75),
                Gradient.Stop(color: .red, location: 0.9)]),
            
            aGradient(id: 5, name: "redBlue", stops: [
                Gradient.Stop(color: .red, location: 0.2),
                Gradient.Stop(color: .purple, location: 0.5),
                Gradient.Stop(color: .blue, location: 0.8)]),
            
            aGradient(id: 6, name: "blueRed", stops: [
                Gradient.Stop(color: .blue, location: 0.2),
                Gradient.Stop(color: .purple, location: 0.5),
                Gradient.Stop(color: .red, location: 0.8)])
        ]
    
    let cardHeight: CGFloat = 174
    let cardWidth: CGFloat = 170
    let imageHeight: CGFloat = 116
    let imageWidth: CGFloat = 170
    let cornerRadius: CGFloat = 12
    let corners: UIRectCorner = [.topRight, .bottomLeft]
    
    var gradient: LinearGradient
    {
        get
        {
            return LinearGradient(stops: gradients[Int.random(in: 0..<gradients.count)].stops, startPoint: .leading, endPoint: .trailing)
        }
    }
    
    @State private var isEditing = false
    
    var body: some View
    {
        ScrollView(showsIndicators: false)
        {
            VStack(spacing: 20)
            {
                ForEach(records, id: \.id)
                { record in
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
                        ZStack(alignment: .topLeading)
                        {
                            CardView(data: record)
                                .foregroundGradient(stops: purpleGreen)
                            .overlay(
                                RoundedCorner(radius: cornerRadius, corners: corners)
                                        .stroke(gradient)
                                        .shadow(color: .secondary, radius: 3, x: 0, y: 0)
                            )
                            .background(RoundedCorner(radius: cornerRadius, corners: corners).fill(Color(UIColor.black)).opacity(0.9))
                            .previewLayout(.fixed(width: 400, height: 60))
                            .shadow(color: Color(.black).opacity(0.9), radius: 6, x: 20, y: 20)
                            
                            if(isEditing)
                            {
                                Button(action: {
                                    if let index = records.firstIndex(of: record) {
                                        deletePerson(offsets: IndexSet(integer: index))
                                    }
                                }, label: {
                                    Image(systemName: "minus.circle.fill")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                        .foregroundStyle(.white, .red)
                                        .shadow(color: .red, radius: 3, x: 0, y: 0)
                                })
                                    .zIndex(1)
                                    .offset(x: -6, y: -6)
                            }
                        }
                    }
                }
                Spacer()
            }
            .padding()
            /*.background(Image("templateBackground").resizable(resizingMode: .tile).ignoresSafeArea())*/
        }
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

extension CGFloat
{
    static func random() -> CGFloat
    {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

extension Color
{
    static var random: Color
    {
        return Color(red: .random(in: 0...1),
                     green: .random(in: 0...1),
                     blue: .random(in: 0...1))
    }
}
