//
//  FilmController.swift
//  Cinema 2.0
//
//  Created by Trần Hoàng Lâm on 3/7/17.
//  Copyright © 2017 Trần Hoàng Lâm. All rights reserved.
//

import UIKit
import iCarousel
import MIBlurPopup

class FilmController:BaseViewController{
    
    var listFilm:[Film] = []
    var listFilmIsShow:[Film] = []
    var listFilmNotShow:[Film] = []
    var show = true
    var pageIsShow = 1
    var totalPageIsShow = 0
    var pageNotShow = 1
    var totalPageNotShow = 0
    var page = 1
    var totalPage = 0
    var loading = false
    var slideFilm:SlideFilm!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.addRefreshButton()
        super.addNotifyButton()
        self.setupNavigationSegmented()
        self.addSubView()
        self.view.isHidden = true
        self.showLoading(isShow: true)
        self.loadData()
        listFilm = show ? listFilmIsShow : listFilmNotShow
        page = show ? pageIsShow : pageNotShow
        totalPage = show ? totalPageIsShow : totalPageNotShow
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if listFilm.count > 0, let url = listFilm[slideFilm.slide.currentItemIndex].linkPoster{
            self.setBackgroundImage(strURL: url)
//            self.slideFilm.btnHeart.select()
//            self.slideFilm.btnHeart.isSelected = ManagerUser.user.isLikeFilm(id: listFilm[slideFilm.slide.currentItemIndex].id!)
        }
    }
    
}

extension FilmController{
    override func loadData() {
        if !loading{
            self.loading = true
            let isShow = show
            ManagerData.share.getListFilm(show: isShow, page: isShow ? pageIsShow : pageNotShow, success: { (listFilm, totalPage) in
                if listFilm.count < 1 {
                    _ = alert.showAlert("Thông Báo", subTitle: "Không có dữ liệu!", style: AlertStyle.warning, buttonTitle:"OK", buttonColor: UIColor.iconSelected)
                }else{
                    self.view.isHidden = false
//                    self.slideFilm.btnHeart.select()
                    if isShow{
                        self.listFilmIsShow += listFilm
                        self.page = self.pageIsShow
                        self.totalPageIsShow = totalPage
                        self.pageIsShow += 1
                    }else{
                        self.listFilmNotShow += listFilm
                        self.page = self.pageNotShow
                        self.totalPageNotShow = totalPage
                        self.pageNotShow += 1
                    }
                    self.listFilm = self.show ? self.listFilmIsShow : self.listFilmNotShow
                    self.page = self.show ? self.pageIsShow : self.pageNotShow
                    self.totalPage = self.show ? self.totalPageIsShow : self.totalPageNotShow
                    self.slideFilm.slide.reloadData()
                    self.loadSlideFilm()
                }
                self.loading = false
                self.showLoading(isShow: false)
            }, fail: { (error) in
                self.loading = false
                self.showLoading(isShow: false)
                alert.showAlert("Cảnh Báo", subTitle: "Không thể kết nối đến server!", style: AlertStyle.warning, buttonTitle:"Huỷ", buttonColor:UIColor.orange , otherButtonTitle:  "Thử lại", otherButtonColor: UIColor.iconSelected){ (isOtherButton) -> Void in
                    if !isOtherButton {
                        self.loadData()
                    }
                }
            })
        }
    }
    
    func setupNavigationSegmented(){
        let navigationSegmented = BetterSegmentedControl(
            frame: CGRect(x: 0, y: 0, width: 200.0, height: 30.0),
            titles: ["Đang Chiếu", "Sắp Chiếu"],
            index: 0,
            backgroundColor: UIColor.iconSelected,
            titleColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),
            indicatorViewBackgroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),
            selectedTitleColor: UIColor.iconSelected)
        navigationSegmented.cornerRadius = 15
        navigationSegmented.titleFont = UIFont(name: AppConstants.FontName.semibold, size: 13)!
        navigationSegmented.selectedTitleFont = UIFont(name: AppConstants.FontName.semibold, size: 14)!
        navigationSegmented.addTarget(self, action: #selector(FilmController.segmentedChange(_:)), for: .valueChanged)
        self.navigationItem.titleView = navigationSegmented
    }
    
    func segmentedChange(_ sender: BetterSegmentedControl) {
        show = sender.index == 0
        listFilm = show ? listFilmIsShow : listFilmNotShow
        page = show ? pageIsShow : pageNotShow
        totalPage = show ? totalPageIsShow : totalPageNotShow
        if !show && pageNotShow == 1{
            showLoading(isShow: true)
            loadData()
        }
        if let slideFilm = self.slideFilm{
            slideFilm.slide.reloadData()
        }
        if (show && listFilmIsShow.count > 0) || (!show && listFilmNotShow.count > 0){
            slideFilm.slide.currentItemIndex = 0
            loadSlideFilm()
        }
    }
    
    override func addSubView() {
        super.addSubView()
        self.slideFilm = SlideFilm()
        self.slideFilm.delegate = self
        self.slideFilm.slide.delegate = self
        self.slideFilm.slide.dataSource = self
        self.view.addViewWithContrains(VSFormat: "H:|[v0]|", views: self.slideFilm)
        self.slideFilm.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor).isActive = true
        self.slideFilm.bottomAnchor.constraint(equalTo: self.bottomLayoutGuide.topAnchor).isActive = true
    }
    
    override func actionRefreshButton() {
        if show{
            listFilmIsShow = []
            pageIsShow = 1
            totalPageIsShow = 0
        }else{
            listFilmNotShow = []
            pageNotShow = 1
            totalPageNotShow = 0
        }
        showLoading(isShow: true)
        if self.slideFilm != nil{
            self.slideFilm.slide.reloadData()
        }
        self.loadData()
    }
    
    func loadSlideFilm(){
        let i = self.slideFilm.slide.currentItemIndex
        if i >= 0 && i < self.listFilm.count{
            if let strURL = listFilm[i].linkPoster{
                self.setBackgroundImage(strURL: strURL)
            }
            self.slideFilm.film = listFilm[i]
            self.slideFilm.lblName.text = "\(i+1).\(listFilm[i].name!)"
            if let user = ManagerUser.user{
                self.slideFilm.btnHeart.select()
                self.slideFilm.btnHeart.isSelected = user.isLikeFilm(id: listFilm[i].id!)
            }
            self.slideFilm.segmentedClassification.setTitle(self.listFilm[i].classification, forSegmentAt: 1)
            self.slideFilm.segmentedIMDB.setTitle("\(self.listFilm[i].imdb!)", forSegmentAt: 1)
            if let premiere = self.listFilm[i].premiere{
                self.slideFilm.lblPremiere.text =   "Khởi chiếu : \(premiere.toString(stringFormat: "dd/MM/yyyy"))"
            }
            self.slideFilm.lblLength.text =     "Thời lượng : \(self.listFilm[i].length!)"
            self.slideFilm.lblGenre.text =      "Thể loại    : \(self.listFilm[i].genre!)"
            self.slideFilm.lblActor.text =      "Diễn viên  : \(self.listFilm[i].actor!)"
            self.slideFilm.lblDirector.text =   "Đạo diễn   : \(self.listFilm[i].director!)"
            self.slideFilm.lblCountry.text =    "Quốc gia   : \(self.listFilm[i].country!)"
            self.slideFilm.lblIntro.text = self.listFilm[i].intro!
            self.slideFilm.scrollView.setContentOffset(CGPoint.zero, animated: true)
        }
    }
    
}

extension FilmController:iCarouselDelegate, iCarouselDataSource, SlideFilmDelegate{
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        return self.listFilm.count
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        let slideItem = SlideItem(frame: CGRect(x: 2, y: 2, width: self.view.frame.width/2 - 4, height: (self.view.frame.width/2)*(4/3)-4))
            slideItem.film = listFilm[index]
        return slideItem
    }
    
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        if (option == .spacing) {
            return value * 1.1
        }
        return value
    }
    
    func carouselCurrentItemIndexDidChange(_ carousel: iCarousel) {
        self.loadSlideFilm()
        if carousel.currentItemIndex >= listFilm.count-5 && self.page <= self.totalPage{
            self.loadData()
        }
    }
    
    func carousel(_ carousel: iCarousel, didSelectItemAt index: Int) {
        if carousel.currentItemIndex == index{
            self.loadTrailer()
        }
    }
    
    func loadSchedule() {
//        self.slideFilm.isHidden = true
//        self.scheduleController = ScheduleForFilmController()
//        self.scheduleController.idFilm = self.listFilm[self.slideFilm.slide.currentItemIndex].id
//        self.navigationController?.pushViewController(self.scheduleController, animated: true)
        let schedule = ScheduleFilm()
        schedule.film = self.listFilm[self.slideFilm.slide.currentItemIndex]
        self.navigationController?.pushViewController(schedule, animated: true)
    }
    
    func loadTrailer() {
        if let url = URL(string: self.listFilm[self.slideFilm.slide.currentItemIndex].linkTrailer!){
            let trailer = WebViewTrailer()
            trailer.url = url
            MIBlurPopup.show(trailer, on: self.tabBarController!)
        }else{
            _ = alert.showAlert("Thông Báo", subTitle: "Trailer phim chưa được cập nhật!", style: AlertStyle.warning, buttonTitle:"OK", buttonColor: UIColor.iconSelected)
        }
    }
    
}

