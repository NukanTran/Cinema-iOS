//
//  FacebookLoginData.swift
//
//  Created by Trần Hoàng Lâm on 5/10/17
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public final class FacebookLoginData: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let picture = "picture"
    static let name = "name"
    static let lastName = "last_name"
    static let email = "email"
    static let id = "id"
    static let firstName = "first_name"
  }

  // MARK: Properties
  public var picture: Picture?
  public var name: String?
  public var lastName: String?
  public var email: String?
  public var id: String?
  public var firstName: String?

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
    picture = Picture(json: json[SerializationKeys.picture])
    name = json[SerializationKeys.name].string
    lastName = json[SerializationKeys.lastName].string
    email = json[SerializationKeys.email].string
    id = json[SerializationKeys.id].string
    firstName = json[SerializationKeys.firstName].string
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = picture { dictionary[SerializationKeys.picture] = value.dictionaryRepresentation() }
    if let value = name { dictionary[SerializationKeys.name] = value }
    if let value = lastName { dictionary[SerializationKeys.lastName] = value }
    if let value = email { dictionary[SerializationKeys.email] = value }
    if let value = id { dictionary[SerializationKeys.id] = value }
    if let value = firstName { dictionary[SerializationKeys.firstName] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.picture = aDecoder.decodeObject(forKey: SerializationKeys.picture) as? Picture
    self.name = aDecoder.decodeObject(forKey: SerializationKeys.name) as? String
    self.lastName = aDecoder.decodeObject(forKey: SerializationKeys.lastName) as? String
    self.email = aDecoder.decodeObject(forKey: SerializationKeys.email) as? String
    self.id = aDecoder.decodeObject(forKey: SerializationKeys.id) as? String
    self.firstName = aDecoder.decodeObject(forKey: SerializationKeys.firstName) as? String
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(picture, forKey: SerializationKeys.picture)
    aCoder.encode(name, forKey: SerializationKeys.name)
    aCoder.encode(lastName, forKey: SerializationKeys.lastName)
    aCoder.encode(email, forKey: SerializationKeys.email)
    aCoder.encode(id, forKey: SerializationKeys.id)
    aCoder.encode(firstName, forKey: SerializationKeys.firstName)
  }

}
