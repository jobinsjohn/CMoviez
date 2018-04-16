//
//  CMSearchViewController.swift
//  CMoviez
//
//  Created by Jobins John on 4/16/18.
//  Copyright © 2018 Jobins John. All rights reserved.
//

import UIKit

class CMSearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

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
    }
    
    // MARK: - Delegates
    
    //Table View Delegates
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 10
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let movieCell = tableView.dequeueReusableCell(withIdentifier: "movTbCellID", for: indexPath) as! CMSearchMovTbCellController
//
//        movieCell.moviePosterImageView.kf.indicatorType = .activity
//
//        let imgURL       =   URL(string: APP_IMG_URL + "/kBf3g9crrADGMc2AMAMlLBgSm2h.jpg")

        //rmovieCell.moviePosterImageView.kf.setImage(with: imgURL)
        
        movieCell.movieNameLabel.text = "Batman"
        
        movieCell.movieReleaseDateLabel.text = "Release Date : 1989-06-23"
        
        movieCell.movieOverviewLabel.text = "The Dark Knight of Gotham City begins his war on crime with his first major enemy being the clownishly homicidal Joker, who has seized control of Gotham's underworld."
        
        return movieCell
    }
    
    
    //Search Bar Delegates
    
    
    // MARK: - API Calls
    
//    func getMovieListFromServerInitial()
//    {
//        self.clearLocalData()
//        let webURL: String  =   "http://api.themoviedb.org/3/search/movie?api_key="+SERVER_API_TOKEN+"&query=batman&page="+String(startPage)//APP_BASE_URL + DASHBOARD_PRODUCT_ALL_API
//        print(webURL)
//        Alamofire.request(webURL).validate().responseJSON { response in
//            switch response.result {
//            case .success:
//                print("Validation Successful")
//                if let json = response.result.value
//                {
//                    let jsonObj  = JSON(json)
//
//                    //print(jsonObj)
//                    if let resultsArray = jsonObj["results"].arrayValue as [JSON]?
//                    {
//                        print(resultsArray.count)
//                        if(resultsArray.count > 0)
//                        {
//                            for index in 0...resultsArray.count-1
//                            {
//
//                                self.movNameArr.append(resultsArray[index]["original_title"].stringValue)
//
//                                self.movRelDateArr.append(resultsArray[index]["release_date"].stringValue)
//
//                                self.movPosterArr.append(resultsArray[index]["poster_path"].stringValue)
//
//                                self.movOvrViewArr.append(resultsArray[index]["overview"].stringValue)
//
//                                self.CMSearchViewMovTbOutlet.reloadData()
//                            }
//                        }
//                    }
//
//                }
//
//            case .failure(let error):
//                print(error)
//            }
//        }
//
//
//    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
