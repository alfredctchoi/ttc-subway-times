//
//  StationDetailsViewController.swift
//  ttc-subway-times
//
//  Created by Alfred Choi on 2017-04-24.
//  Copyright © 2017 Alfred Choi. All rights reserved.
//

import UIKit
import SwiftyJSON

class StationDetailsViewController: UIViewController {
    
    @IBOutlet weak var stackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let now = NSDate().timeIntervalSince1970
        let url = "https://www.ttc.ca/mobile/loadNtas.action"
        let queryString = [
            "_": String(now),
            "searchCriteria": self.title ?? ""
        ]
        
        let eastboundLabel = UILabel()
        stackView.addArrangedSubview(eastboundLabel)
        eastboundLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor).isActive = true
        eastboundLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor).isActive = true
        eastboundLabel.text  = "Eastbound"
        eastboundLabel.textAlignment = .center
        
        let spacer = UIView()
        stackView.addArrangedSubview(spacer)
        spacer.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        let westboundLabel = UILabel()
        stackView.addArrangedSubview(westboundLabel)
        westboundLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor).isActive = true
        westboundLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor).isActive = true
        westboundLabel.text  = "Westbound"
        westboundLabel.textAlignment = .center
        
        HttpService.get(url: url, queryString: queryString) {
            data, resposne, error in
            //            print(data)
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
