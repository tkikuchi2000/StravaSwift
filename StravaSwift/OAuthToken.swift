//
//  OAuthToken.swift
//  StravaSwift
//
//  Created by Matthew on 11/11/2015.
//  Copyright © 2015 Matthew Clarkson. All rights reserved.
//

import Foundation
import SwiftyJSON

/**
OAuthToken which is required for requesting Strava resources
 **/
public struct OAuthToken: Strava {

    /** The JSON Data **/
    public let json: JSON

    /** The access token **/
    public let accessToken: String?
    
    /** The athlete **/
    public var athlete: Athlete?

    /**
     Initializer
     
     - Parameter json: A SwiftyJSON object
     **/
    public init(_ json: JSON) {
        self.json = json
        accessToken = json["access_token"].string
        athlete = Athlete(json["athlete"])
    }
}
