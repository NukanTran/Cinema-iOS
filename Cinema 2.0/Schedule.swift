//
//  Schedule.swift
//
//  Created by Trần Hoàng Lâm on 5/2/17
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public final class Schedule: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let dateTime = "dateTime"
    static let slot = "slot"
    static let id = "id"
    static let linkTicket = "linkTicket"
  }

  // MARK: Properties
  public var dateTime: String?
  public var slot: String?
  public var id: String?
  public var linkTicket: String?
    
    var date:Date!
    var time:String!
    var disable = false

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
    dateTime = json[SerializationKeys.dateTime].string
    slot = json[SerializationKeys.slot].string
    id = json[SerializationKeys.id].string
    linkTicket = json[SerializationKeys.linkTicket].string
    
    if let dateTime = dateTime{
        let date = dateTime.substring(to: dateTime.index(dateTime.startIndex, offsetBy: 10))
        self.date = dateTime.toDate(stringFormat: "yyyy-MM-dd HH:mm").toRegion(7)
        self.time = dateTime.replacingOccurrences(of: date, with: "")
        self.disable = self.date < Date().toRegion(7)
    }
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = dateTime { dictionary[SerializationKeys.dateTime] = value }
    if let value = slot { dictionary[SerializationKeys.slot] = value }
    if let value = id { dictionary[SerializationKeys.id] = value }
    if let value = linkTicket { dictionary[SerializationKeys.linkTicket] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.dateTime = aDecoder.decodeObject(forKey: SerializationKeys.dateTime) as? String
    self.slot = aDecoder.decodeObject(forKey: SerializationKeys.slot) as? String
    self.id = aDecoder.decodeObject(forKey: SerializationKeys.id) as? String
    self.linkTicket = aDecoder.decodeObject(forKey: SerializationKeys.linkTicket) as? String
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(dateTime, forKey: SerializationKeys.dateTime)
    aCoder.encode(slot, forKey: SerializationKeys.slot)
    aCoder.encode(id, forKey: SerializationKeys.id)
    aCoder.encode(linkTicket, forKey: SerializationKeys.linkTicket)
  }

}
