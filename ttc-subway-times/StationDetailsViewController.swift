//
//  StationDetailsViewController.swift
//  ttc-subway-times
//
//  Created by Alfred Choi on 2017-04-24.
//  Copyright © 2017 Alfred Choi. All rights reserved.
//

import UIKit
import SwiftyJSON

class TrainTimeInfo {
    var direction: String = ""
    var line: String = ""
    var description: String = ""
    var id: Int64 = 0
    var systemMessageType: String = ""
    var timeAsFloat: Float = 0
    var trainId: Int = 0
    var trainMessage: String = ""
    var createdDate: String = ""
    var stationId: String = ""
    var timeAsString: String = ""
    
    init(json: JSON){
        self.direction = json["trainDirection"].stringValue
        self.line = json["subwayLine"].stringValue
        self.description = _parseDescription(description: json["stationDirectionText"].stringValue)
        self.id = json["id"].int64Value
        self.systemMessageType = json["systemMessageType"].stringValue
        self.timeAsFloat = json["timeInt"].floatValue
        self.trainId = json["trainId"].intValue
        self.trainMessage = json["trainMessage"].stringValue
        self.createdDate = json["createDate"].stringValue
        self.stationId = json["stationId"].stringValue
        self.timeAsString = json["timeString"].stringValue
    }
    
    private func _parseDescription(description: String) -> String{
        return description.replacingOccurrences(of: "<br/>", with: "")
    }
}

struct TrainInfo{
    var directionCode: String
    var directionDescription: String
    var lineCode: String
    var times: [TrainTimeInfo]
    
    init(direction: [JSON], timesData: [JSON]){
        times = [TrainTimeInfo]()
        directionCode = direction[0].stringValue
        lineCode = direction[2].stringValue
        directionDescription = ""
        directionDescription = _parseDescription(description: direction[1].stringValue)
        
        for timeData in timesData{
            let timeObj = TrainTimeInfo (json:timeData)
            if timeObj.stationId != directionCode {
                continue
            }
            
            times.append(timeObj)
        }
    }
    
    private func _parseDescription(description: String) -> String{
        return description
            .replacingOccurrences(of: "<br/>", with: "")
            .replacingOccurrences(of: "</br>", with: "")
    }
}

class StationDetailsViewController: UIViewController {
    
    @IBOutlet weak var stackView: UIStackView!
    
    var trainTimes = [TrainInfo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchData()
        NotificationCenter.default.addObserver(self, selector: #selector(fetchData), name: .UIApplicationDidBecomeActive, object: nil)
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
    
    // MARK: private functions
    
    func fetchData() {
        let now = NSDate().timeIntervalSince1970
        let url = "https://www.ttc.ca/mobile/loadNtas.action"
        let queryString = [
            "_": String(now),
            "searchCriteria": self.title ?? ""
        ]
        
        self.stackView.subviews.forEach({ $0.removeFromSuperview() })
        self.trainTimes.removeAll()
        
        
        HttpService.getRequest(url: url, queryString: queryString) {
            json, resposne, error in
            guard let jsonData = json else {
                return
            }
            
            for direction in jsonData["defaultDirection"].arrayValue {
                self.trainTimes.append(TrainInfo(direction: direction.arrayValue, timesData: jsonData["ntasData"].arrayValue))
            }
            
            self._setupView()
        }
    }
    
    private func _setupView(){
        DispatchQueue.main.async {
            for info in self.trainTimes {
                self._insertHeading(heading: info.directionDescription)
                self._insertSpacer(size: 5)
                self._insertTimes(trainInfoList: info.times)
                self._insertSpacer()
            }
        }
    }
    
    private func _insertSpacer(size: CGFloat = 20.0){
        let spacer = UIView()
        self.stackView.addArrangedSubview(spacer)
        spacer.heightAnchor.constraint(equalToConstant: size).isActive = true
    }
    
    private func _insertHeading(heading: String){
        let headingLabel = UILabel()
        self.stackView.addArrangedSubview(headingLabel)
        headingLabel.leadingAnchor.constraint(equalTo: self.stackView.leadingAnchor).isActive = true
        headingLabel.trailingAnchor.constraint(equalTo: self.stackView.trailingAnchor).isActive = true
        headingLabel.text  = heading
        headingLabel.font = UIFont(descriptor: headingLabel.font.fontDescriptor, size: 20)
    }
    
    private func _insertTimes(trainInfoList: [TrainTimeInfo]){
        for trainInfo in trainInfoList {
            let trainInfoLabel = UILabel()
            self.stackView.addArrangedSubview(trainInfoLabel)
            trainInfoLabel.leadingAnchor.constraint(equalTo: self.stackView.leadingAnchor).isActive = true
            trainInfoLabel.trailingAnchor.constraint(equalTo: self.stackView.trailingAnchor).isActive = true
            trainInfoLabel.text = self._getTrainArrivalDescription(time: trainInfo.timeAsFloat)
        }
    }
    
    private func _getTrainArrivalDescription(time: Float) -> String{
        let parsedTime = Int(floor(time))
        if (parsedTime == 0){
            return "Arriving now."
        }
        
        return "Arriving in \(parsedTime) minute\(parsedTime == 1 ? "" : "s")"
    }
    
}
