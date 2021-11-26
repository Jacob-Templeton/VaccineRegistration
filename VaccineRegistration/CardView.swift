//
//  CardView.swift
//  VaccineRegistration
//
//  Created by Jacob Templeton on 11/26/21.
//

import SwiftUI

struct CardView: View
{
    let data: Person
    var body: some View
    {
        VStack(alignment: .leading)
        {
            Text(data.name)
                .font(.headline)
            Spacer()
            HStack
            {
                Label("\(data.gender)", systemImage: "person.3")
                    .accessibilityElement(children: .ignore)
                    .accessibilityLabel(Text("Gender"))
                    .accessibilityValue(Text("\(data.gender)"))
                Spacer()
                Label("\(data.dateOfVaccine, format: .dateTime.day().month().year())", systemImage: "clock")
                    .padding(.trailing, 20)
                    .accessibilityElement(children: .ignore)
                    .accessibilityLabel(Text("Vaccine Date"))
                    .accessibilityValue(Text("\(data.dateOfVaccine, format: .dateTime.minute()) minutes"))
            }
            .font(.caption)
        }
        .padding()
        .foregroundColor(Color.white)
    }
}
