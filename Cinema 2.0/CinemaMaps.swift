//
//  CinemaMapsViewController.swift
//  Cinema 2.0
//
//  Created by Trần Hoàng Lâm on 4/9/17.
//  Copyright © 2017 Trần Hoàng Lâm. All rights reserved.
//

import UIKit
import GoogleMaps

class CinemaMaps:BaseViewController{
    
    var mapView:GMSMapView!
    var listPoly:[GMSPolyline] = []
    var listCinema:[Producer]!{
        didSet{
            if let _ = self.mapView, let listCinema = self.listCinema{
                for producer in listCinema{
                    for cinema in producer.listCinema!{
                        marker(cinema: cinema, title: producer.name!)
                    }
                }
            }
        }
    }
    var cinema:Cinema!{
        didSet{
            if let mapView = self.mapView{
                if let latitude = Double(cinema.latitude!), let longitude = Double(cinema.longitude!){
                    let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: 15.0)
                    mapView.animate(to: camera)
                    polyLine()
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupMapView()
    }
    
}

extension CinemaMaps{
    
    func polyLine(){
        for line in listPoly{
            line.map = nil
        }
        self.listPoly = []
        if let mapData = cinema.mapData{
            for route in mapData.routes!{
                for leg in route.legs!{
                    for step in  leg.steps!{
                        let path = GMSMutablePath(fromEncodedPath: (step.polyline?.points)!)
                        let line = GMSPolyline(path: path)
                        line.strokeWidth = 3.0
                        line.strokeColor = UIColor.iconSelected
                        line.map = self.mapView
                        self.listPoly.append(line)
                    }
                }
            }
        }
    }
    
    func marker(cinema:Cinema, title:String){
        if let latitude = Double(cinema.latitude!), let longitude = Double(cinema.longitude!){
            let position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let marker = GMSMarker()
            marker.position = position
            marker.title = cinema.name
            if let mapData = cinema.mapData{
                marker.snippet = "Khoảng cách\t : \(mapData.routes?[0].legs?[0].distance?.text ?? "...") \n Thời gian đi\t : \((mapData.routes?[0].legs?[0].duration?.text?.replacingOccurrences(of: "mins", with: "phút").replacingOccurrences(of: "hours", with: "giờ").replacingOccurrences(of: "day", with: "ngày"))!) đi xe"
            }
            marker.appearAnimation = GMSMarkerAnimation.pop
            let imv = UIImageView(image: #imageLiteral(resourceName: "position").withRenderingMode(.alwaysTemplate))
            imv.tintColor = #colorLiteral(red: 0.8978185654, green: 0.3886027932, blue: 0.3255817294, alpha: 1)
            imv.contentMode = .scaleAspectFit
            imv.frame.size = CGSize(width: 45, height: 45)
            let lbl = UILabel()
            lbl.font = UIFont(name: "HelveticaNeue", size: 10)
            lbl.textAlignment = .center
            lbl.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            lbl.text = title
            imv.addViewWithContrains(VSFormat: "H:|-1-[v0]-4-|", views: lbl)
            imv.addViewWithContrains(VSFormat: "V:|-6-[v0]", views: lbl)
            marker.iconView = imv
            marker.map = mapView
        }
    }
    
    func setupMapView(){
        mapView = GMSMapView()
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        mapView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 113 - 74)
        self.view.addSubview(mapView)
    }
}
