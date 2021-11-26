//
//  ContentView.swift
//  Vaccine Registration
//
//  Created by Jacob Templeton on 11/22/21.
//

import SwiftUI

struct ContentView: View
{
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
    
    @StateObject var data = TemporaryData()
    
    @State var selectedTabIndex = 0
    @State var shouldPresentNewWindow = false
    @State var animationAmount = 1.0
    
    @State private var query: String = ""
    
    let tabBarImages = ["house", "plus.app.fill", "magnifyingglass"]
    
    var body: some View
    {
        VStack(spacing: 0)
        {
            ZStack
            {
                Spacer()
                    .fullScreenCover(isPresented: $shouldPresentNewWindow, content: {
                        NavigationView
                        {
                            FormView(data: data)
                                .navigationTitle("Registration Form")
                        }
                        Button(action: {
                            shouldPresentNewWindow.toggle()
                        }, label: {
                            Text("< Back")
                                .foregroundColor(.blue)
                        })
                            .padding(.bottom, 20)
                    })
                    .animation(.easeInOut, value: animationAmount)
                
                switch selectedTabIndex
                {
                case 0:
                    NavigationView
                    {
                        HomeView(records: records)
                            .navigationTitle("Home")
                    }
                    .searchable(text: $query, placement: .navigationBarDrawer, prompt: "Search for people...")
                
                case 2:
                    NavigationView
                    {
                        QueryView(records: records)
                            .navigationTitle("Records")
                    }
                    .searchable(text: $query, placement: .navigationBarDrawer, prompt: "Search for people...")
                
                default:
                    NavigationView
                    {
                        Text("How did you get here?")
                            .navigationTitle("Unhandled Tab")
                    }
                }
            }
            
            Divider()
                .padding(.bottom, 10)
            
            HStack
            {
                ForEach(0..<tabBarImages.count)
                { index in
                    Button(action: {
                        if index == 1
                        {
                            shouldPresentNewWindow.toggle()
                            return
                        }
                        selectedTabIndex = index
                        
                    }, label: {
                        Spacer()
                        
                        if(index == 1)
                        {
                            Image(systemName: tabBarImages[index])
                                .font(.system(size: 44, weight: .bold))
                                .foregroundGradient(stops: [
                                    Gradient.Stop(color: .purple, location: 0.4),
                                    Gradient.Stop(color: .blue, location: 0.9)])
                        } else
                        {
                            Image(systemName: tabBarImages[index])
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(selectedTabIndex == index ? Color(.black) : .init(white: 0.8))
                        }
                        
                        Spacer()
                    })
                }
            }
        }
        .padding(.bottom, 10)
    }
}

struct RoundedCorner: Shape
{
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    func path(in rect: CGRect) -> Path
    {
        let path = UIBezierPath(roundedRect: rect,
            byRoundingCorners: corners, cornerRadii: CGSize(width:
            radius, height: radius))
        return Path(path.cgPath)
    }
}

extension View
{
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View
    {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
     }
}

extension View
{
    func hideKeyboard()
    {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

extension View
{
    func placeholder<Content: View>
    (
        when shouldShow: Bool,
        alignment: Alignment = .center,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment)
        {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

extension View
{
    public func foregroundGradient(stops: [Gradient.Stop], start: UnitPoint = UnitPoint.topLeading, end: UnitPoint = UnitPoint.bottomTrailing) -> some View
    {
        self.overlay(LinearGradient(gradient: Gradient(stops: stops),
            startPoint: start,
            endPoint: end))
            .mask(self)
    }
}

extension View
{
    public func backgroundGradient(stops: [Gradient.Stop], start: UnitPoint = UnitPoint.topLeading, end: UnitPoint = UnitPoint.bottomTrailing) -> some View
    {
        self.background(LinearGradient(gradient: Gradient(stops: stops),
            startPoint: start,
            endPoint: end))
    }
}

struct ContentView_Previews: PreviewProvider
{
    static var previews: some View
    {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
