//
//  TrackerViewController.swift
//  pulse
//
//  Created by Adnan Abdulai on 6/7/20.
//  Copyright © 2020 bdt. All rights reserved.
//

import UIKit
import SwiftyJSON

class TrackerViewController: UIViewController {
    
    @IBOutlet weak var globalCasesLabel: UILabel!
    @IBOutlet weak var globalDeathsLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var globalLatest = TrackerLatestModel()
    
    var countryStats = [TrackerCountryModel]() {
        didSet {
            DispatchQueue.main.async {
                self.indicateActivity.stopAnimating()
                self.tableView.reloadData()
                self.globalCasesLabel.text = "Confirmed Cases: \(String(self.globalLatest.confirmed.withCommas()))"
                self.globalDeathsLabel.text = "Deaths: \(String(self.globalLatest.deaths.withCommas()))"
            }
        }
    }
    
    private lazy var indicateActivity: UIActivityIndicatorView = {
        // Activity indicator to show user that there is searching going on
        
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.center = self.view.center
        indicator.hidesWhenStopped = true
        
        return indicator
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(indicateActivity)
        fetchStats()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: - API calls
    
    let apiURL: String = "https://coronavirus-tracker-api.herokuapp.com/v2/"
    
    func fetchStats() {
        let urlString = "\(apiURL)locations"
        indicateActivity.startAnimating()
        performRequest(urlString: urlString)
    }
    
    //url, url session, task, resume , parsejson
    
    func performRequest(urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) {[weak self] (data, _, error) in
                if error != nil {
                    //Do something
                    // print(error)
                }
                
                let validData = JSON(data as Any)
                self?.parse(json: validData)
                
            }
            task.resume()
        }
    }
    
    func parse(json: JSON) {
        var countryStats = [TrackerCountryModel]()
        //Yes, the below should probably be encapsulated in methods. :)
        globalLatest.confirmed = json["latest"]["confirmed"].intValue
        globalLatest.deaths = json["latest"]["deaths"].intValue
        
        for result in json["locations"].arrayValue {
            var countryStat = TrackerCountryModel()
            countryStat.country = result["country"].stringValue
            countryStat.confirmed = result["latest"]["confirmed"].intValue
            countryStat.deaths = result["latest"]["deaths"].intValue
            countryStat.population = result["country_population"].intValue
            
            countryStats.append(countryStat)
        }
        self.countryStats = countryStats
    }
    
}

extension TrackerViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countryStats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "countryCell", for: indexPath)
        cell.textLabel?.text = countryStats[indexPath.row].country
        cell.detailTextLabel?.text = "Cases: \(countryStats[indexPath.row].confirmed.withCommas()), Deaths: \(countryStats[indexPath.row].deaths.withCommas())"
        return cell
    }
    
}

extension Int {
    func withCommas() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value: self))!
    }
}
