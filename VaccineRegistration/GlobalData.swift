//
//  GlobalData.swift
//  VaccineRegistration
//
//  Created by Jacob Templeton on 12/2/21.
//

import SwiftUI

// Holds data that is shared between classes
// Only used to share between PersonView and ExportButton at the moment
class Effects: ObservableObject
{
    @Published var shouldBlurView: Bool = false
}
