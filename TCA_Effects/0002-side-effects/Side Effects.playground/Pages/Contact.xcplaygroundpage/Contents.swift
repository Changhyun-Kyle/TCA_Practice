//: [Previous](@previous)

import Foundation

struct Contact {
    let id = UUID().uuidString
    let name: String
    let phoneNumber: Int
    let age: Int
    
    init(name: String, phoneNumber: Int, age: Int) {
        self.name = name
        self.phoneNumber = phoneNumber
        self.age = age
    }
}

struct ContactManager {
    
    private var contacts = [Contact]()
    
    mutating func addContact(contact: Contact) {
        contacts.append(contact)
    }
    
    mutating func deleteContact(contact: Contact) {
        contacts.removeAll(where: { $0.id == contact.id } )
    }
    
    mutating func editContact(contact: Contact) {
        let contactIndices = contacts.indices
        let targetContact = contactIndices.filter { contacts[$0].id == contact.id }
        targetContact.forEach { contacts[$0] = contact }
    }
}

