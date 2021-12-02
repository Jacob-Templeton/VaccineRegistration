//
//  QueryView.swift
//  VaccineRegistration
//
//  Created by Jacob Templeton on 12/1/21.
//

import SwiftUI

struct QueryView: View
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
        ColorScheme(background: UIColor.systemPurple, foreground: UIColor.black)
    ]
    
    private let scheme: ColorScheme = colorSchemes[Int.random(in: 0..<colorSchemes.count)]
    private let cornerRadius: CGFloat =  12
    private let corners: UIRectCorner = [.topRight]
    
    // MARK: - Initilized Constants
    let records: FetchedResults<Person>
    
    private let mainWidth: CGFloat
    private let mainHeight: CGFloat
    
    private let wave1: Path
    private let wave2: Path
    private let wave3: Path
    
    init(initRecords: FetchedResults<Person>)
    {
        records = initRecords
        
        self.mainWidth = UIScreen.main.bounds.width-64
        self.mainHeight = UIScreen.main.bounds.height-160
        
        self.wave1 = getSineWave(
            width:  mainWidth,
            height: mainHeight
        )
        self.wave2 = getSineWave(
            width:  mainWidth,
            height: mainHeight
        )
        self.wave3 = getSineWave(
            width:  mainWidth,
            height: mainHeight
        )
    }
    
    @State public var offsetScalarX: CGFloat = -UIScreen.main.bounds.width-64
    @State private var query: String = ""
    
    var body: some View
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
                
                RoundedCorner(radius: cornerRadius, corners: corners)
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
            
                }
                .foregroundColor(Color(scheme.foreground))
        }
        .offset(x: offsetScalarX)
        .onAppear
        {
            withAnimation(Animation.interpolatingSpring(stiffness: 60, damping: 20).delay(0.16))
            {
                offsetScalarX = 0
            }
        }
        
        GeometryReader
        { _ in
            VStack
            {
                Spacer()
                HStack
                {
                    QueryView(initRecords: records)
                    Spacer()
                }
            }
        }
        .background(
            Color(UIColor.black.withAlphaComponent(0.5))
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture
                {
                    withAnimation(Animation.easeOut.delay(0.2))
                    {
                        offsetScalarX = 0
                    }
                    withAnimation(Animation.easeOut)
                    {
                        Menu.showQueryView.toggle()
                    }
                }
        )
    }
}
