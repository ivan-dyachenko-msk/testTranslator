//
//  FetchText.swift
//  testTranslator
//
//  Created by Ivan Dyachenko on 24/06/2019.
//  Copyright © 2019 Ivan Dyachenko. All rights reserved.
//

import CoreData

class FetchText
{
    class func create (_ word: String, context: NSManagedObjectContext) -> TextEntity
    {
        
        let w = word.trimmingCharacters(in: .whitespaces)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TextEntity")
        let predicate = NSPredicate(format: "id=%@", w)
        fetchRequest.predicate = predicate
        
        let fetchResults = try? context.fetch(fetchRequest) as? [TextEntity]
        
        if fetchResults!.count == 0
        {
            let newText = NSEntityDescription.insertNewObject(forEntityName: "TextEntity", into: context) as! TextEntity
            newText.id = w
            
            return newText
        }
        else
        {
            let newText = fetchResults!.first!
            
            return newText
        }
    }
}
