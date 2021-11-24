//
//  Person+CoreDataProperties.swift
//  Vaccine Registration
//
//  Created by Jacob Templeton on 11/24/21.
//
//

import Foundation
import CoreData


extension Person {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Person> {
        return NSFetchRequest<Person>(entityName: "Person")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var birthday: Date
    @NSManaged public var dateOfVaccine: Date
    @NSManaged public var typeOfVaccine: String
    @NSManaged public var name: String
    @NSManaged public var gender: String
    
    var genderType : Gender {
        set {
            gender = newValue.rawValue
        }
        get {
            Gender(rawValue: gender) ?? .other
        }
    }

}

extension Person : Identifiable {

}

enum Gender: String {
    case male = "Male"
    case female = "Female"
    case other = "Other"
}
