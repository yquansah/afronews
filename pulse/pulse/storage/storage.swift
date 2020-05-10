//
//  storage.swift
//  pulse
//
//  Created by Yoofi  on 5/9/20.
//  Copyright © 2020 bdt. All rights reserved.
//

import Foundation
import RealmSwift

class Storage {
    static private let realmStorage: Realm = try! Realm()
    
    static func saveArticle(article: SavedArticle) {
        do {
            try realmStorage.write {
                realmStorage.add(article)
            }
        } catch {
            print("Unable to write to realm db, \(error)")
        }
    }

    static func loadArticles() -> Results<SavedArticle> {
        return realmStorage.objects(SavedArticle.self)
    }
    
    static func deleteArticle(article: SavedArticle) {
        do {
          try realmStorage.write {
            realmStorage.delete(article)
            }
        }
        catch {
            print("Error deleting article, \(error)")
        }
    }
}
