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

import NotificationBannerSwift

class CMSearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    /// This variable references the Master View.
    @IBOutlet weak var CMSearchViewMasterViewOutlet: UIView!
    /// This variable references the Search Bar in the  View.
    @IBOutlet weak var CMSearchViewSrchBarOutlet: UISearchBar!
    /// This variable references the the Search button in the View.
    @IBOutlet weak var CMSearchViewSrchBtnOutlet: UIButton!
    /// This variable references the table view in which search results are shown.
    @IBOutlet weak var CMSearchViewMovTbOutlet: UITableView!
    /// This variable holds the start page value.
    var startPage: Int = 1
    /// This variable holds the current page value.
    var currentPage: Int = 0
    /// This variable holds the total page count.
    var totalpageCount: Int = 0
    /// This variable holds the loading state of API. It holds a Boolean value.
    var isLoadingData: Bool = false
    /// This variable shows whether the data shown is recent history or not. It holds a Boolean value.
    var isShowingLocalDB: Bool = false
    /// This variable holds the search text from search bar.
    var searchTextLocal: String = ""
    /// This array holds the movie names that are returned from API.
    fileprivate var movNameArr: [String] = []
    /// This array holds the movie release date that are returned from API.
    fileprivate var movRelDateArr: [String] = []
    /// This array holds the movie overview that are returned from API.
    fileprivate var movOvrViewArr: [String] = []
    /// This array holds the movie poster path links that are returned from API.
    fileprivate var movPosterArr: [String] = []
    /// This array holds the movie names that the user searched and they are returned from Local DB.
    fileprivate var movRecentHistoryArr: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        CMSearchViewSrchBarOutlet.delegate = self
        CMSearchViewMovTbOutlet.keyboardDismissMode = .onDrag

        self.addNavBarImage()
        /*if #available(iOS 10.0, *) {
            clearDB()
        }*/
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
    // MARK: - Custom functions
    /**
     @brief Clears local values.
     
     @discussion It clears the values that are stored for showing in the search list.
     
     To use it, simply call self.clearLocalData()
     
     @param  Nil.
     
     @return Nil.
     */
    func clearLocalData(){
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
    func clearCountVariables(){
        self.startPage       = 1
        self.currentPage     = 0
        self.totalpageCount  = 0
    }
    /**
     @brief Clears local recent history.
     
     @discussion This method clears the local recent history in the application.
     
     To use it, simply call self.clearRecentHistoryData()
     
     @param Nil.
     
     @return Nil.
     */
    func clearRecentHistoryData(){
        movRecentHistoryArr = []
    }
    /**
     @brief Adds image to Navigation Bar.
     
     @discussion Adds custom Nav Bar Image to the View
     
     To use it, simply call self.addNavBarImage()
     
     @param Nil.
     
     @return Nil.
     */
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
    /**
     @brief Add string to Local DB.
     
     @discussion If the search was success with more than 0 records then that Search String is added to the Local DB to be made availaible for showing recent search history
     
     To use it, simply call self.addSuccessStringToLocalDB(stringToAdd : <String to be passed>)
     
     @param Search String
     
     @return Nil.
     */
    @available(iOS 10.0, *)
    func addSuccessStringToLocalDB(stringToAdd : String){
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let context = appDelegate?.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "SearchHistory", in: context!)
        let newDataObj = NSManagedObject(entity: entity!, insertInto: context)
        let timeStamp = NSDate()
        let modifiedInsertString = stringToAdd.replacingOccurrences(of: "%20", with: " ", options: .literal, range: nil)
        newDataObj.setValue(modifiedInsertString, forKey: "searchTitle")
        newDataObj.setValue(timeStamp, forKey: "timeStamp")
        do {
            try context!.save()
        } catch {
            print("Failed saving")
        }
    }
    /**
     @brief Reads search string from Local DB.
     
     @discussion Reads the search strings from database and is shown in recent history part. This function returns only the latest 10 records
     
     To use it, simply call self.fetchSearchHistoryFromLocalDB()
     
     @param Nil.
     
     @return Nil.
     */
    @available(iOS 10.0, *)
    func fetchSearchHistoryFromLocalDB(){
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
    /**
     @brief Clears Local DB.
     
     @discussion Used to clear local DB. This method is for testing purpose.
     
     To use it, simply call clearDB()
     
     @param Nil.
     
     @return Nil.
     */
    @available(iOS 10.0, *)
    func clearDB(){
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
        if(searchTextLocal != ""){
            if(Connectivity.isConnectedToInternet()){
                self.getMovieListFromServerInitial(searchString: searchTextLocal)
            }else {
                let banner = NotificationBanner(title: APP_NAME, subtitle: NO_NETWORK_ALERT_MSG, style: .warning)
                banner.show()
                debugPrint("Not connected to internet")
            }
        } else {
            let banner = NotificationBanner(title: APP_NAME, subtitle: EMPTY_SRCH_FIELD_ERROR, style: .warning)
            banner.show()
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
        if (isShowingLocalDB) {
            return movRecentHistoryArr.count
        } else {
            return movNameArr.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (isShowingLocalDB) {
            let historycell = tableView.dequeueReusableCell(withIdentifier: "recentHistoryCellID", for: indexPath) as! CMSearchRecentHistoryTbCellController
            let modifiedDataString = movRecentHistoryArr[indexPath.row].replacingOccurrences(of: "%20", with: " ", options: .literal, range: nil)
            historycell.selectionStyle = .none
            historycell.rcntHisMovienameLabelOutlet.text = modifiedDataString
            return historycell
        } else {
            let movieCell = tableView.dequeueReusableCell(withIdentifier: "movTbCellID", for: indexPath) as! CMSearchMovTbCellController
            movieCell.moviePosterImageView.kf.indicatorType = .activity
            let imgURL       =   URL(string: APP_IMG_URL + movPosterArr[indexPath.row])
            if(movPosterArr[indexPath.row] == "") {
                movieCell.moviePosterImageView.image = UIImage(named: "noImagePH")
            } else {
                movieCell.moviePosterImageView.kf.setImage(with: imgURL)
            }
            movieCell.movieNameLabel.text = movNameArr[indexPath.row]
            if(movRelDateArr[indexPath.row] == "") {
                movieCell.movieReleaseDateLabel.text = "Release Date : Not Available"
            } else {
               movieCell.movieReleaseDateLabel.text = "Release Date : "+movRelDateArr[indexPath.row]
            }
            if(movOvrViewArr[indexPath.row] == "") {
                movieCell.movieOverviewLabel.text = "Overview Not Available"
            } else {
                movieCell.movieOverviewLabel.text = movOvrViewArr[indexPath.row]
            }
            movieCell.selectionStyle = .none
            movieCell.movieNameLabel.sizeToFit()
            movieCell.movieOverviewLabel.sizeToFit()
            return movieCell
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (isShowingLocalDB)
        { return }
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
        } else {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }

    //Search Bar Delegates
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(CMSearchViewSrchBarOutlet.text!)
    }
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (CMSearchViewSrchBarOutlet.text?.count == 0) {
            self.clearLocalData()
            self.CMSearchViewMovTbOutlet.reloadData()
        }
        let cs = NSCharacterSet(charactersIn: ACCEPTABLE_CHARACTERS).inverted
        let filteredSearchText = text.components(separatedBy: cs).joined(separator: "")
        return (text == filteredSearchText)
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if (CMSearchViewSrchBarOutlet.text?.count == 0) {
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
    func getMovieListFromServerInitial(searchString : String) {
        self.clearLocalData()
        UIApplication.shared.beginIgnoringInteractionEvents()
        self.currentPage = startPage
        isLoadingData = true
        if #available(iOS 10.0, *) {
            self.fetchSearchHistoryFromLocalDB()
        } else {
            debugPrint("Cant Fetch Data as not availaaible")
        }

        let webURL: String  =   "http://api.themoviedb.org/3/search/movie?api_key="+SERVER_API_TOKEN+"&query="+searchString+"&page="+String(startPage)
        Alamofire.request(webURL).validate().responseJSON { response in
            switch response.result {
            case .success:
                print("Validation Successful")
                if let json = response.result.value {
                    let jsonObj  = JSON(json)
                    if let resultsArray = jsonObj["results"].arrayValue as [JSON]? {
                        self.totalpageCount = jsonObj["total_pages"].intValue
                        if(resultsArray.count > 0) {
                            for index in 0...resultsArray.count-1 {
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
                        } else {
                            self.CMSearchViewMovTbOutlet.reloadData()
                            self.CMSearchViewSrchBarOutlet.text = ""
                            CFlixDefaultWrappers().showAlert(info: NO_DATA_FOUND_MSG, viewController: self)
                        }
                    }
                    self.isLoadingData = false
                    UIApplication.shared.endIgnoringInteractionEvents()
                }

            case .failure(let error):
                self.isLoadingData = false
                UIApplication.shared.endIgnoringInteractionEvents()
                debugPrint(error)
                CFlixDefaultWrappers().showAlert(info: SERVER_DOWN_ERROR_ALERT, viewController: self)
            }
        }
    }
    func getMovieListFromServerLoadMore(searchStringMore: String)
    {
        if(isLoadingData){
            return
        }
        self.currentPage = currentPage + 1
        UIApplication.shared.beginIgnoringInteractionEvents()
        self.isLoadingData = true
        if(self.currentPage <= self.totalpageCount) {
            let webURL: String  =   "http://api.themoviedb.org/3/search/movie?api_key="+SERVER_API_TOKEN+"&query="+searchStringMore+"&page="+String(self.currentPage)

            Alamofire.request(webURL).validate().responseJSON { response in
                switch response.result {
                case .success:
                    if let json = response.result.value {
                        let jsonObj  = JSON(json)
                        if let resultsArray = jsonObj["results"].arrayValue as [JSON]? {
                            if( resultsArray.count > 0 ) {
                                for index in 0...resultsArray.count-1 {
                                    self.movNameArr.append(resultsArray[index]["original_title"].stringValue)
                                    self.movRelDateArr.append(resultsArray[index]["release_date"].stringValue)
                                    self.movPosterArr.append(resultsArray[index]["poster_path"].stringValue)
                                    self.movOvrViewArr.append(resultsArray[index]["overview"].stringValue)
                                    self.CMSearchViewMovTbOutlet.reloadData()
                                }
                            }
                        }
                        self.isLoadingData = false
                        UIApplication.shared.endIgnoringInteractionEvents()
                    }
                case .failure(let error):
                    print(error)
                    self.isLoadingData = false
                    UIApplication.shared.endIgnoringInteractionEvents()
                }
            }
        } else {
            self.isLoadingData = false
            UIApplication.shared.endIgnoringInteractionEvents()
            CFlixDefaultWrappers().showAlert(info: SERVER_DOWN_ERROR_ALERT, viewController: self)
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
