//
//  LocationController.swift
//  Cinema 2.0
//
//  Created by Trần Hoàng Lâm on 6/10/17.
//  Copyright © 2017 Trần Hoàng Lâm. All rights reserved.
//

import UIKit
import SwiftyUserDefaults

class LocationController:UIViewController{
    
    var listLocation: [Location] = []
    var selectedIndex:Int!
    
    let backgroundLoading: UIView = {
        let view = UIView()
        var loadingView: UIView!
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).withAlphaComponent(0.2)
        view.isHidden = true
        loadingView = UIView()
        loadingView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).withAlphaComponent(0.5)
        loadingView.layer.cornerRadius = 10
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loadingView)
        view.centerXAnchor.constraint(equalTo: loadingView.centerXAnchor).isActive = true
        view.centerYAnchor.constraint(equalTo: loadingView.centerYAnchor, constant: 25).isActive = true
        loadingView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        loadingView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        return view
    }()
    
    var loading: UIActivityIndicatorView = {
        let loading = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        loading.hidesWhenStopped = true
        return loading
    }()
    
    lazy var tableView:UITableView = {
        let tbv = UITableView(frame: .zero)
        tbv.delegate = self
        tbv.dataSource = self
        tbv.rowHeight = 40
        tbv.registerCells(TablleCellLocation.self)
        return tbv
    }()
    
    let btnClose:UIButton = {
        let btn = UIButton()
        btn.backgroundColor = UIColor.icon.withAlphaComponent(0.7)
        let imv = UIImageView(image: #imageLiteral(resourceName: "close").withRenderingMode(.alwaysTemplate))
        imv.tintColor = UIColor.iconSelected
        imv.contentMode = .scaleToFill
        btn.addViewWithContrains(VSFormat: "H:|-15-[v0(20)]", views: imv)
        btn.addViewWithContrains(VSFormat: "V:|-15-[v0]-15-|", views: imv)
        btn.isHidden = true
        btn.addTarget(self, action: #selector(LocationController.close), for: .touchUpInside)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNotify()
        self.view.backgroundColor = .white
        self.addSubview()
        self.addLoading()
        self.loadLocation()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

extension LocationController{
    
    func addSubview(){
        let imvBanner:UIImageView = {
            let imv = UIImageView()
            imv.image = #imageLiteral(resourceName: "banner_maps")
            return imv
        }()
        let lblTitle:UILabel = {
           let lbl = UILabel()
            lbl.font = UIFont.semibold?.size(20)
            lbl.text = "Chọn Tỉnh/Thành phố"
            lbl.textColor = .iconSelected
            lbl.textAlignment = .center
            lbl.backgroundColor = .icon
            return lbl
        }()
        
        let btnNext:UIButton = {
            let btn = UIButton()
            btn.backgroundColor = .iconSelected
            btn.titleLabel?.font = UIFont(name: AppConstants.FontName.semibold, size: 18)
            btn.setTitle("Xong", for: .normal)
            btn.addTarget(self, action: #selector(LocationController.done), for: .touchUpInside)
            return btn
        }()
        self.view.addViewWithContrains(VSFormat: "H:|[v0]|", views: imvBanner)
        self.view.addViewWithContrains(VSFormat: "H:|[v0]|", views: lblTitle)
        self.view.addViewWithContrains(VSFormat: "H:|[v0]|", views: tableView)
        self.view.addViewWithContrains(VSFormat: "H:|[v0]|", views: btnNext)
        self.view.addViewWithContrains(VSFormat: "H:|[v0]|", views: btnClose)
        self.view.addViewWithContrains(VSFormat: "V:|[v0(50)]", views: btnClose)
        self.view.addViewWithContrains(VSFormat: "V:|[v0][v1(50)][v2][v3(50)]|", views: imvBanner, lblTitle, tableView, btnNext)
        
    }
    
    func addLoading() {
        self.view.addViewWithContrains(VSFormat: "H:|[v0]|", views: backgroundLoading)
        self.view.addViewWithContrains(VSFormat: "V:|[v0]|", views: backgroundLoading)
        self.backgroundLoading.addViewWithContrains(VSFormat: "H:|[v0]|", views: loading)
        self.backgroundLoading.addViewWithContrains(VSFormat: "V:|[v0]-49-|", views: loading)
    }
    
    func showLoading(isShow: Bool) {
        backgroundLoading.isHidden = !isShow
        if isShow {
            loading.startAnimating()
        }else {
            loading.stopAnimating()
        }
    }
    
    func checkLocation(){
        if !ManagerUser.idLocation.isEmpty{
            appDelegate.tabBar = TabBarController()
            appDelegate.window?.rootViewController = appDelegate.tabBar
        }
    }
    
    func setupNotify(){
        NotificationCenter.default.addObserver(self, selector: #selector(checkLocation), name: NSNotification.Name.locationChanged, object: nil)
    }
    
    func done(){
        if let selectedIndex = selectedIndex, selectedIndex < listLocation.count{
            Defaults[.location] = listLocation[selectedIndex].id!
            ManagerUser.idLocation = listLocation[selectedIndex].id!
            checkLocation()
        }
    }
    
    func close(){
        dismiss(animated: true, completion: nil)
    }
    
    func loadLocation(){
        self.showLoading(isShow: true)
        ManagerData.share.getListLocation(success: { (list, total) in
            self.showLoading(isShow: false)
            self.listLocation = list
            if self.listLocation.count < 1 {
                _ = alert.showAlert("Thông Báo", subTitle: "Không có dữ liệu!", style: AlertStyle.warning, buttonTitle:"OK", buttonColor: UIColor.iconSelected, action: { (isOtherButton) in
                    if isOtherButton {
                        _ = self.navigationController?.popViewController(animated: true)
                    }
                })
            }else{
                self.tableView.reloadData()
            }
        }) { (err) in
            self.showLoading(isShow: false)
            alert.showAlert("Cảnh Báo", subTitle: "Không thể kết nối đến server!", style: AlertStyle.warning, buttonTitle:"Huỷ", buttonColor:UIColor.orange , otherButtonTitle:  "Thử lại", otherButtonColor: UIColor.iconSelected){ (isOtherButton) -> Void in
                if !isOtherButton {
                    self.loadLocation()
                }
            }
            print(err)
        }
    }
    
}

extension LocationController:UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listLocation.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TablleCellLocation.identifier, for: indexPath) as! TablleCellLocation
        if let selectedIndex = selectedIndex{
            cell.imvIcon.isHidden = selectedIndex != indexPath.row
        }else{
            cell.imvIcon.isHidden = true
        }
        cell.lblText.text = listLocation[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! TablleCellLocation
        if let selectedIndex = selectedIndex{
            if let cellOld = tableView.cellForRow(at: IndexPath(item: selectedIndex, section: 0)) as? TablleCellLocation{
                cellOld.imvIcon.isHidden = true
            }
        }
        cell.imvIcon.isHidden = false
        selectedIndex = indexPath.row
    }
}




