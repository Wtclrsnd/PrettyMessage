//
//  CoreDataManager.swift
//  PrettyMessage
//
//  Created by Emil Shpeklord on 28.04.2020.
//  Copyright © 2020 Бизнес в стиле .RU. All rights reserved.
//

import CoreData
import Foundation

class CoreDataManager {
    
static let instance = CoreDataManager()

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "PrettyMessage")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

