//
//  Category+CoreDataProperties.swift
//  ThoughtTunes
//
//  Created by Josh MacDonald on 8/10/16.
//  Copyright © 2016 floydhillcode. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Category {
    @NSManaged var id: String?
    @NSManaged var name: String?
    @NSManaged var song_ids: String?
}
