//
//  ExportView.swift
//  VaccineRegistration
//
//  Created by Jacob Templeton on 11/30/21.
//

import SwiftUI
import UniformTypeIdentifiers

struct ExportView: View
{
    private let record: Person
    
    private let message: String
    
    // Initialize record and message, must be done this way or errors will be
    // thrown that record was not initialized before assigning its elements to
    // message constant
    init(initRecord: Person)
    {
        self.record = initRecord;
        
        self.message = "id,name,birthday,dateOfVaccine,gender,typeOfVaccine" +
        "\n" +
        "\"\(initRecord.id)\"," +
        "\"\(initRecord.name)\"," +
        "\"\(initRecord.birthday.getFormattedDate(format: "EEEE, MMM d, yyyy"))\"," +
        "\"\(initRecord.dateOfVaccine.getFormattedDate(format: "EEEE, MMM d, yyyy"))\"," +
        "\"\(initRecord.gender)\"," +
        "\"\(initRecord.typeOfVaccine)\"";
    }
    
    @State private var scale: CGFloat = 0
    @State private var isExporting = false
    
    var body: some View
    {
        VStack(alignment: .leading, spacing: 15)
        {
            HStack(spacing: 12)
            {
                // Export as file button
                Button(
                    action:
                    {
                        isExporting = true;
                    },
                    label:
                    {
                        Image(systemName: "square.and.arrow.up")
                            .font(.system(size: 20))
                            .frame(width: 38, height: 32)
                            .symbolVariant(.fill)
                        Text("Export as CSV file")
                            .font(.system(size: 24, weight: .semibold))
                    }
                )
                    .foregroundColor(.black)
                    .fileExporter(isPresented: $isExporting, document: CSVFile(initialText: message), contentType: UTType.commaSeparatedText)
                    { result in
                    }
            }
            
            HStack(spacing: 12)
            {
                // Save CSV to clipboard button
                Button(
                    action:
                    {
                    UIPasteboard.general.setValue(message, forPasteboardType: "public.plain-text") // Copy to clipboard
                    },
                    label:
                    {
                        Image(systemName: "doc.on.doc")
                            .font(.system(size: 18))
                            .frame(width: 38, height: 32)
                            .symbolVariant(.fill)
                        Text("Copy to Clipboard")
                            .font(.system(size: 24, weight: .semibold))
                    }
                )
                    .foregroundColor(.black)
            }
        }
        .padding(EdgeInsets(top: 12, leading: 8, bottom: 12, trailing: 18))
        .background(.thickMaterial)
        .cornerRadius(12)
        .scaleEffect(scale)
        .onAppear
        {
            withAnimation(Animation.easeOut.delay(0.16))
            {
                scale = 1
            }
        }
    }
}

// CSVFile read & write
struct CSVFile: FileDocument {
    static var readableContentTypes = [UTType.commaSeparatedText]
    static var writableContentTypes = [UTType.commaSeparatedText]

    var text = ""

    init(initialText: String = "") {
        text = initialText
    }

    // This initializer loads data that has been saved previously
    init(configuration: ReadConfiguration) throws {
        if let data = configuration.file.regularFileContents {
            text = String(decoding: data, as: UTF8.self)
        }
    }

    // This will be called when the system wants to write our data to disk
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let data = Data(text.utf8)
        return FileWrapper(regularFileWithContents: data)
    }
}
