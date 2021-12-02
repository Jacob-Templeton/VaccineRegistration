//
//  ButtonOverlay.swift
//  VaccineRegistration
//
//  Created by Jacob Templeton on 11/27/21.
//

import SwiftUI

// MARK: - Overlays a button template onto each card view
struct ButtonOverlay: View
{
    // MARK: - Button preview text gradient
    private let purpleGreen: [Gradient.Stop] = [
        Gradient.Stop(color: .purple, location: 0.2 ),
        Gradient.Stop(color: .blue  , location: 0.4 ),
        Gradient.Stop(color: .green , location: 0.6 )
    ]
    
    let cornerRadius: CGFloat = 24
    let corners: UIRectCorner = [.topRight, .bottomLeft]
    
    let record: Person
    let borderGradient: LinearGradient
    let mainWidth: CGFloat
    let mainHeight: CGFloat
    
    // Animation handlers
    @State private var lineWidth: CGFloat = 90
    @State private var scale: CGFloat = 0
    
    var body: some View
    {
        NavigationLink
        {
            // Links button element to its respective PersonView
            PersonView(initRecord: record, initWidth: mainWidth, initHeight: mainHeight)
        }
        label:
        {
            ZStack
            {
                // Calls card view with button style formatting
                CardView(data: record)
                    .foregroundGradient(stops: purpleGreen)
                .overlay(
                    RoundedCorner(radius: cornerRadius, corners: corners)
                        .strokeBorder(borderGradient,
                            lineWidth: lineWidth
                        )
                        .shadow(color: .secondary, radius: 3, x: 0, y: 0)
                        .onAppear
                        {
                            withAnimation(Animation.interpolatingSpring(stiffness: 60, damping: 15).delay(0.1))
                            {
                                // Trigger lineWidth animation
                                lineWidth = 2
                            }
                        }
                )
                .background(
                    RoundedCorner(radius: cornerRadius, corners: corners)
                        .fill(Color(UIColor.black.withAlphaComponent(0.8)))
                )
                .shadow(color: Color(UIColor.black.withAlphaComponent(0.7)), radius: 4, x: 16, y: 20)
                .scaleEffect(scale)
                .onAppear
                {
                    // Trigger scale animation
                    withAnimation(Animation.interpolatingSpring(stiffness: 60, damping: 10).delay(0.16))
                    {
                        scale = 1
                    }
                }
            }
        }
    }
}
