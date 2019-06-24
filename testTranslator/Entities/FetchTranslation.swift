//
//  FetchTranslation.swift
//  testTranslator
//
//  Created by Ivan Dyachenko on 24/06/2019.
//  Copyright © 2019 Ivan Dyachenko. All rights reserved.
//

import CoreData

class FetchTranslation
{
    class func create (_ text: String, language: String, context: NSManagedObjectContext) -> Translation
    {
        
        let t = text.trimmingCharacters(in: .whitespaces)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Translation")
        let predicate = NSPredicate(format: "version=%@", t)
        fetchRequest.predicate = predicate
        
        let fetchResults = try? context.fetch(fetchRequest) as! [Translation]
        
        if fetchResults!.count == 0
        {
            let newTranslation = NSEntityDescription.insertNewObject(forEntityName: "Translation", into: context) as! Translation
            newTranslation.lang = language
            newTranslation.version = t
            
            return newTranslation
        }
        else
        {
            let newTranslation = fetchResults!.first!
            return newTranslation
        }
    }
    
}
