//
//  imageRequest.swift
//  MyFirstSlideshow
//
//  Created by Nilofar Vahab poor on 18/10/2017.
//  Copyright © 2017 Yoti. All rights reserved.
//

import UIKit
import Foundation

enum Enum1 : Int {
    case kHTTPSuccess = 200
    case kHTTPCreate = 201
    case kHTTPAccept = 202
    case kHTTPNoContent = 204
    case kHTTPNotAuth = 401
    case kHTTPForbidden = 403
    case kHTTPNotFound = 404
    case kHTTPConflict = 409
    case kHTTPGone = 410
    case kRequestCancel = -1
    case kRequestTimeout = -2
    case kRequestInvalid = -3
}
enum RequestType : Int {
    case kRequestTypeInvalid
    case kRequestTypeGetImages
}

class imageRequest: Operation, NSURLConnectionDataDelegate  {
    
    class func cancelAllRequests() {
    }
    
    class func cancelRequestsOf(_ type: RequestType) {
    }
    
    func downloadImage(ImageWithURL:String , completionBlock: (NSDictionary?) -> Void) {
        
    }
}
