//
//  Enums & Strings.swift
//  ThoughtTunes
//
//  Created by Josh MacDonald on 8/8/16.
//  Copyright © 2016 floydhillcode. All rights reserved.
//

//MARK: Structs
struct DataType {
    static let cover_url = "cover_url"
    static let description = "description"
    static let id = "id"
    static let name = "name"
    static let song_ids = "song_ids"
    static let title = "title"
    static let type = "type"
}

struct Notifications {
    static let tagDataListSet = "tagDataListSet"
    static let categoryDataListSet = "categoryDataListSet"
    static let tuneDataListSet = "tuneDataListSet"
}

struct VCNames {
    static let tagViewController = "TagViewController"
    static let categoryViewController = "CategoryViewController"
    static let tuneViewController = "TuneViewController"
}

struct VCCellNames {
    static let categoryCell = "categoryCell"
    static let tagCell = "tagCell"
    static let tuneCell = "tuneCell"
}

struct URLs {
    static let baseURL = "http://www.joshmac.com/api/1"
    static let tagURL = baseURL + "/tags"
    static let categoryURL = baseURL + "/category/tag/"
    static let tuneURL = baseURL + "/api/1/songs/multi/parse"
}


//MARK: Enums
enum CategoryType: String {
    case Artists = "001"
    case Albums = "002"
    case Genre = "003"
}

enum ModelType: String {
    case Tag = "Tag"
    case Category = "Category"
    case Tune = "Tune"
}

enum TagType: String {
    case Artists = "Artists"
    case Albums = "Albums"
    case Genre = "Genre"
}




