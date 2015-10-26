//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Scott Baumbich on 10/1/15.
//  Copyright © 2015 Glazed. All rights reserved.
//

import Foundation

class RecordedAudio {
    
    var filePathUrl: NSURL!
    var title: String!
    
    init(filePathUrl: NSURL, title: String){
        self.filePathUrl = filePathUrl
        self.title = title
    }
}
