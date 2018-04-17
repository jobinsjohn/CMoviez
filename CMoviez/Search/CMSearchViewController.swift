//
//  CMSearchViewController.swift
//  CMoviez
//
//  Created by Jobins John on 4/16/18.
//  Copyright © 2018 Jobins John. All rights reserved.
//

import UIKit

import Kingfisher

import Alamofire

import SwiftyJSON

import IQKeyboardManagerSwift


class CMSearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var CMSearchViewMasterViewOutlet: UIView!
    
    @IBOutlet weak var CMSearchViewSrchBarOutlet: UISearchBar!
    
    @IBOutlet weak var CMSearchViewSrchBtnOutlet: UIButton!
    
    @IBOutlet weak var CMSearchViewMovTbOutlet: UITableView!
    
    var startPage       : Int   = 1
    
    var currentPage     : Int   = 0
    
    var totalpageCount  : Int   = 0
    
    var isLoadingData   : Bool  = false
    
    fileprivate var movNameArr        :   [String]    = []
    
    fileprivate var movRelDateArr     :   [String]    = []
    
    fileprivate var movOvrViewArr     :   [String]    = []
    
    fileprivate var movPosterArr      :   [String]    = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        CMSearchViewSrchBarOutlet.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        debugPrint("Search View Appeared")
        
        //self.getMovieListFromServerInitial()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UI functions
    
    func setCMSearchUI()
    {
        
    }
    
    // MARK: - Custom functions
    
    func clearLocalData()
    {
        movNameArr      = []
        
        movRelDateArr   = []
        
        movOvrViewArr   = []
        
        movPosterArr    = []
    }
    
    // MARK: - Button Action
    
    @IBAction func CMSearchViewSrchBtnAction(_ sender: UIButton) {
        debugPrint("Search Btn Tapped")
        self.getMovieListFromServerInitial()
    }
    
    // MARK: - Delegates
    
    //Table View Delegates
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return movNameArr.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let movieCell = tableView.dequeueReusableCell(withIdentifier: "movTbCellID", for: indexPath) as! CMSearchMovTbCellController

        movieCell.moviePosterImageView.kf.indicatorType = .activity

        let imgURL       =   URL(string: APP_IMG_URL + movPosterArr[indexPath.row])

        movieCell.moviePosterImageView.kf.setImage(with: imgURL)
        
        movieCell.movieNameLabel.text = movNameArr[indexPath.row]
        
        movieCell.movieReleaseDateLabel.text = "Release Date : "+movRelDateArr[indexPath.row]
        
        movieCell.movieOverviewLabel.text = movOvrViewArr[indexPath.row]
       
        return movieCell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastElement = movNameArr.count - 1
        if indexPath.row == lastElement {
            // handle your logic here to get more items, add it to dataSource and reload tableview
            self.getMovieListFromServerLoadMore()
        }
    }
    
    
    //Search Bar Delegates
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        //searchActive = true;
        print(searchBar.text!)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        //searchActive = false;
        print(searchBar.text!)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        //searchActive = false;
        print(searchBar.text!)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //searchActive = false;
        print(searchBar.text!)
    }
    
    // MARK: - API Calls
    
    func getMovieListFromServerInitial()
    {
        self.clearLocalData()
        
        self.currentPage = startPage
        
        let webURL: String  =   "http://api.themoviedb.org/3/search/movie?api_key="+SERVER_API_TOKEN+"&query=batman&page="+String(startPage)//APP_BASE_URL + DASHBOARD_PRODUCT_ALL_API
        print(webURL)
        Alamofire.request(webURL).validate().responseJSON { response in
            switch response.result {
            case .success:
                print("Validation Successful")
                if let json = response.result.value
                {
                    let jsonObj  = JSON(json)

                    //print(jsonObj)
                    if let resultsArray = jsonObj["results"].arrayValue as [JSON]?
                    {
                        print(resultsArray.count)
                        if(resultsArray.count > 0)
                        {
                            for index in 0...resultsArray.count-1
                            {

                                self.movNameArr.append(resultsArray[index]["original_title"].stringValue)

                                self.movRelDateArr.append(resultsArray[index]["release_date"].stringValue)

                                self.movPosterArr.append(resultsArray[index]["poster_path"].stringValue)

                                self.movOvrViewArr.append(resultsArray[index]["overview"].stringValue)

                                self.CMSearchViewMovTbOutlet.reloadData()
                            }
                        }
                    }

                }

            case .failure(let error):
                print(error)
            }
        }


    }
    func getMovieListFromServerLoadMore()
    {
        //self.clearLocalData()
        
        self.currentPage = currentPage + 1
        
        let webURL: String  =   "http://api.themoviedb.org/3/search/movie?api_key="+SERVER_API_TOKEN+"&query=batman&page="+String(self.currentPage)//APP_BASE_URL + DASHBOARD_PRODUCT_ALL_API
        print(webURL)
        Alamofire.request(webURL).validate().responseJSON { response in
            switch response.result {
            case .success:
                print("Validation Successful")
                if let json = response.result.value
                {
                    let jsonObj  = JSON(json)
                    
                    //print(jsonObj)
                    if let resultsArray = jsonObj["results"].arrayValue as [JSON]?
                    {
                        print(resultsArray.count)
                        if(resultsArray.count > 0)
                        {
                            for index in 0...resultsArray.count-1
                            {
                                
                                self.movNameArr.append(resultsArray[index]["original_title"].stringValue)
                                
                                self.movRelDateArr.append(resultsArray[index]["release_date"].stringValue)
                                
                                self.movPosterArr.append(resultsArray[index]["poster_path"].stringValue)
                                
                                self.movOvrViewArr.append(resultsArray[index]["overview"].stringValue)
                                
                                self.CMSearchViewMovTbOutlet.reloadData()
                                //self.CMSearchViewMovTbOutlet.reloadData()
                            }
                        }
                    }
                    
                }
                
            case .failure(let error):
                print(error)
            }
        }
        
        
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
