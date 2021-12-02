//
//  Persistence.swift
//  Vaccine Registration
//
//  Created by Jacob Templeton on 11/22/21.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for _ in 0..<10
        {
            let newPerson = Person(context: viewContext)
            newPerson.name = "Sample Name"
            newPerson.birthday = Date()
            newPerson.dateOfVaccine = Date()
            newPerson.gender = "Unknown Gender"
            newPerson.typeOfVaccine = "Sample Vaccine"
        }
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved persistence preview error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false)
    {
        container = NSPersistentContainer(name: "VaccineRegistration")
        if inMemory
        {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError?
            {
                /*
                Typical reasons for an error here include:
                * The parent directory does not exist, cannot be created, or disallows writing.
                * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                * The device is out of space.
                * The store could not be migrated to the current model version.
                Check the error message to determine what the actual problem was.
                */
                fatalError("Unresolved persistence memory error \(error), \(error.userInfo)")
            }
        })
    }
}
