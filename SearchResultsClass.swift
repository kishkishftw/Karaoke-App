//
//  SearchResultsClass.swift
//  KaraokeApp
//
//  Created by Kishore Baskar on 7/25/17.
//  Copyright © 2017 Kishore Baskar. All rights reserved.
//

import Foundation

class SearchResultsClass
{
    var name : String
    var time : String
    var thumbnailLink: String
    var urlId: String
    
    init(name : String, time : String, thumbnailLink : String, urlId : String)
    {
        self.name = name
        self.time = time
        self.thumbnailLink = thumbnailLink
        self.urlId = urlId
    }
}
