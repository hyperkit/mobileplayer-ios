//
//  Youtube.swift
//  MovielalaPlayer
//
//  Created by Toygar Dündaralp on 09/06/15.
//  Copyright (c) 2015 MovieLaLa. All rights reserved.
//

import UIKit

public extension NSURL {
  func dictionaryForQueryString() -> NSMutableDictionary {
    return self.query!.dictionaryFromQueryStringComponents()
  }
}

public extension NSString {
  
  func stringByDecodingURLFormat() -> String {
    var result = self.stringByReplacingOccurrencesOfString("+", withString:" ")
    return result.stringByReplacingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
  }
  
  func dictionaryFromQueryStringComponents() -> NSMutableDictionary {
    let parameters = NSMutableDictionary()
    for keyValue in componentsSeparatedByString("&") {
      let keyValueArray:NSArray = keyValue.componentsSeparatedByString("=")
      if (keyValueArray.count < 2) {
        continue;
      }
      let key:String = keyValueArray.objectAtIndex(0).stringByDecodingURLFormat()
      let value:String = keyValueArray.objectAtIndex(1).stringByDecodingURLFormat()
      var results: NSDictionary = NSDictionary(object: value, forKey: key)
      parameters.addEntriesFromDictionary(results as [NSObject : AnyObject])
    }
    return parameters
  }
}

public class Youtube: NSObject {
  
  let infoURL = "http://www.youtube.com/get_video_info?video_id="
  let thumbnailURL = "http://img.youtube.com/vi/%@/%@.jpg"
  let dataURL = "http://gdata.youtube.com/feeds/api/videos/%@?alt=json"
  let userAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.4 (KHTML, like Gecko) Chrome/22.0.1229.79 Safari/537.4"
  
  public func youtubeIDFromYoutubeURL(youtubeURL:NSURL) -> NSString {
    var youtubeID:NSString = NSString(string: "")
    let youtubeHost:NSString = youtubeURL.host!
    let youtubePathComponents:Array<String> = youtubeURL.pathComponents as! AnyObject as! Array<String>
    let youtubeAbsoluteString = youtubeURL.absoluteString
    if youtubeHost.isEqualToString("youtu.be") {
      youtubeID = youtubePathComponents[1]
    } else if (youtubeAbsoluteString?.rangeOfString("www.youtube.com/embed") != nil) {
      youtubeID = youtubePathComponents[2]
    } else if (youtubeHost.isEqualToString("youtube.googleapis.com") ||
      youtubeURL.pathComponents!.first!.isEqualToString("www.youtube.com")) {
        youtubeID = youtubePathComponents[2] as NSString
    } else {
      let queryString = youtubeURL.dictionaryForQueryString()
      if let searchParam = queryString.objectForKey("v") as? NSString {
        youtubeID = searchParam
      }
    }
    return youtubeID
  }
}
