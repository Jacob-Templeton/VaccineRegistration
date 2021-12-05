//
//  ExportButton.swift
//  VaccineRegistration
//
//  Created by Jacob Templeton on 12/2/21.
//

import SwiftUI

struct ExportButton: View
{
    let data: Person
    let scheme: ColorScheme
    @StateObject var effects: Effects
    
    var body: some View
    {
        VStack
        {
            Spacer()
            HStack
            {
                Spacer()
                // Button to toggle export options on press
                Button(
                    action:
                    {
                        withAnimation
                        {
                            effects.shouldBlurView.toggle()
                        }
                    },
                    label:
                    {
                        Image(systemName: "square.and.arrow.up.circle.fill")
                            .resizable()
                            .font(Font.title.weight(.bold))
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(.white, Color(scheme.foreground), Color(scheme.foreground))
                            .shadow(color: Color(UIColor.black.withAlphaComponent(0.7)), radius: 2, x: 2, y: 2)
                    }
                )
                    .frame(width: 58, height: 58)
                    .offset(x: 10, y: 10)
            }
        }
        .blur(radius: effects.shouldBlurView ? 20 : 0)
        
        // Call ExportView and overlay a dark tint to the background view
        if(effects.shouldBlurView)
        {
            GeometryReader
            { _ in
                VStack
                {
                    Spacer()
                    HStack
                    {
                        Spacer()
                        ExportView(initRecord: data)
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
                            effects.shouldBlurView.toggle()
                        }
                    }
            )
        }

    }
}
