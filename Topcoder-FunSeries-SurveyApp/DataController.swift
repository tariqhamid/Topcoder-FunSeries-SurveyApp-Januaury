//
//  DataController.swift
//  Topcoder-FunSeries-SurveyApp
//
//  Created by Burhanuddin Sunelwala on 11/29/15.
//  Copyright © 2015 topcoder. All rights reserved.
//

import Foundation
import CoreData

class DataController: NSObject {
    
    var managedObjectContext: NSManagedObjectContext
    
    override init() {
        
        // This resource is the same name as your xcdatamodeld contained in your project.
        guard let modelURL = NSBundle.mainBundle().URLForResource("Model", withExtension:"momd") else {
            fatalError("Error loading model from bundle")
        }
        
        // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
        guard let mom = NSManagedObjectModel(contentsOfURL: modelURL) else {
            fatalError("Error initializing mom from: \(modelURL)")
        }
        
        let psc = NSPersistentStoreCoordinator(managedObjectModel: mom)
        self.managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        self.managedObjectContext.persistentStoreCoordinator = psc
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) {
            let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
            let docURL = urls[urls.endIndex-1]
            /* The directory the application uses to store the Core Data store file.
            This code uses a file named "DataModel.sqlite" in the application's documents directory.
            */
            let storeURL = docURL.URLByAppendingPathComponent("DataModel.sqlite")
            do {
                try psc.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL, options: nil)
            } catch {
                fatalError("Error migrating store: \(error)")
            }
        }
    }
    
    func save() {
        
        do {
            try self.managedObjectContext.save()
        } catch {
            fatalError("Failure to save context: \(error)")
        }
    }
}