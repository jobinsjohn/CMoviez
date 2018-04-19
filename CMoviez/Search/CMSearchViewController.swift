//
//  CMSearchViewController.swift
//  CMoviez
//
//  Created by Jobins John on 4/16/18.
//  Copyright © 2018 Jobins John. All rights reserved.
//

import UIKit

import CoreData

import Kingfisher

import Alamofire

import SwiftyJSON


class CMSearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var CMSearchViewMasterViewOutlet: UIView!
    
    @IBOutlet weak var CMSearchViewSrchBarOutlet: UISearchBar!
    
    @IBOutlet weak var CMSearchViewSrchBtnOutlet: UIButton!
    
    @IBOutlet weak var CMSearchViewMovTbOutlet: UITableView!
    
    var startPage       : Int   = 1
    
    var currentPage     : Int   = 0
    
    var totalpageCount  : Int   = 0
    
    var isLoadingData   : Bool  = false
    
    var isShowingLocalDB : Bool = false
    
    var searchTextLocal : String = ""
    
    fileprivate var movNameArr          :   [String]    = []
    
    fileprivate var movRelDateArr       :   [String]    = []
    
    fileprivate var movOvrViewArr       :   [String]    = []
    
    fileprivate var movPosterArr        :   [String]    = []
    
    fileprivate var movRecentHistoryArr :   [String]    = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        CMSearchViewSrchBarOutlet.delegate = self
        
        CMSearchViewMovTbOutlet.keyboardDismissMode = .onDrag
        
        self.addNavBarImage()
        
//        if #available(iOS 10.0, *) {
//            clearDB()
//        }
        
        self.hideKeyboardWhenTappedAround()  // For dismissing Keyboard
    }
    
    override func viewWillAppear(_ animated: Bool) {
        debugPrint("Search View Appeared")
        
        //self.getMovieListFromServerInitial()
    }
    override func viewDidLayoutSubviews() {
        
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
    
    /**
     @brief Clears local values.
     
     @discussion It clears the values that are stored for showing in the search list.
     
     To use it, simply call self.clearLocalData()
     
     @param  Nil.
     
     @return Nil.
     */
    func clearLocalData()
    {
        movNameArr      = []
        
        movRelDateArr   = []
        
        movOvrViewArr   = []
        
        movPosterArr    = []
        
    
    }
     /**
     @brief It converts temperature degrees from Fahrenheit to Celsius scale.
     
     @discussion This method accepts a float value representing the temperature in <b>Fahrenheit</b> scale and it converts it to the <i>Celsius</i> scale.
     
     To use it, simply call @c[self toCelsius: 50];
     
     @param  fromFahrenheit The input value representing the degrees in the Fahrenheit scale.
     
     @return float The degrees in the Celsius scale.
     */
    func clearCountVariables()
    {
        self.startPage       = 1
        
        self.currentPage     = 0
        
        self.totalpageCount  = 0
    }
    
    /*!
     @brief Clears local recent history.
     
     @discussion This method clears the local recent history in the application.
     
     To use it, simply call self.clearRecentHistoryData()
     
     @param Nil.
     
     @return Nil.
     */
    func clearRecentHistoryData()
    {
        movRecentHistoryArr = []
    }
    
    func addNavBarImage() {
        
        let navController = navigationController!
        
        let image = UIImage(named: "navBarImg")
        
        let imageView = UIImageView(image: image)
        
        let bannerWidth = navController.navigationBar.frame.size.width
        
        let bannerHeight = navController.navigationBar.frame.size.height
        
        let bannerX = bannerWidth / 2 - (image?.size.width)! / 2
        
        let bannerY = bannerHeight / 2 - (image?.size.height)! / 2
        
        imageView.frame = CGRect(x: bannerX, y: bannerY, width: bannerWidth, height: bannerHeight)
        
        imageView.contentMode = .scaleAspectFit
        
        navigationItem.titleView = imageView
    }
    
    @available(iOS 10.0, *)
    func addSuccessStringToLocalDB(stringToAdd : String)
    {

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let context = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "SearchHistory", in: context)
        
        let newDataObj = NSManagedObject(entity: entity!, insertInto: context)
        
        let timeStamp = NSDate()
    
        let modifiedInsertString = stringToAdd.replacingOccurrences(of: "%20", with: " ", options: .literal, range: nil)
        
        newDataObj.setValue(modifiedInsertString, forKey: "searchTitle")
        
        newDataObj.setValue(timeStamp, forKey: "timeStamp")

        do {
            try context.save()
        } catch {
            print("Failed saving")
        }
    }
    
    @available(iOS 10.0, *)
    func fetchSearchHistoryFromLocalDB()
    {
        self.clearRecentHistoryData()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "SearchHistory")
        
        let sectionSortDescriptor = NSSortDescriptor(key: "timeStamp", ascending: false)
        
        let sortDescriptors = [sectionSortDescriptor]
        
        request.sortDescriptors = sortDescriptors
        
        request.fetchLimit = 10
        
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject]
            {
                movRecentHistoryArr.append(data.value(forKey: "searchTitle") as! String)
                print(data.value(forKey: "timeStamp") as! Date)
            }
            
        } catch {
            
            print("Failed")
        }
    }
    @available(iOS 10.0, *)
    func clearDB()
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let context = appDelegate.persistentContainer.viewContext
        
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "SearchHistory")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print ("There was an error")
        }
    }
    
    // MARK: - Button Action
    
    @IBAction func CMSearchViewSrchBtnAction(_ sender: UIButton) {
        debugPrint("Search Btn Tapped")
        
        isShowingLocalDB = false
        
        let originalSearchString = self.CMSearchViewSrchBarOutlet.text!
        
        let modifiedSearchString = originalSearchString.replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil)
        
        searchTextLocal = modifiedSearchString
        
        if(searchTextLocal != "")
        {
            self.getMovieListFromServerInitial(searchString: searchTextLocal)
        }
        else
        {
            print("Search empty")
        }
    }
    
    // MARK: - Delegates
    
    //Table View Delegates
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        if (isShowingLocalDB)
        {
            return movRecentHistoryArr.count
        }
        else
        {
            return movNameArr.count
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (isShowingLocalDB)
        {
            let historycell = tableView.dequeueReusableCell(withIdentifier: "recentHistoryCellID", for: indexPath) as! CMSearchRecentHistoryTbCellController
            
            let modifiedDataString = movRecentHistoryArr[indexPath.row].replacingOccurrences(of: "%20", with: " ", options: .literal, range: nil)
            
            historycell.rcntHisMovienameLabelOutlet.text = modifiedDataString
            
            return historycell
        }
        else
        {
        
            let movieCell = tableView.dequeueReusableCell(withIdentifier: "movTbCellID", for: indexPath) as! CMSearchMovTbCellController

            movieCell.moviePosterImageView.kf.indicatorType = .activity
        
            let imgURL       =   URL(string: APP_IMG_URL + movPosterArr[indexPath.row])
        
            if(movPosterArr[indexPath.row] == "")
            {
                movieCell.moviePosterImageView.image = UIImage(named: "noImagePH")
                
            }
            else
            {
                movieCell.moviePosterImageView.kf.setImage(with: imgURL)
            }
        
            movieCell.movieNameLabel.text = movNameArr[indexPath.row]
        
            movieCell.movieReleaseDateLabel.text = "Release Date : "+movRelDateArr[indexPath.row]
        
            movieCell.movieOverviewLabel.text = movOvrViewArr[indexPath.row]
        
            movieCell.movieNameLabel.sizeToFit()
        
            movieCell.movieOverviewLabel.sizeToFit()
       
            return movieCell
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (isShowingLocalDB)
        {return}
        
        let lastElement = movNameArr.count - 1
        if indexPath.row == lastElement {
            // handle your logic here to get more items, add it to dataSource and reload tableview
            self.getMovieListFromServerLoadMore(searchStringMore: searchTextLocal)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(isShowingLocalDB)
        {
            let cellTapped = tableView.cellForRow(at: indexPath) as! CMSearchRecentHistoryTbCellController
            
            let stringSel = cellTapped.rcntHisMovienameLabelOutlet.text
            
            tableView.deselectRow(at: indexPath, animated: true)
            
            self.CMSearchViewSrchBarOutlet.text = stringSel
            
            self.getMovieListFromServerInitial(searchString: stringSel!)
            
        }
        else
        {
            tableView.deselectRow(at: indexPath, animated: false)
        }
    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if(isShowingLocalDB){
//            return 25.0
//        }else{return 0.0}
//    }
//
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 160.0
//    }
    
    //Search Bar Delegates
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(CMSearchViewSrchBarOutlet.text!)
    }
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        print(text)
        
        if (CMSearchViewSrchBarOutlet.text?.count == 0)
        {
            print("While entering the characters this method gets called")
            
            self.clearLocalData()
            
            self.CMSearchViewMovTbOutlet.reloadData()
            
        }
        let cs = NSCharacterSet(charactersIn: ACCEPTABLE_CHARACTERS).inverted
        
        let filteredSearchText = text.components(separatedBy: cs).joined(separator: "")
        
        return (text == filteredSearchText)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        //searchActive = true;
        if (CMSearchViewSrchBarOutlet.text?.count == 0)
        {
            print("While entering the characters this method gets called")
            if #available(iOS 10.0, *) {
                isShowingLocalDB = true
                fetchSearchHistoryFromLocalDB()
            }
            self.clearLocalData()
            
            self.CMSearchViewMovTbOutlet.reloadData()
        }
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        //searchActive = false;
        print(CMSearchViewSrchBarOutlet.text!)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        //searchActive = false;
        if #available(iOS 10.0, *) {
            isShowingLocalDB = true
            fetchSearchHistoryFromLocalDB()
        }
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //searchActive = false;
        print(CMSearchViewSrchBarOutlet.text!)
    }
    
    func searchBarResultsListButtonClicked(_ searchBar: UISearchBar) {
        print(CMSearchViewSrchBarOutlet.text!)
    }
    
    
    // MARK: - API Calls


    func getMovieListFromServerInitial(searchString : String)
    {
        self.clearLocalData()

        self.currentPage = startPage

        isLoadingData = true
        
        if #available(iOS 10.0, *) {
            self.fetchSearchHistoryFromLocalDB()
        } else {
            debugPrint("Cant Fetch Data as not availaaible")
        }

        let webURL: String  =   "http://api.themoviedb.org/3/search/movie?api_key="+SERVER_API_TOKEN+"&query="+searchString+"&page="+String(startPage)//APP_BASE_URL + DASHBOARD_PRODUCT_ALL_API
        print(webURL)
        Alamofire.request(webURL).validate().responseJSON { response in
            switch response.result {
            case .success:
                print("Validation Successful")
                if let json = response.result.value
                {
                    let jsonObj  = JSON(json)

                    if let resultsArray = jsonObj["results"].arrayValue as [JSON]?
                    {
                        self.totalpageCount = jsonObj["total_pages"].intValue

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
                            //Insert Search String into CoreData Data Base
                            
                            if #available(iOS 10.0, *) {
                                self.addSuccessStringToLocalDB(stringToAdd: searchString)
                            } else {
                                debugPrint("Local DB not availaible")
                            }
                        }
                    }
                    self.isLoadingData = false
                }

            case .failure(let error):
                self.isLoadingData = false
                print(error)
            }
        }
    }
    func getMovieListFromServerLoadMore(searchStringMore : String)
    {
        //self.clearLocalData()
        if(isLoadingData){
            return
        }
        self.currentPage = currentPage + 1
        
        self.isLoadingData = true
        
        if(self.currentPage <= self.totalpageCount)
        {
            let webURL: String  =   "http://api.themoviedb.org/3/search/movie?api_key="+SERVER_API_TOKEN+"&query="+searchStringMore+"&page="+String(self.currentPage)//APP_BASE_URL + DASHBOARD_PRODUCT_ALL_API
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
                    
                        self.isLoadingData = false
                    }
                
                case .failure(let error):
                    print(error)
                    self.isLoadingData = false
                }
            }
        }
        else
        {
            print("No more data to load")
            self.isLoadingData = false
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
