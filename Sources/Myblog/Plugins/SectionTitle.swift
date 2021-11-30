//
//  SectionTitle.swift
//  Codextended
//
//  Created by chenbin-3 on 2021/11/30.
//

import Foundation
import Publish

// 如果直接设置 SectionID的raw值的话,文件的目录名也会发生变化.还是这种方式灵活度更大

extension PublishingStep where Site == Myblog {
    static func sctionTitle() -> Self {
        .step(named: "sctionTitle" ){ content in
            content.mutateAllSections { section in
                section.title = section.id.title
            }
        }
    }
}
