//
//  Model.swift
//  RDB
//
//  Created by subramanyam on 18/12/18.
//  Copyright © 2018 mahiti. All rights reserved.
//

// To parse the JSON, add this file to your project and do:
//
//   let collectionData = try? newJSONDecoder().decode(CollectionData.self, from: jsonData)

import Foundation
import Realm
import RealmSwift

class CollectionData: Codable {
    let url: String
    let nm: [Nm]

    init(url: String, nm: [Nm]) {
        self.url = url
        self.nm = nm
    }

}

class Nm: Codable {
    let k1: Int
    let k2, k3, k4, k5: String
    let k6: String
    let k7: Int

    init(k1: Int, k2: String, k3: String, k4: String, k5: String, k6: String, k7: Int) {
        self.k1 = k1
        self.k2 = k2
        self.k3 = k3
        self.k4 = k4
        self.k5 = k5
        self.k6 = k6
        self.k7 = k7
    }
}


//Updated Model for Realm
final class RealmData: Object {
    
    @objc dynamic var url: String = ""
    var am = List<Members>()
    
}

final class Members: Object {
    
    @objc dynamic var k1 = 0
    @objc dynamic var k2: String?
    @objc dynamic var k3: String?
    @objc dynamic var k4: String?
    @objc dynamic var k5: String?
    @objc dynamic var k6: String?
    @objc dynamic var k7 = 0
    
    override static func primaryKey() -> String? {
        return "k1"
    }

}
