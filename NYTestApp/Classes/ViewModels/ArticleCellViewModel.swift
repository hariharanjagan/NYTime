//
//  ArticleCellViewModel.swift
//  NYTestApp
//
//  Created by Hariharan jaganathan on 14/08/19.
//  Copyright © 2019 Hariharan jaganathan. All rights reserved.
//

import Foundation

struct ArticleCellViewModel
{
    var title:String!
    var imageUrl:String?
    var publishedDate:Date!
    var byLineString:String?
    var captionInfo:String?
    
    init(article:Article)
    {
        self.title = article.name
        self.imageUrl = article.imageUrl
        self.publishedDate = article.publishedDate
        self.byLineString = article.byLineString
        self.captionInfo = article.abstractInfo
    }
}
