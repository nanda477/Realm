//
//  ViewController.swift
//  RDB
//
//  Created by subramanyam on 18/12/18.
//  Copyright © 2018 mahiti. All rights reserved.
//

import UIKit
import RealmSwift
import Alamofire


class ViewController: UITableViewController {

    var items = List<String>()
    var realmData: CollectionData!
    var notificationToken: NotificationToken?
    var realm: Realm!
    override func viewDidLoad() {
        super.viewDidLoad()
        // items.append(Task(value: ["text": "My First Task"]))
        setupRealm()
        
        setupUI()
    }
    
    func setupUI() {
        title = "My Tasks"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        navigationItem.leftBarButtonItem = editButtonItem
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(add))
    }
    
    func setupRealm() {

    }
    
    deinit {
        notificationToken?.invalidate()
    }
    
    // MARK: UITableView
    
    override func tableView(_ tableView: UITableView?, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let item = items[indexPath.row]
        //cell.textLabel?.text = item.text
        //cell.textLabel?.alpha = item.completed ? 0.5 : 1
        return cell
    }

    
    // MARK: Functions
    
    @objc func add() {
        

//
//        let realm = try! Realm()
//        try! realm.write {
//            realm.create(RealmData.self)
//        }
        
      loadRealm()
    }
    
    func loadRealm() {
        
        let para = ["userid":"879","start":"0","limit":"200"] as [String: AnyObject]
        postCall(urlStr: "Members", parameterP: para) { (dict) in
            print("Success")
            print(dict)
        }
    }
    
    
    func postCall(urlStr:String,parameterP:[String:AnyObject],completion: @escaping (_ result: NSDictionary) -> Void)
    {
      
        let url = "http://ypo_live.mahiti.org/api/"
        let urlString =  NSString(format:"%@%@",url,urlStr) as String!
        print(urlString!)
        print("\(parameterP)")
        
        let headers =   [
            "Content-Type": "application/x-www-form-urlencoded",
            "un":"WYPO",
            "pw":"VD0+)&lrYlUiUcl^8%a~"
        ]
        
        Alamofire.request(urlString!, method: .post, parameters: parameterP,encoding: URLEncoding.default,headers:headers)
            
            .validate
            { request, response, data in
                
               // let newUserFromJSON = parseAndCreateUserFromJSON(data)
                //let json = try? JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary ?? [:]

//                guard let collectionData = try? JSONDecoder().decode(RealmData.self, from: data!) else {
//                    print("Error: Couldn't decode data into Blog")
//                    return .success
//                }
//                print(self.realmData.url)
//
//                let realm = try! Realm()
//                try! realm.write {
//
//                    realm.add(Person.self, update: false)
//
//                }
                
                return .success
            }
            
            .responseJSON { response in
                
                if response.response?.statusCode == 200
                {
                    if response.result.value != nil
                    {
                        if let JSON = response.result.value
                        {
                             let result = JSON as? NSDictionary ?? [:]
                            
                            let jsonData2: Data? = try? JSONSerialization.data(withJSONObject: result, options: .prettyPrinted)
                            var jsonString: String? = nil
                            jsonString = String(data: jsonData2!, encoding: .utf8)
                            
                            let data = jsonString?.data(using: .utf8)!
                            let realm = try! Realm()
                            // Insert from Data containing JSON
                            try! realm.write {
                                let json = try! JSONSerialization.jsonObject(with: data!, options: [])
                                realm.create(RealmData.self, value: json)
                            }
                            
                        }
                    }
                }else{
                    print("Someting went wrong: \(String(describing: response.response?.statusCode)) error")
                }
        }
    }

}

extension String
{
    var encodeEmoji: String{
        if let encodeStr = NSString(cString: self.cString(using: .nonLossyASCII)!, encoding: String.Encoding.utf8.rawValue){
            return encodeStr as String
        }
        return self
    }
    
    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try urlRequest.asURLRequest()
        request.httpBody = data(using: .utf8, allowLossyConversion: false)
        return request
    }
}

