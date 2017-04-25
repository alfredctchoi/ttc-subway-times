//
//  StationListTableViewController.swift
//  ttc-subway-times
//
//  Created by Alfred Choi on 2017-04-24.
//  Copyright © 2017 Alfred Choi. All rights reserved.
//

import UIKit
import SwiftyJSON

class StationListTableViewController: UITableViewController {
    
    var stations = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        let now = NSDate().timeIntervalSince1970
        let url = "https://www.ttc.ca/mobile/loadNtas.action"
        let queryString = [
            "_": String(now),
            "searchCriteria": "Bayview Station"
        ]

        HttpService.getRequest(url: url, queryString: queryString) {
            json, resposne, error in
            
            guard error == nil else {
                print(error!)
                return
            }
            
            guard let json = json else {
                print("Data is empty")
                return
            }
            
            let subwayStations: [String] = json["subwayStations"].arrayValue.map {$0.stringValue}
            self.stations.append(contentsOf: subwayStations)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.stations.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "StationListTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? StationListTableViewCell else {
            fatalError("The dequeued cell is not an instance of \(cellIdentifier).")
        }

        // Configure the cell...
        let station = self.stations[indexPath.row]
        cell.stationName.text = station
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the spescified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        guard let selectedRow = self.tableView.indexPathForSelectedRow else {
            return
        }
        segue.destination.title = self.stations[selectedRow[1]]
    }
}
