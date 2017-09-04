//
//  Cinema.swift
//
//  Created by Trần Hoàng Lâm on 5/1/17
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON
import CoreLocation

public final class Cinema: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let latitude = "latitude"
    static let name = "name"
    static let id = "id"
    static let phoneNumber = "phoneNumber"
    static let address = "address"
    static let linkImage = "linkImage"
    static let longitude = "longitude"
    static let intro = "intro"
  }

  // MARK: Properties
  public var latitude: String?
  public var name: String?
  public var id: String?
  public var phoneNumber: String?
  public var address: String?
  public var linkImage: String?
  public var longitude: String?
  public var intro: String?
    
    var mapData:MapData!
    var minDistance = false

  // MARK: SwiftyJSON Initializers
  /// Initiates the instance based on the object.
  ///
  /// - parameter object: The object of either Dictionary or Array kind that was passed.
  /// - returns: An initialized instance of the class.
  public convenience init(object: Any) {
    self.init(json: JSON(object))
  }

  /// Initiates the instance based on the JSON that was passed.
  ///
  /// - parameter json: JSON object from SwiftyJSON.
  public required init(json: JSON) {
    latitude = json[SerializationKeys.latitude].string
    name = json[SerializationKeys.name].string?.htmlToText()
    id = json[SerializationKeys.id].string
    phoneNumber = json[SerializationKeys.phoneNumber].string
    address = json[SerializationKeys.address].string?.htmlToText()
    linkImage = json[SerializationKeys.linkImage].string
    longitude = json[SerializationKeys.longitude].string
    intro = json[SerializationKeys.intro].string?.replacingOccurrences(of: "\n", with: "<br>").htmlToText()
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = latitude { dictionary[SerializationKeys.latitude] = value }
    if let value = name { dictionary[SerializationKeys.name] = value }
    if let value = id { dictionary[SerializationKeys.id] = value }
    if let value = phoneNumber { dictionary[SerializationKeys.phoneNumber] = value }
    if let value = address { dictionary[SerializationKeys.address] = value }
    if let value = linkImage { dictionary[SerializationKeys.linkImage] = value }
    if let value = longitude { dictionary[SerializationKeys.longitude] = value }
    if let value = intro { dictionary[SerializationKeys.intro] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.latitude = aDecoder.decodeObject(forKey: SerializationKeys.latitude) as? String
    self.name = aDecoder.decodeObject(forKey: SerializationKeys.name) as? String
    self.id = aDecoder.decodeObject(forKey: SerializationKeys.id) as? String
    self.phoneNumber = aDecoder.decodeObject(forKey: SerializationKeys.phoneNumber) as? String
    self.address = aDecoder.decodeObject(forKey: SerializationKeys.address) as? String
    self.linkImage = aDecoder.decodeObject(forKey: SerializationKeys.linkImage) as? String
    self.longitude = aDecoder.decodeObject(forKey: SerializationKeys.longitude) as? String
    self.intro = aDecoder.decodeObject(forKey: SerializationKeys.intro) as? String
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(latitude, forKey: SerializationKeys.latitude)
    aCoder.encode(name, forKey: SerializationKeys.name)
    aCoder.encode(id, forKey: SerializationKeys.id)
    aCoder.encode(phoneNumber, forKey: SerializationKeys.phoneNumber)
    aCoder.encode(address, forKey: SerializationKeys.address)
    aCoder.encode(linkImage, forKey: SerializationKeys.linkImage)
    aCoder.encode(longitude, forKey: SerializationKeys.longitude)
    aCoder.encode(intro, forKey: SerializationKeys.intro)
  }
    
    func getMapData(_ completion: @escaping () -> ()){
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case .notDetermined, .restricted, .denied:
                completion()
                print("No access location")
            case .authorizedAlways, .authorizedWhenInUse:
                if let location = ManagerUser.myLocation, let latitude = Double(self.latitude!), let longitude = Double(self.longitude!){
                    ManagerData.share.getPolylineMap(source: location.coordinate, destination: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), success: { (data) in
                        self.mapData = data
                        completion()
                    }, fail: { (err) in
                        completion()
                    })
                }else{
                    completion()
                }
                //print("Access")
                break
            }
        } else {
            completion()
            print("Location services are not enabled")
        }
    }
    
}
