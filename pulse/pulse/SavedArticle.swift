//
//  SavedArticle.swift
//  pulse
//
//  Created by Admin on 3/29/20.
//  Copyright © 2020 bdt. All rights reserved.
//

import Foundation
import RealmSwift

class SavedArticle: Object {

    //newsAPI deliverables
    @objc dynamic var author: String?
    @objc dynamic var title: String = ""
    @objc dynamic var desc: String = ""
    @objc dynamic var url: String = ""
    @objc dynamic var imageURL: String = ""
    @objc dynamic var publishedAt: String = ""
    @objc dynamic var content: String = ""
    var parentContainer = LinkingObjects(fromType: Saved.self, property: "savedArticles")
}
