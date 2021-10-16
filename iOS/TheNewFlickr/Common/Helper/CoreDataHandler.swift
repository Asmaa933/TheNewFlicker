//
//  CoreDataHandler.swift
//  TheNewFlickr
//
//  Created by Asmaa Tarek on 20/07/2021.
//

import UIKit
import CoreData

class CoreDataHandler {

    static let shared = CoreDataHandler()
    private init() {}

    func getCoreDataobject() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }

    func saveIntoCoreData(searchItem: CachedSearch) {
        let context = getCoreDataobject()
            do {
                try context.save()
            } catch {
                print("error in saving")
            }
    }

    func getDataFromCoreData() -> [CachedSearch]? {
        let context = getCoreDataobject()
        var cachedArray: [CachedSearch]?
        do {
            cachedArray = try context.fetch(CachedSearch.fetchRequest())
        } catch {
            print("error in get data")
        }
        return cachedArray
    }

    func clearCoreData() {
        let context = getCoreDataobject()
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "CachedSearch")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print("Error Clear Core Data")
        }
    }

    func deleteObjectFromCoreData (item: CachedSearch) -> [CachedSearch]? {
        let context = getCoreDataobject()
        context.delete(item)
        do {
            try context.save()
        } catch {
            print("error in delete data")
        }
        return getDataFromCoreData()
    }
}
