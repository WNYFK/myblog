import Foundation
import Publish
import Plot
import HighlightJSPublishPlugin

// This type acts as the configuration for your website.
struct Myblog: Website {
    enum SectionID: String, WebsiteSectionID {
        // Add the sections that you want your website to contain here:
        case posts
    }
    
    struct ItemMetadata: WebsiteItemMetadata {
        // Add any site-specific metadata that you want to use here.
    }
    
    // Update these properties to configure your website:
    var url = URL(string: "https://your-website-url.com")!
    var name = "WNYFK"
    var description = "A description of WNYFK"
    var language: Language { .english }
    var imagePath: Path? { nil }
}

// This will generate your website using the built-in Foundation theme:
try Myblog().publish(
    using: [
        //使用ink modifier的plugins要在addMarkdonwFiles之前先加入.
        //需要注意modifier的添加顺序
        .installPlugin(.highlightJS()), //语法高亮
        .copyResources(),
        .addMarkdownFiles(),
//        .setSctionTitle(), //修改section 标题
//        .installPlugin(.setDateFormatter()), //设置时间显示格式
//        .installPlugin(.countTag()), //计算tag的数量,tag必须在 addMarkDownFiles 之后,否则alltags没有值
        .sortItems(by: \.date, order: .descending), //对所有文章排序
        //        .installPlugin(.rssSetting(including:[.posts,.project])),
        .generateRSSFeed(
            including: [.posts],
            itemPredicate: nil
        ),
        .generateSiteMap(),
        .unwrap(.gitHub("wnyfk/wnyfk.github.io", useSSH: true), PublishingStep.deploy)
    ])
