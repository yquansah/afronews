//
//  PulseAnalytics.swift
//  pulse
//
//  Created by Kameni Ngahdeu on 8/21/20.
//  Copyright © 2020 bdt. All rights reserved.
//

import Foundation
import Firebase

enum AnalyticsEvents: String {
    case countryTopic
    case readOnSite
    case savedArticle
}

class PulseAnalytics {
    // Used to store analytics data
    
    // Log which country and topic was selected
    static func logCountryTopic(with name: [String: String]) {
        Analytics.logEvent(AnalyticsEvents.countryTopic.rawValue, parameters: name)
    }
    
    // Log if the user clicked to read the full article
    static func logClickedReadMoreButton() {
        Analytics.logEvent(AnalyticsEvents.readOnSite.rawValue, parameters: nil)
    }
    // Log if user clicked to save an article
    static func logSaveArticle() {
        Analytics.logEvent(AnalyticsEvents.savedArticle.rawValue, parameters: nil)
    }
    
    // Log which article was saved
    
    // Log with articles was open
}
