//
//  App-Constants.swift
//  CMoviez
//
//  Created by Jobins John on 4/15/18.
//  Copyright © 2018 Jobins John. All rights reserved.
//

import Foundation

import UIKit

// MARK: - URL's

let APP_BASE_URL                        =   "http://api.themoviedb.org/"

let APP_IMG_URL                         =   "http://image.tmdb.org/t/p/w185"

// MARK: - APP Titles

let APP_NAME                            =   "CFlix"

// MARK: - APP Token keys
let SERVER_API_TOKEN                    =   "2696829a81b1b5827d515ff121700838"//"2696829a81b1b5827d515ff121700838"

// MARK: - View Titles

let SEARCH_VIEW_TITLE                   =   "Login"

// MARK: - API List's

let SEARCH_MOVIE_API                    =   "3/search/movie"

// MARK: - App Value Constants

let AUTH_TOKEN_LOCAL                    =   "authtoken"
let LOGIN_TOKEN_LOCAL                   =   "loginUserStatus"
let DEVICE_ID                           =   "deviceId"

// MARK: - Segue ID lists

let LOGIN_TO_REGISTER_SEGUE             =   "loginToRegisterViewSegue"
let LOGIN_TO_DASHBOARD_SEGUE            =   "loginToDashSegue"

// MARK: - Store APP Status codes
let USER_REGISTER_ERROR_CODE            =   "995"
let INVALID_USER_PASSWORD_ERROR_CODE    =   "996"

//ERROR MESSAGES
let UNEXPECTED_ERROR_ALERT              =   "Something unexpected happened. We are trying to fix it as soon as possible."
let SERVICE_TEMP_UNAVAILAIBLE_ALERT     =   "Service is temporarily unavailaible. We are working to fix it as soon as possible."
let SERVER_DOWN_ERROR_ALERT             =   "Holy...Moly... We just blew a fuse... Need more amps... We will be back shortly..."
let EMPTY_SRCH_FIELD_ERROR_ALL          =   "All fields should be filled"
let NO_NETWORK_ALERT_MSG                =   "You are not connected to internet. Please check your connectivity"
let NO_MORE_DATA_MSG                =   "You are not connected to internet. Please check your connectivity"

// ACCEPTABLE CHARACTERS
let ACCEPTABLE_CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789 "
