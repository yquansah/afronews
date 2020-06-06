//
//  PulseProtocols.swift
//  pulse
//
//  Created by Kameni Ngahdeu on 6/2/20.
//  Copyright © 2020 bdt. All rights reserved.
//

import Foundation

protocol DonePressed: class {
    func dataFromFilter(topics: String, countries: String)
}

protocol FirstTimeUseCase: class {
    func dismissWelcomeView(sender: WelcomeViewController)
    func dismissFilterView(sender: FilterViewController)
}

protocol ReadyToDismiss: class {
    func removeDim()
    func displayWebView(with url: String)
}
