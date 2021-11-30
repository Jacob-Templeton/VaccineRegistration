//
//  PersonView.swift
//  VaccineRegistration
//
//  Created by Jacob Templeton on 11/29/21.
//

import SwiftUI

struct ColorScheme
{
    let background: UIColor
    let foreground: UIColor
}

struct PersonView: View
{
    // MARK: - Constant Presets
    static let colorSchemes: [ColorScheme] = [
        ColorScheme(background: UIColor.systemIndigo, foreground: UIColor.black),
        ColorScheme(background: UIColor.systemTeal  , foreground: UIColor.black),
        ColorScheme(background: UIColor.systemCyan  , foreground: UIColor.black),
        ColorScheme(background: UIColor.systemOrange, foreground: UIColor.black),
        ColorScheme(background: UIColor.systemRed   , foreground: UIColor.black),
        ColorScheme(background: UIColor.systemBlue  , foreground: UIColor.black),
        ColorScheme(background: UIColor.systemPink  , foreground: UIColor.black),
        ColorScheme(background: UIColor.systemPurple, foreground: UIColor.black),
        ColorScheme(background: UIColor.systemYellow, foreground: UIColor.black)
    ]
    
    private let scheme: ColorScheme = colorSchemes[Int.random(in: 0..<colorSchemes.count)]
    private let cornerRadius: CGFloat =  12
    private let corners: UIRectCorner = .allCorners
    
    // MARK: - Initilized Constants
    let record: Person
    
    private let mainWidth: CGFloat
    private let mainHeight: CGFloat
    
    private let wave1: Path
    private let wave2: Path
    private let wave3: Path
    
    init(initRecord: Person)
    {
        record = initRecord
        
        mainWidth = UIScreen.main.bounds.width-36
        mainHeight = UIScreen.main.bounds.height-168
        
        wave1 = getSineWave(
            width:  mainWidth,
            height: mainHeight
        )
        wave2 = getSineWave(
            width:  mainWidth,
            height: mainHeight
        )
        wave3 = getSineWave(
            width:  mainWidth,
            height: mainHeight
        )
    }
    
    @State private var showExportOptions: Bool = false
    
    var body: some View
    {
        ZStack
        {
            VStack
            {
                ZStack
                {
                    RoundedCorner(radius: cornerRadius, corners: corners)
                        .strokeBorder(Color(scheme.background), lineWidth: 1)
                        .background(
                            RoundedCorner(radius: cornerRadius, corners: corners)
                                .fill(.white)
                                .shadow(
                                    color: Color(scheme.background.withAlphaComponent(0.9)),
                                    radius: 2,
                                    x: 0,
                                    y: 0
                                )
                                .shadow(
                                    color: Color(UIColor.init(red: 0.211, green: 0.211, blue: 0.211, alpha: 0.5)),
                                    radius: 3,
                                    x: 3,
                                    y: 3
                                )
                        )
                        .frame(
                            width:  mainWidth,
                            height: mainHeight
                        )
                    
                    Rectangle()
                        .fill(Color(scheme.background.withAlphaComponent(0.5)))
                        .frame(
                            width:  mainWidth,
                            height: mainHeight
                        )
                        .overlay(
                            wave1
                                .foregroundColor(Color(scheme.background.withAlphaComponent(0.3)))
                                .clipped()
                        )
                        .overlay(
                            wave2
                                .foregroundColor(Color(scheme.background.withAlphaComponent(0.3)))
                                .clipped()
                        )
                        .overlay(
                            wave3
                                .foregroundColor(Color(scheme.background.withAlphaComponent(0.3)))
                                .clipped()
                        )
                        .cornerRadius(cornerRadius)
                    
                    VStack(alignment: .leading)
                    {
                        Spacer()
                        Group
                        {
                            Text("**ID:** \(record.id)")
                                .padding()
                            Text("**Name:** \(record.name)")
                                .padding()
                            Text("**Birthdate:** \(record.birthday, format: .dateTime.day().month().year())")
                                .padding()
                        }
                        Group
                        {
                            Text("**Vaccination Date:** \(record.dateOfVaccine, format: .dateTime.day().month().year())")
                                .padding()
                            Text("**Gender:** \(record.gender)")
                                .padding()
                            Text("**Vaccination Type:** \(record.typeOfVaccine)")
                                .padding()
                        }
                        Spacer()
                    }
                    .foregroundColor(Color(scheme.foreground))
                    .padding(20)
                }
                .padding()
            }
            .blur(radius: showExportOptions ? 20 : 0)
            
            Spacer()
            
            VStack
            {
                Spacer() // Push content to bottom side
                HStack
                {
                    Spacer() // Push content to right side
                    Button(
                        action:
                        {
                            withAnimation
                            {
                                self.showExportOptions.toggle()
                            }
                        },
                        label:
                        {
                            Image(systemName: "square.and.arrow.up.circle.fill")
                                .font(.system(size: 54, weight: .bold))
                                .symbolRenderingMode(.palette)
                                .foregroundStyle(.white, Color(scheme.foreground), Color(scheme.foreground))
                                .shadow(color: Color(UIColor.black.withAlphaComponent(0.7)), radius: 2, x: 2, y: 2)
                                .frame(width: 29.5, height: 29.5)
                        }
                    )
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 20))
                }
            }
            
            if(showExportOptions)
            {
                GeometryReader
                { _ in
                    VStack
                    {
                        Spacer()
                        HStack
                        {
                            Spacer()
                            ExportView(initRecord: record)
                            Spacer()
                        }
                        Spacer()
                    }
                }
                .background(
                    Color(UIColor.black.withAlphaComponent(0.3))
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture
                        {
                            withAnimation(Animation.easeOut)
                            {
                                self.showExportOptions.toggle()
                            }
                        }
                )
            }
        }
        .navigationTitle("\(record.name)")
        .padding(EdgeInsets(top: 20, leading: 10, bottom: 20, trailing: 10))
    }
}
