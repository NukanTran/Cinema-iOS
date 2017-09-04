//
//  Film.swift
//
//  Created by Trần Hoàng Lâm on 5/2/17
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public final class Film: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let intro = "intro"
    static let name = "name"
    static let isHot = "isHot"
    static let imdb = "imdb"
    static let linkTrailer = "linkTrailer"
    static let length = "length"
    static let classification = "classification"
    static let listSchedule = "listSchedule"
    static let id = "id"
    static let director = "director"
    static let genre = "genre"
    static let linkPoster = "linkPoster"
    static let actor = "actor"
    static let linkBanner = "linkBanner"
    static let premiere = "premiere"
    static let country = "country"
  }

  // MARK: Properties
  public var intro: String?
  public var name: String?
  public var isHot: Bool? = false
  public var imdb: Double?
  public var linkTrailer: String?
  public var length: String?
  public var classification: String?
  public var listSchedule: [Schedule]?
  public var id: String?
  public var director: String?
  public var genre: String?
  public var linkPoster: String?
  public var actor: String?
  public var linkBanner: String?
  public var premiereStr: String?
  public var country: String?
    
    var premiere:Date!
    var slot:String = ""
    var heightContainer:CGFloat = 294

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
    intro = json[SerializationKeys.intro].string?.replacingOccurrences(of: "\n", with: "<br>").htmlToText()
    name = json[SerializationKeys.name].string?.htmlToText()
    isHot = json[SerializationKeys.isHot].boolValue
    imdb = json[SerializationKeys.imdb].double
    linkTrailer = json[SerializationKeys.linkTrailer].string
    length = json[SerializationKeys.length].string?.htmlToText()
    classification = json[SerializationKeys.classification].string
    if let items = json[SerializationKeys.listSchedule].array { listSchedule = items.map { Schedule(json: $0) } }
    id = json[SerializationKeys.id].string
    director = json[SerializationKeys.director].string?.htmlToText()
    genre = json[SerializationKeys.genre].string?.htmlToText()
    linkPoster = json[SerializationKeys.linkPoster].string
    actor = json[SerializationKeys.actor].string?.htmlToText()
    linkBanner = json[SerializationKeys.linkBanner].string
    premiereStr = json[SerializationKeys.premiere].string
    country = json[SerializationKeys.country].string?.htmlToText()
    
    if var premiereStr = self.premiereStr{
        premiereStr = premiereStr.substring(to: premiereStr.index(premiereStr.startIndex, offsetBy: 10))
        self.premiere = premiereStr.toDate(stringFormat: "yyyy-MM-dd")
    }
    if let listSchedule = self.listSchedule{
        for i in listSchedule{
            if !self.slot.contains((i.slot?.uppercased())!){
                if self.slot != ""{
                    self.slot += ", "
                }
                self.slot += (i.slot?.uppercased())!
            }
        }
        var height = CGFloat(Int((CGFloat(listSchedule.count)/CGFloat(Int((UIScreen.main.bounds.width-24)/108)) + 0.99)))*58 + 65
        if height > CGFloat(Int((CGFloat(Int((UIScreen.main.bounds.width-24)/108)) + 0.99)))*58 + 65{
            height = CGFloat(Int((CGFloat(Int((UIScreen.main.bounds.width-24)/108)) + 0.99)))*58 + 65
        }
        self.heightContainer = height
    }
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = intro { dictionary[SerializationKeys.intro] = value }
    if let value = name { dictionary[SerializationKeys.name] = value }
    dictionary[SerializationKeys.isHot] = isHot
    if let value = imdb { dictionary[SerializationKeys.imdb] = value }
    if let value = linkTrailer { dictionary[SerializationKeys.linkTrailer] = value }
    if let value = length { dictionary[SerializationKeys.length] = value }
    if let value = classification { dictionary[SerializationKeys.classification] = value }
    if let value = listSchedule { dictionary[SerializationKeys.listSchedule] = value.map { $0.dictionaryRepresentation() } }
    if let value = id { dictionary[SerializationKeys.id] = value }
    if let value = director { dictionary[SerializationKeys.director] = value }
    if let value = genre { dictionary[SerializationKeys.genre] = value }
    if let value = linkPoster { dictionary[SerializationKeys.linkPoster] = value }
    if let value = actor { dictionary[SerializationKeys.actor] = value }
    if let value = linkBanner { dictionary[SerializationKeys.linkBanner] = value }
    if let value = premiereStr { dictionary[SerializationKeys.premiere] = value }
    if let value = country { dictionary[SerializationKeys.country] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.intro = aDecoder.decodeObject(forKey: SerializationKeys.intro) as? String
    self.name = aDecoder.decodeObject(forKey: SerializationKeys.name) as? String
    self.isHot = aDecoder.decodeBool(forKey: SerializationKeys.isHot)
    self.imdb = aDecoder.decodeObject(forKey: SerializationKeys.imdb) as? Double
    self.linkTrailer = aDecoder.decodeObject(forKey: SerializationKeys.linkTrailer) as? String
    self.length = aDecoder.decodeObject(forKey: SerializationKeys.length) as? String
    self.classification = aDecoder.decodeObject(forKey: SerializationKeys.classification) as? String
    self.listSchedule = aDecoder.decodeObject(forKey: SerializationKeys.listSchedule) as? [Schedule]
    self.id = aDecoder.decodeObject(forKey: SerializationKeys.id) as? String
    self.director = aDecoder.decodeObject(forKey: SerializationKeys.director) as? String
    self.genre = aDecoder.decodeObject(forKey: SerializationKeys.genre) as? String
    self.linkPoster = aDecoder.decodeObject(forKey: SerializationKeys.linkPoster) as? String
    self.actor = aDecoder.decodeObject(forKey: SerializationKeys.actor) as? String
    self.linkBanner = aDecoder.decodeObject(forKey: SerializationKeys.linkBanner) as? String
    self.premiereStr = aDecoder.decodeObject(forKey: SerializationKeys.premiere) as? String
    self.country = aDecoder.decodeObject(forKey: SerializationKeys.country) as? String
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(intro, forKey: SerializationKeys.intro)
    aCoder.encode(name, forKey: SerializationKeys.name)
    aCoder.encode(isHot, forKey: SerializationKeys.isHot)
    aCoder.encode(imdb, forKey: SerializationKeys.imdb)
    aCoder.encode(linkTrailer, forKey: SerializationKeys.linkTrailer)
    aCoder.encode(length, forKey: SerializationKeys.length)
    aCoder.encode(classification, forKey: SerializationKeys.classification)
    aCoder.encode(listSchedule, forKey: SerializationKeys.listSchedule)
    aCoder.encode(id, forKey: SerializationKeys.id)
    aCoder.encode(director, forKey: SerializationKeys.director)
    aCoder.encode(genre, forKey: SerializationKeys.genre)
    aCoder.encode(linkPoster, forKey: SerializationKeys.linkPoster)
    aCoder.encode(actor, forKey: SerializationKeys.actor)
    aCoder.encode(linkBanner, forKey: SerializationKeys.linkBanner)
    aCoder.encode(premiere, forKey: SerializationKeys.premiere)
    aCoder.encode(country, forKey: SerializationKeys.country)
  }

}
