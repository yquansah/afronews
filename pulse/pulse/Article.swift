//
//  Article.swift
//  pulse
//
//  Created by Adnan Abdulai on 7/14/19.
//  Copyright © 2019 bdt. All rights reserved.
//

import UIKit

class Article: Codable { // Using codable also means no need to init stored properties.

    //newsAPI deliverables
    var author: String?
    var title: String = ""
    var description: String = ""
    var url: String = ""
    var imageURL: String = ""
    var publishedAt: String = ""
    var content: String = ""

    //Pulse metadata
    var articleID: UUID?
    var country: String?
    var timefetched: String?
    var category: String?
  //  var arFilter: Filter?
}
