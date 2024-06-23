//
//  Apikey.swift
//  Houdini
//
//  Created by Shyngys on 6/22/24.
//

import Foundation

enum
ApiKey {
    // Fetch the API key from 'GenerativeAI-Info plist'
    static var `default`: String {
        guard let filePath = Bundle.main.path(forResource: "Gemunoapi", ofType: "plist")
        else {
            fatalError( "Couldn't find file 'GenerativeAI-Info.plist' .")
        }
        let plist = NSDictionary(contentsOfFile: filePath)
        guard let value = plist?.object(forKey: "API_KEY") as? String else {
            fatalError ("Couldn't find key 'API_KEY' in 'GenerativeAI-Info-plist' .")
        }
        if value.starts(with: "-"){
            fatalError (
                "Follow the instructions at https://ai.google.dev/tutorials/setup to get an API key."
            )
        }
        return value
    }
}
