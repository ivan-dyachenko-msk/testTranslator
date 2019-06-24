//
//  CoreDataManager.swift
//  testTranslator
//
//  Created by Ivan Dyachenko on 24/06/2019.
//  Copyright © 2019 Ivan Dyachenko. All rights reserved.
//

import CoreData

class CoreDataManager: NSObject
{
    static let sharedInstance = CoreDataManager()
    
    private lazy var applicationDocumentsDirectory: NSURL =
    {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count - 1] as NSURL
    }()
    
    private lazy var managedObjectModel: NSManagedObjectModel =
    {
        let modelURL = Bundle.main.url(forResource: "TranslatedTextData", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator =
    {
        objc_sync_enter(self)
        
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("WordTranslationDataBase. ")
        
        let failureReason = "There was an error creating or loading the application's saved data."
        
        do
        {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        }
        catch
        {
            objc_sync_exit(self)
        }
        
        return coordinator
    }()
    
    private lazy var managedObjectContext: NSManagedObjectContext =
    {
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    func getMainContext() -> NSManagedObjectContext
    {
        return managedObjectContext
    }
    
    func save()
    {
        do
        {
            try managedObjectContext.save()
        }
        catch let error
        {
            NSLog(error.localizedDescription)
        }
    }
    
    //MARK: - save data
    func saveWordInDataBase ( text: String, trans: String, language: String)
    {
        let context = getMainContext()
        
        let textEntity = FetchText.create(text, context: context)

        let translation = FetchTranslation.create(trans, language: language, context: context)
        
        textEntity.addToTranslation(translation)
        translation.textEntity = textEntity
        
        save()
    }
    
    //MARK: - load data
    func getAllWordFromDataBase() -> [(String,String)] {
        
        let context = getMainContext()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:"TextEntity")
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let fetchResults = try? context.fetch(fetchRequest) as! [TextEntity]
        
        guard let result = fetchResults else { return [] }
        
        var temp : [(String, String)] = []
        
        for obj in result {
            let translations = obj.translation!.allObjects
            let t = obj.translation!.allObjects
            
            for translation in translations as! [Translation] {
                temp.append((obj.id!, translation.version!))
            }
        }
        
        return temp
    }
    
    func getRecords(with text: String) -> [(String,String)] {
        
        let context = getMainContext()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:"Translation")
        let sortDescriptor = NSSortDescriptor(key: "version", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let fetchResults = try? context.fetch(fetchRequest) as! [Translation]
        
        guard let result = fetchResults else {return []}
        var temp: [(String,String)] = []
        for r in result {
            if r.version! == text {
                return [(r.version!,r.textEntity!.id!)]
            }
            else if r.textEntity!.id! == text {
                temp.append((r.textEntity!.id!,r.version!))
            }
        }
        return temp
    }
    func findTranslationInDataBase ( text: String, langFrom: String, langTo: String) -> String {
        
        let context = getMainContext()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:"Translation")
        let sortDescriptor = NSSortDescriptor(key: "version", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let fetchResults = try? context.fetch(fetchRequest) as! [Translation]
        
        let error = "Сервер не отвечает"
        
        guard let result = fetchResults else { return error }
        
        if langTo == "ru" {
            for obj in result {
                
                if obj.version! == text && obj.lang! == langFrom {
                    return obj.textEntity!.id!
                }
            }
        }
        else
        {
            for obj in result
            {
                if obj.textEntity!.id! == text && obj.lang! == langTo
                {
                    return obj.version!
                }
            }
        }
        return error
    }
    
    //MARK: - delete data
    func removeRecord( word: String, translation: String )
    {
        let context = getMainContext()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:"TextEntity")
        let predicate = NSPredicate(format: "id=%@", word)
        fetchRequest.predicate = predicate
        
        let fetchResults = try? context.fetch(fetchRequest) as! [TextEntity]
        
        guard let results = fetchResults,
            let w = results.first,
            let t = w.translation!.allObjects as? [Translation] else { return }
        
        if t.count == 1
        {
            context.delete(w)
            context.delete(t.first!)
        }
        else
        {
            for obj in t
            {
                if obj.version == translation
                {
                    context.delete(obj)
                }
            }
        }
        
        save()
    }
    
    func removeAllRecords()
    {
        let context = getMainContext()
        let wordFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:"TextEntity")
        
        let textDelRequest = NSBatchDeleteRequest(fetchRequest: wordFetchRequest)
        
        do
        {
            try context.execute(textDelRequest)
        }
        catch
        {
            NSLog(error.localizedDescription)
        }
        
        let translationFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:"Translation")
        
        let translationDelRequest = NSBatchDeleteRequest(fetchRequest: translationFetchRequest)
        
        do
        {
            try context.execute(translationDelRequest)
        }
        catch
        {
            NSLog(error.localizedDescription)
        }
        
        save()
    }
}
