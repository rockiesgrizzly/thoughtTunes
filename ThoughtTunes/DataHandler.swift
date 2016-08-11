//
//  DataHandler.swift
//  ThoughtTunes
//
//  Created by Josh MacDonald on 8/5/16.
//  Copyright © 2016 floydhillcode. All rights reserved.
//
import UIKit
import CoreData

class DataHandler {
    var localNotifier = NSNotificationCenter.defaultCenter()
    
    internal var tagDataList: [Tag]? {
        didSet {
            localNotifier.postNotificationName(Notifications.tagDataListSet, object: self)
        }
    }
    
    internal var categoryDataList: [Category]? {
        didSet {
            localNotifier.postNotificationName(Notifications.categoryDataListSet, object: self)
        }
    }
    
    internal var tuneDataList: [Category]? {
        didSet {
            localNotifier.postNotificationName(Notifications.tuneDataListSet, object: self)
        }
    }
    
    lazy var privateMoc: NSManagedObjectContext? = {
        guard let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate else {return nil}
        return appDelegate.managedObjectContext
    }()
    
    lazy var mainMoc: NSManagedObjectContext? = {
        let moc = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        moc.mergePolicy = NSOverwriteMergePolicy
        moc.parentContext = self.privateMoc
        return moc
    }()
    
    
    //MARK: Data Updating
    func updateData(modelType: ModelType, ifCategoryThenTagType: TagType?) {
        let config = NSURLSessionConfiguration.ephemeralSessionConfiguration()
        let session = NSURLSession(configuration: config)
        var urlString: String?
        
        switch modelType {
        case .Tag:
            urlString = URLs.tagURL
        case .Category:
            if let ifCategoryThenTagType = ifCategoryThenTagType {
                switch ifCategoryThenTagType {
                case.Artists:
                    urlString = URLs.categoryURL + CategoryType.Artists.rawValue
                case .Albums:
                    urlString = URLs.categoryURL + CategoryType.Albums.rawValue
                case .Genre:
                    urlString = URLs.categoryURL + CategoryType.Genre.rawValue
                }
            } else {
                NSLog("tag type not included. url needs this to succeed")
            }
        case .Tune:
            urlString = URLs.tuneURL
        }

        
        if let urlString = urlString {
            guard let url = NSURL(string: urlString) else {NSLog("string not converted to url"); return}
            let request = NSURLRequest(URL: url)
            
            let dataTask = session.dataTaskWithRequest(request) {(
                data: NSData?,
                response: NSURLResponse?,
                error: NSError?) in
                
                if error != nil {
                    NSLog("error: \(error!), \(error?.localizedDescription)")
                } else {
                    guard let jsonData = data else {NSLog("no JSON data retrieved"); return}
                    
                    do {
                        guard let jsonArray = try NSJSONSerialization.JSONObjectWithData(jsonData, options: .MutableLeaves) as? [AnyObject] else {return}
                        
                        NSLog("jsonArray: \(jsonArray)")
                        guard let privateMoc = self.privateMoc else {return}
                        
                        privateMoc.performBlock ({
                            switch modelType {
                            case .Tag:
                                //remove existing values from CoreData since we are resetting the list
                                self.clearCoreDataEntity(ModelType.Tag)
                                
                                for element in jsonArray {
                                    guard let id = element["id"] as? String else {return}
                                    guard let title = element["title"] as? String else {return}
                                    
                                    
                                    //add values to CoreData
                                    let tag = NSEntityDescription.insertNewObjectForEntityForName(ModelType.Tag.rawValue, inManagedObjectContext: privateMoc) as! Tag
                                    tag.id = id
                                    tag.title = title
                                }
                            case .Category:
                                self.clearCoreDataEntity(ModelType.Category)
                                
                                for element in jsonArray {
                                    guard let name = element["name"] as? String else {return}
                                    guard let id = element["id"] as? String else {return}
                                    guard let songIDArray = element["song_ids"] as? [Int] else {return}
                                    
                                    let category = NSEntityDescription.insertNewObjectForEntityForName(ModelType.Category.rawValue, inManagedObjectContext: privateMoc) as! Category
                                    category.id = id
                                    category.name = name
                                    //convert to String for CoreData since it doesn't accept arrays
                                    category.song_ids = songIDArray.description
                                }
                                
                                
                                
                            case .Tune:
                                self.clearCoreDataEntity(ModelType.Tune)
                                
                                //                                for element in jsonArray {
                                //                                    guard let cover_url = element["cover_url"] as String else {return}
                                //                                    guard let description = element["description"] as String else {return}
                                //                                    guard let id = element["id"] as Int else {return}
                                //                                    guard let name = element["name"] as String else {return}
                                //                                    guard let type = element["type"] as String else {return}
                                //
                                //                                    //create managed objects (CoreData)
                                //                                    let tune = NSEntityDescription.insertNewObjectForEntityForName(ModelType.Tune, inManagedObjectContext: privateMoc) as! Tune
                                //                                    tune.cover_url = cover_url
                                //                                    tune.description = description
                                //                                    tune.id = id
                                //                                    tune.name = name
                                //                                    tune.type = type
                                //                                }
                            }
                            
                            do {
                                try privateMoc.save()
                                self.mainMoc?.performBlock({
                                    self.fetchData(modelType)
                                })
                            }
                                
                            catch let saveError as NSError {
                                NSLog("error: \(saveError), \(saveError.localizedDescription)")
                            }
                        })
                    }
                        
                    catch let error as NSError {
                        NSLog("error: \(error), \(error.localizedDescription)")
                    }
                }
            }
            dataTask.resume()
        }
    }
    
    func fetchData(modelType: ModelType) {
        guard let moc = mainMoc else {return}
        let fetchRequest = NSFetchRequest()
        
        let entity = NSEntityDescription.entityForName(modelType.rawValue, inManagedObjectContext: moc)
        fetchRequest.entity = entity
        
        switch modelType {
        case .Tag:
            let sortDescriptor = NSSortDescriptor(key: DataType.id, ascending: true)
            fetchRequest.sortDescriptors = [sortDescriptor]
            
            do {
                let results = try moc.executeFetchRequest(fetchRequest) as! [Tag]
                tagDataList = results
            } catch let error as NSError {
                NSLog("error: \(error), \(error.localizedDescription)")
            }
            
        case .Category:
            let sortDescriptor = NSSortDescriptor(key: DataType.name, ascending: true)
            fetchRequest.sortDescriptors = [sortDescriptor]
            
            do {
                let results = try moc.executeFetchRequest(fetchRequest) as! [Category]
                categoryDataList = results
            } catch let error as NSError {
                NSLog("error: \(error), \(error.localizedDescription)")
            }
            
        case .Tune:
            print("placeholder")
        }
    }

    
    func clearCoreDataEntity(name: ModelType) {
        guard let privateMoc = self.privateMoc else {return}
        let entity = NSEntityDescription.entityForName(name.rawValue, inManagedObjectContext: privateMoc)
        let fetchRequest = NSFetchRequest()
        fetchRequest.entity = entity
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try self.mainMoc?.executeRequest(deleteRequest)
        }
        catch let error as NSError {
            NSLog("error: \(error), \(error.localizedDescription)")
        }
    }
    
    
    
    
}
