//
//  DateFormatter.swift
//  Codextended
//
//  Created by chenbin-3 on 2021/11/30.
//

import Foundation
import Publish

extension Plugin{
    static func dateFormatter() -> Self{
        Plugin(name: "dateFormatter"){ context in
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            context.dateFormatter = formatter
        }
    }
}
