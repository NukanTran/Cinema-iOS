//
//  ManagerData.swift
//  Cinema 2.0
//
//  Created by Trần Hoàng Lâm on 3/2/17.
//  Copyright © 2017 Trần Hoàng Lâm. All rights reserved.
//

import Foundation
import Alamofire
import CoreLocation
import SwiftyJSON

class ManagerData: BaseService{
    
    static let share = ManagerData()
    
    func getListLocation(success: @escaping (_ listData: [Location], _ pageCount: Int) -> (), fail: @escaping (_ error: String) -> ()) {
        self.requestReturnStatus(url: .GET_LOCATION, method: .get, params: [:], success: { (data, totalPage) in
            var listData:[Any] = []
            for value in data!.array!{
                listData.append(Location(json: value))
            }
            success(listData as! [Location], totalPage)
        }) { (error) in
            fail(error!)
        }
    }
    
    func getCity(lat: Double, log:Double, email:String, success: @escaping (_ listData: String) -> (), fail: @escaping (_ error: String) -> ()) {
        self.requestWithGet(url: .GET_CITY, params: ["lat":lat.description, "log":log.description, "email":email], success: { (data, totalPage) in
            success((data?.string)!)
        }) { (error) in
            fail(error!)
        }
    }
    
    func getListProducer(success: @escaping (_ listData: [Producer], _ pageCount: Int) -> (), fail: @escaping (_ error: String) -> ()) {
        self.requestReturnStatus(url: .GET_PRODUCER, method: .get, params: [:], success: { (data, totalPage) in
            var listData:[Any] = []
            for value in data!.array!{
                listData.append(Producer(json: value))
            }
            success(listData as! [Producer], totalPage)
        }) { (error) in
            fail(error!)
        }
    }
    
    func getListCinema(idLocation:String, success: @escaping (_ listData: [Producer], _ pageCount: Int) -> (), fail: @escaping (_ error: String) -> ()) {
        self.requestReturnStatus(url: .POST_CATEGORIE, method: .post, params: ["id":idLocation, "categorie": "cinema"], success: { (data, totalPage) in
            var listData:[Any] = []
            for value in data!.array!{
                listData.append(Producer(json: value))
            }
            success(listData as! [Producer], totalPage)
        }) { (error) in
            fail(error!)
        }
    }
    
    func getListDateByCinema(idCinema:String, success: @escaping (_ listData: [String], _ pageCount: Int) -> (), fail: @escaping (_ error: String) -> ()) {
        self.requestReturnStatus(url: .POST_CATEGORIE, method: .post, params: ["id":idCinema, "categorie": "datebycinema"], success: { (data, totalPage) in
            var listData:[Any] = []
            for value in data!.array!{
                listData.append(value.string ?? "")
            }
            success(listData as! [String], totalPage)
        }) { (error) in
            fail(error!)
        }
    }
    
    func getListCinemaByFilm(idLocation:String ,idFilm:String, success: @escaping (_ listData: [Producer], _ pageCount: Int) -> (), fail: @escaping (_ error: String) -> ()) {
        self.requestReturnStatus(url: .POST_CATEGORIE, method: .post, params: ["id":idLocation + "#" + idFilm, "categorie": "cinemabyfilm"], success: { (data, totalPage) in
            var listData:[Any] = []
            for value in data!.array!{
                listData.append(Producer(json: value))
            }
            success(listData as! [Producer], totalPage)
        }) { (error) in
            fail(error!)
        }
    }
    
    func getListEvent(page:Int, idProducer:String, success: @escaping (_ listData: [Event], _ pageCount: Int) -> (), fail: @escaping (_ error: String) -> ()) {
        self.requestWithPost(url: .POST_EVENT, params: ["id":idProducer, "page": page], success: { (data, totalPage) in
            var listData:[Any] = []
            for value in data!.array!{
                listData.append(Event(json: value))
            }
            success(listData as! [Event], totalPage)
        }) { (error) in
            fail(error!)
        }
    }
    
    func getListFilm(show:Bool, page:Int, success: @escaping (_ listData: [Film], _ pageCount: Int) -> (), fail: @escaping (_ error: String) -> ()) {
        self.requestWithPage(url: show ? .GET_FILM_SHOW: .GET_FILM_NOT_SHOW, method: .get, params: ["location":ManagerUser.idLocation], page: page, success: { (data, totalPage) in
            var listData:[Any] = []
            for value in data!.array!{
                listData.append(Film(json: value))
            }
            success(listData as! [Film], totalPage)
        }) { (error) in
            fail(error!)
        }
    }
    
    func getListFilmByDate(idCinema:String ,date:String, success: @escaping (_ listData: [Film], _ pageCount: Int) -> (), fail: @escaping (_ error: String) -> ()) {
        self.requestReturnStatus(url: .POST_CATEGORIE, method: .post, params: ["id":idCinema + "#" + date, "categorie": "filmbydate"], success: { (data, totalPage) in
            var listData:[Any] = []
            for value in data!.array!{
                listData.append(Film(json: value))
            }
            success(listData as! [Film], totalPage)
        }) { (error) in
            fail(error!)
        }
    }
    
    func getListSchedule(idFilm:String, idCinema:String ,success: @escaping (_ listData: [Schedule], _ pageCount: Int) -> (), fail: @escaping (_ error: String) -> ()) {
        self.requestReturnStatus(url: .POST_CATEGORIE, method: .post, params: ["id":idFilm + "#" + idCinema, "categorie": "schedule"], success: { (data, totalPage) in
            var listData:[Any] = []
            for value in data!.array!{
                listData.append(Schedule(json: value))
            }
            success(listData as! [Schedule], totalPage)
        }) { (error) in
            fail(error!)
        }
    }
    
    func getDetailFilm(idFilm:String ,success: @escaping (_ data: Film, _ pageCount: Int) -> (), fail: @escaping (_ error: String) -> ()) {
        self.requestReturnStatus(url: .POST_CATEGORIE, method: .post, params: ["id":idFilm, "categorie": "detailfilm"], success: { (data, totalPage) in
            success(Film(json: data!), totalPage)
        }) { (error) in
            fail(error!)
        }
    }
    
    func getPolylineMap(source:CLLocationCoordinate2D, destination:CLLocationCoordinate2D ,success: @escaping (_ data: MapData) -> (), fail: @escaping (_ error: String) -> ()){
        let strURL = "https://maps.googleapis.com/maps/api/directions/json"
        let params = ["origin":"\(source.latitude),\(source.longitude)",
                    "destination":"\(destination.latitude),\(destination.longitude)",
                    "key":AppConstants.APIKey.gDirectionsAPIKey]
        Alamofire.request(strURL, method: .get, parameters: params).responseJSON { response in
            print("---------------API_MAPS---------------")
            print("Requests : ", strURL)
            print("Timeline : ", response.timeline.totalDuration)
            print("Params   : ", params)
            switch response.result {
            case .success(let result):
                let data = MapData(json: JSON(result))
                print("Result   : ", data.dictionaryRepresentation())
                if data.status == "OK"{
                    success(data)
                }else{
                    print("\t-----\n⛔️⛔️⛔️Error\t : \(data.status!)")
                    fail(data.status!)
                }
            case .failure(let error):
                print("\t-----\n⛔️⛔️⛔️Error\t : \(error.localizedDescription)")
                fail(error.localizedDescription)
            }
            print("-----------------END-----------------")
            
        }
    }
    
    func login(email:String , password: String, success: @escaping (_ data: User, _ pageCount: Int) -> (), fail: @escaping (_ error: String) -> ()) {
        self.requestReturnStatus(url: .POST_LOGIN, method: .post, params: ["Email":email, "Password":password.toBase64()!], success: { (data, totalPage) in
            success(User(json: data!), totalPage)
        }) { (error) in
            fail(error!)
        }
    }
    
    func register(user:User, success: @escaping () -> (), fail: @escaping (_ error: String) -> ()) {
        self.requestReturnStatus(url: .POST_REGISTER, method: .post, params: user.dictionaryRepresentation(), success: { (data, totalPage) in
            success()
        }) { (error) in
            fail(error!)
        }
    }
    
    func like(email:String, id:String, categorie:String, success: @escaping () -> (), fail: @escaping (_ error: String) -> ()) {
        self.requestReturnStatus(url: APILink.POST_LIKE, method: .post, params: ["id":email + "#" + id, "categorie": categorie], success: { (data, totalPage) in
            success()
        }) { (error) in
            fail(error!)
        }
    }
    
    func unlike(email:String, id:String, categorie:String, success: @escaping () -> (), fail: @escaping (_ error: String) -> ()) {
        self.requestReturnStatus(url: APILink.POST_UNLIKE, method: .post, params: ["id":email + "#" + id, "categorie": categorie], success: { (data, totalPage) in
            success()
        }) { (error) in
            fail(error!)
        }
    }
    
}
