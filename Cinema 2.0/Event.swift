//
//  Event.swift
//
//  Created by Trần Hoàng Lâm on 5/1/17
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public final class Event: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let name = "name"
    static let id = "id"
    static let producer = "Producer"
    static let linkPoster = "linkPoster"
    static let endTime = "endTime"
    static let idProducer = "idProducer"
    static let time = "time"
    static let intro = "intro"
  }

  // MARK: Properties
  public var name: String?
  public var id: String?
  public var producer: String?
  public var linkPoster: String?
  public var endTimeStr: String?
  public var idProducer: String?
  public var time: String?
  public var intro: String?
    
    var endTime:Date!

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
    name = json[SerializationKeys.name].string?.htmlToText()
    id = json[SerializationKeys.id].string
    producer = json[SerializationKeys.producer].string
    linkPoster = json[SerializationKeys.linkPoster].string
    endTimeStr = json[SerializationKeys.endTime].string
    idProducer = json[SerializationKeys.idProducer].string
    time = json[SerializationKeys.time].string?.htmlToText()
    intro = json[SerializationKeys.intro].string?.replacingOccurrences(of: "\n", with: "<br>").htmlToText()
    if var endTimeStr = self.endTimeStr{
        endTimeStr = endTimeStr.substring(to: (endTimeStr.index(endTimeStr.startIndex, offsetBy: 10)))
        self.endTime = endTimeStr.toDate(stringFormat: "yyyy-MM-dd")
    }
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = name { dictionary[SerializationKeys.name] = value }
    if let value = id { dictionary[SerializationKeys.id] = value }
    if let value = producer { dictionary[SerializationKeys.producer] = value }
    if let value = linkPoster { dictionary[SerializationKeys.linkPoster] = value }
    if let value = endTimeStr { dictionary[SerializationKeys.endTime] = value }
    if let value = idProducer { dictionary[SerializationKeys.idProducer] = value }
    if let value = time { dictionary[SerializationKeys.time] = value }
    if let value = intro { dictionary[SerializationKeys.intro] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.name = aDecoder.decodeObject(forKey: SerializationKeys.name) as? String
    self.id = aDecoder.decodeObject(forKey: SerializationKeys.id) as? String
    self.producer = aDecoder.decodeObject(forKey: SerializationKeys.producer) as? String
    self.linkPoster = aDecoder.decodeObject(forKey: SerializationKeys.linkPoster) as? String
    self.endTimeStr = aDecoder.decodeObject(forKey: SerializationKeys.endTime) as? String
    self.idProducer = aDecoder.decodeObject(forKey: SerializationKeys.idProducer) as? String
    self.time = aDecoder.decodeObject(forKey: SerializationKeys.time) as? String
    self.intro = aDecoder.decodeObject(forKey: SerializationKeys.intro) as? String
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(name, forKey: SerializationKeys.name)
    aCoder.encode(id, forKey: SerializationKeys.id)
    aCoder.encode(producer, forKey: SerializationKeys.producer)
    aCoder.encode(linkPoster, forKey: SerializationKeys.linkPoster)
    aCoder.encode(endTimeStr, forKey: SerializationKeys.endTime)
    aCoder.encode(idProducer, forKey: SerializationKeys.idProducer)
    aCoder.encode(time, forKey: SerializationKeys.time)
    aCoder.encode(intro, forKey: SerializationKeys.intro)
  }

}
