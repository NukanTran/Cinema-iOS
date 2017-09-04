//
//  User.swift
//
//  Created by Trần Hoàng Lâm on 5/1/17
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public final class User: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let name = "name"
    static let listCinema = "listCinema"
    static let male = "male"
    static let phoneNumber = "phoneNumber"
    static let listFilm = "listFilm"
    static let listEvent = "listEvent"
    static let address = "address"
    static let password = "password"
    static let email = "email"
    static let birthday = "birthday"
    static let linkAvatar = "linkAvatar"
    }
    
    private struct Keys {
        static let name = "Name"
        static let listCinema = "ListCinema"
        static let male = "Male"
        static let phoneNumber = "PhoneNumber"
        static let listFilm = "ListFilm"
        static let listEvent = "ListEvent"
        static let address = "Address"
        static let password = "Password"
        static let email = "Email"
        static let birthday = "Birthday"
        static let linkAvatar = "LinkAvatar"
    }

  // MARK: Properties
  public var name: String?
  public var listCinema: [Cinema]?
  public var male: Bool? = false
  public var phoneNumber: String?
  public var listFilm: [Film]?
  public var listEvent: [Event]?
  public var address: String?
  public var password: String?
  public var email: String?
  public var birthday: String?
  public var linkAvatar:String?

  // MARK: SwiftyJSON Initializers
  /// Initiates the instance based on the object.
  ///
  /// - parameter object: The object of either Dictionary or Array kind that was passed.
  /// - returns: An initialized instance of the class.
  public convenience init(object: Any) {
    self.init(json: JSON(object))
  }
    
    public init(){}

  /// Initiates the instance based on the JSON that was passed.
  ///
  /// - parameter json: JSON object from SwiftyJSON.
  public required init(json: JSON) {
    name = json[SerializationKeys.name].string?.htmlToText()
    if let items = json[SerializationKeys.listCinema].array { listCinema = items.map { Cinema(json: $0) } }
    male = json[SerializationKeys.male].boolValue
    phoneNumber = json[SerializationKeys.phoneNumber].string
    if let items = json[SerializationKeys.listFilm].array { listFilm = items.map { Film(json: $0) } }
    if let items = json[SerializationKeys.listEvent].array { listEvent = items.map { Event(json: $0) } }
    address = json[SerializationKeys.address].string?.htmlToText()
    password = json[SerializationKeys.password].string
    email = json[SerializationKeys.email].string
    birthday = json[SerializationKeys.birthday].string
    linkAvatar = json[SerializationKeys.linkAvatar].string
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = name { dictionary[Keys.name] = value }
    if let value = listCinema { dictionary[Keys.listCinema] = value.map { $0.dictionaryRepresentation() } }
    dictionary[Keys.male] = male
    if let value = phoneNumber { dictionary[Keys.phoneNumber] = value }
    if let value = listFilm { dictionary[Keys.listFilm] = value }
    if let value = listEvent { dictionary[Keys.listEvent] = value.map { $0.dictionaryRepresentation() } }
    if let value = address { dictionary[Keys.address] = value }
    if let value = password { dictionary[Keys.password] = value }
    if let value = email { dictionary[Keys.email] = value }
    if let value = birthday { dictionary[Keys.birthday] = value }
    if let value = linkAvatar { dictionary[Keys.linkAvatar] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.name = aDecoder.decodeObject(forKey: SerializationKeys.name) as? String
    self.listCinema = aDecoder.decodeObject(forKey: SerializationKeys.listCinema) as? [Cinema]
    self.male = aDecoder.decodeBool(forKey: SerializationKeys.male)
    self.phoneNumber = aDecoder.decodeObject(forKey: SerializationKeys.phoneNumber) as? String
    self.listFilm = aDecoder.decodeObject(forKey: SerializationKeys.listFilm) as? [Film]
    self.listEvent = aDecoder.decodeObject(forKey: SerializationKeys.listEvent) as? [Event]
    self.address = aDecoder.decodeObject(forKey: SerializationKeys.address) as? String
    self.password = aDecoder.decodeObject(forKey: SerializationKeys.password) as? String
    self.email = aDecoder.decodeObject(forKey: SerializationKeys.email) as? String
    self.birthday = aDecoder.decodeObject(forKey: SerializationKeys.birthday) as? String
    self.linkAvatar = aDecoder.decodeObject(forKey: SerializationKeys.linkAvatar) as? String
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(name, forKey: SerializationKeys.name)
    aCoder.encode(listCinema, forKey: SerializationKeys.listCinema)
    aCoder.encode(male, forKey: SerializationKeys.male)
    aCoder.encode(phoneNumber, forKey: SerializationKeys.phoneNumber)
    aCoder.encode(listFilm, forKey: SerializationKeys.listFilm)
    aCoder.encode(listEvent, forKey: SerializationKeys.listEvent)
    aCoder.encode(address, forKey: SerializationKeys.address)
    aCoder.encode(password, forKey: SerializationKeys.password)
    aCoder.encode(email, forKey: SerializationKeys.email)
    aCoder.encode(birthday, forKey: SerializationKeys.birthday)
    aCoder.encode(linkAvatar, forKey: SerializationKeys.linkAvatar)
  }
    
    public func isLikeCinema(id:String)->Bool{
        return self.listCinema?.filter{$0.id == id}.isEmpty == false
    }
    
    public func isLikeFilm(id:String)->Bool{
        return self.listFilm!.filter{$0.id == id}.isEmpty == false
    }
    
    public func isLikeEvent(id:String)->Bool{
        return self.listEvent!.filter{$0.id == id}.isEmpty == false
    }

}
