//
//  TagCount.swift
//  Codextended
//
//  Created by chenbin-3 on 2021/11/30.
//

import Foundation
import Publish

// MARK: 计算tag数目
extension Plugin{
    static func countTag() -> Self{
        return Plugin(name: "countTag"){ content in
            CountTag.count(content: content)
        }
    }
}

struct CountTag{
    static var count:[Tag:Int] = [:]
    static func count<T:Website>(content:PublishingContext<T>){
        for tag in content.allTags{
            count[tag] =  content.items(taggedWith: tag).count
        }
    }
}

extension Tag{
    public var count:Int{
        CountTag.count[self] ?? 0
    }
}

//item_count
extension PublishingContext{
    var itemCount:Int{
        allItems(sortedBy: \.date,order: .descending).count
    }
}
