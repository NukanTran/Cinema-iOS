//
//  API.swift
//  Cinema 2.0
//
//  Created by Trần Hoàng Lâm on 3/2/17.
//  Copyright © 2017 Trần Hoàng Lâm. All rights reserved.
//

import Foundation

enum APILink:String{
    case GET_LOCATION = "data/location"
    case GET_PRODUCER = "data/producer"
    case GET_CITY = "data/city/lat/log/email"
    case PUT_CITY = "data/city/lat/log"
    case GET_FILM_SHOW = "data/film/true/location/page"
    case GET_FILM_NOT_SHOW = "data/film/false/location/page"
    case POST_CATEGORIE = "data/categorie"
    case POST_EVENT = "data/event"
    case POST_LOGIN = "user/login"
    case POST_REGISTER = "user/register"
    case POST_LIKE = "user/like"
    case POST_UNLIKE = "user/unlike"
    var string:String{
        return AppConstants.HOST + "api/" + self.rawValue
    }
}
