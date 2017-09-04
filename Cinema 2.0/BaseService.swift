//
//  BaseSevice.swift
//  Cinema 2.0
//
//  Created by Trần Hoàng Lâm on 3/2/17.
//  Copyright © 2017 Trần Hoàng Lâm. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
class BaseService: NSObject {
    
    func requestReturnStatus(url: APILink, method: Alamofire.HTTPMethod , params: [String : Any]?, success: @escaping (_ data: JSON?, _ totalPage:Int) -> (), fail: @escaping (_ error: String?) -> ()) {
        Alamofire.request(url.string, method: method, parameters: params).responseJSON { response in
            print("---------------API_PUT---------------")
            print("Requests : ", url.string)
            print("Timeline : ", response.timeline.totalDuration)
            print("Params   : ", params ?? "")
            switch response.result {
            case .success(let result):
                let json = JSON(result)
                print("Result   : ", json)
                if let status:String = json["status"].string{
                    if status == "ok"{
                        if json["data"].exists(){
                            let total = json["total"].int
                            var numberOfPgae = json["numberOfPgae"].int
                            if numberOfPgae == 0{
                                numberOfPgae = 1
                            }
                            success(json["data"], Int(Float(total!)/Float(numberOfPgae!) + 0.9))
                        }else{
                            print("\t-----\n⛔️⛔️⛔️Error\t : not found data")
                            fail("not found data")
                        }
                    }else{
                        print("\t-----\n⛔️⛔️⛔️Error\t : \(status)")
                        fail(status)
                    }
                }else{
                    print("\t-----\n⛔️⛔️⛔️Error\t : not found status")
                    fail("not found status")
                }
            case .failure(let error):
                print("\t-----\n⛔️⛔️⛔️Error\t : \(error.localizedDescription)")
                fail(error.localizedDescription)
            }
            print("-----------------END-----------------")
        }
    }
    
    func requestWithPage(url: APILink, method: Alamofire.HTTPMethod , params: [String : Any]?, page:Int, success: @escaping (_ data: JSON?, _ totalPage:Int) -> (), fail: @escaping (_ error: String?) -> ()) {
        Alamofire.request(url.string.replacingOccurrences(of: "page", with: String(page)), method: method, parameters: params).responseJSON { response in
            print("---------------API_GET---------------")
            print("Requests : ", url.string.replacingOccurrences(of: "page", with: String(page)))
            print("Timeline : ", response.timeline.totalDuration)
            print("Params   : ", params ?? "")
            switch response.result {
            case .success(let result):
                let json = JSON(result)
                print("Result   : ", json)
                if let status:String = json["status"].string{
                    if status == "ok"{
                        if json["data"].exists(){
                            let total = json["total"].int
                            var numberOfPgae = json["numberOfPgae"].int
                            if numberOfPgae == 0{
                                numberOfPgae = 1
                            }
                            success(json["data"], Int(Float(total!)/Float(numberOfPgae!) + 0.9))
                        }else{
                            print("\t-----\n⛔️⛔️⛔️Error\t : not found data")
                            fail("not found data")
                        }
                    }else{
                        print("\t-----\n⛔️⛔️⛔️Error\t : \(status)")
                        fail(status)
                    }
                }else{
                    print("\t-----\n⛔️⛔️⛔️Error\t : not found status")
                    fail("not found status")
                }
            case .failure(let error):
                print("\t-----\n⛔️⛔️⛔️Error\t : \(error.localizedDescription)")
                fail(error.localizedDescription)
            }
            print("-----------------END-----------------")
        }
    }
    
    func requestWithGet(url: APILink, params: [String : Any]?, success: @escaping (_ data: JSON?, _ totalPage:Int) -> (), fail: @escaping (_ error: String?) -> ()) {
        var strURL = url.string
        for (key, value) in params!{
            strURL = strURL.replacingOccurrences(of: key, with: value as! String)
        }
        Alamofire.request(strURL, method: .get, parameters: [:]).responseJSON { response in
            print("---------------API_GET---------------")
            print("Requests : ", strURL)
            print("Timeline : ", response.timeline.totalDuration)
            print("Params   : ", params ?? "")
            switch response.result {
            case .success(let result):
                let json = JSON(result)
                print("Result   : ", json)
                if let status:String = json["status"].string{
                    if status == "ok"{
                        if json["data"].exists(){
                            let total = json["total"].int
                            var numberOfPgae = json["numberOfPgae"].int
                            if numberOfPgae == 0{
                                numberOfPgae = 1
                            }
                            success(json["data"], Int(Float(total!)/Float(numberOfPgae!) + 0.9))
                        }else{
                            print("\t-----\n⛔️⛔️⛔️Error\t : not found data")
                            fail("not found data")
                        }
                    }else{
                        print("\t-----\n⛔️⛔️⛔️Error\t : \(status)")
                        fail(status)
                    }
                }else{
                    print("\t-----\n⛔️⛔️⛔️Error\t : not found status")
                    fail("not found status")
                }
            case .failure(let error):
                print("\t-----\n⛔️⛔️⛔️Error\t : \(error.localizedDescription)")
                fail(error.localizedDescription)
            }
            print("-----------------END-----------------")
        }
    }
    
    func requestWithPost(url: APILink, params: [String : Any]?, success: @escaping (_ data: JSON?, _ totalPage:Int) -> (), fail: @escaping (_ error: String?) -> ()) {
        Alamofire.request(url.string, method: .post, parameters: params).responseJSON { response in
            print("---------------API_POST---------------")
            print("Requests : ", url.string)
            print("Timeline : ", response.timeline.totalDuration)
            print("Params   : ", params ?? "")
            switch response.result {
            case .success(let result):
                let json = JSON(result)
                print("Result   : ", json)
                if let status:String = json["status"].string{
                    if status == "ok"{
                        if json["data"].exists(){
                            let total = json["total"].int
                            var numberOfPgae = json["numberOfPgae"].int
                            if numberOfPgae == 0{
                                numberOfPgae = 1
                            }
                            success(json["data"], Int(Float(total!)/Float(numberOfPgae!) + 0.9))
                        }else{
                            print("\t-----\n⛔️⛔️⛔️Error\t : not found data")
                            fail("not found data")
                        }
                    }else{
                        print("\t-----\n⛔️⛔️⛔️Error\t : \(status)")
                        fail(status)
                    }
                }else{
                    print("\t-----\n⛔️⛔️⛔️Error\t : not found status")
                    fail("not found status")
                }
            case .failure(let error):
                print("\t-----\n⛔️⛔️⛔️Error\t : \(error.localizedDescription)")
                fail(error.localizedDescription)
            }
            print("-----------------END-----------------")
        }
    }
    
    
    func requestWithPut(url: APILink, paramsGet: [String : Any]?, paramsPost: [String : Any]?, success: @escaping (_ data: JSON?, _ totalPage:Int) -> (), fail: @escaping (_ error: String?) -> ()) {
        var strURL = url.string
        for (key, value) in paramsGet!{
            strURL = strURL.replacingOccurrences(of: key, with: value as! String)
        }
        Alamofire.request(strURL, method: .put, parameters: paramsPost).responseJSON { response in
            print("---------------API_PUT---------------")
            print("Requests : ", strURL)
            print("Timeline : ", response.timeline.totalDuration)
            print("Params   : ", paramsPost ?? "")
            switch response.result {
            case .success(let result):
                let json = JSON(result)
                print("Result   : ", json)
                if let status:String = json["status"].string{
                    if status == "ok"{
                        if json["data"].exists(){
                            let total = json["total"].int
                            var numberOfPgae = json["numberOfPgae"].int
                            if numberOfPgae == 0{
                                numberOfPgae = 1
                            }
                            success(json["data"], Int(Float(total!)/Float(numberOfPgae!) + 0.9))
                        }else{
                            print("\t-----\n⛔️⛔️⛔️Error\t : not found data")
                            fail("not found data")
                        }
                    }else{
                        print("\t-----\n⛔️⛔️⛔️Error\t : \(status)")
                        fail(status)
                    }
                }else{
                    print("\t-----\n⛔️⛔️⛔️Error\t : not found status")
                    fail("not found status")
                }
            case .failure(let error):
                print("\t-----\n⛔️⛔️⛔️Error\t : \(error.localizedDescription)")
                fail(error.localizedDescription)
            }
            print("-----------------END-----------------")
        }
    }
}
