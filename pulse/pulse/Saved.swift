//
//  Saved.swift
//  pulse
//
//  Created by Adnan Abdulai on 7/14/19.
//  Copyright © 2019 bdt. All rights reserved.
//

import UIKit
import RealmSwift

class Saved: Object {
     let savedArticles = List<SavedArticle>()

}
