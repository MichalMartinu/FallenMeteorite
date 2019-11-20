//
//  AppStrings.swift
//  FallenMeteorite
//
//  Created by Michal Martinů on 20/11/2019.
//  Copyright © 2019 Michal Martinů. All rights reserved.
//

import Foundation

enum AppStrings: String {
    
    case loadingHeader = "Meteorites are loading"
    case loadingMessage = "While this app is loading I would like to tell you:\nHave a good day! :)"
    
    case emptyHeader = "No meteorites to show"
    case emptyMessage = "We can't find any meteorites in database. :("
    
    case errorHeader = "Error when loading data"
    
    case offlineHeader = "You are Offline"
    case offlineMessage = "Please check your internet connection and try it again."
    
    case tryAgain = "Try again"

    case introductionHeader = "Welcome to fallen meteorite"
    case introductionMessage = "This application would show you fallen meteorites on Earth since year 2011 sorted by weight descending. Application updates data automatically."
    case thatIsCool = "That is cool"

    case recclass = "Recclass"
    case mass = "Mass"
    case fall = "Fall"
    case latitude = "Latitude"
    case longitude = "Longitude"
}
