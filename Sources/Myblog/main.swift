import Foundation
import Publish
import Plot
import HighlightJSPublishPlugin
// This type acts as the configuration for your website.
struct Myblog: Website {
    enum SectionID: String, WebsiteSectionID {
        // Add the sections that you want your website to contain here:
        case index
        case posts
        case tags
        case about
        
        var title: String {
            switch self {
                case .index:
                    return "首页"
                case .posts:
                    return "文章"
                case .tags:
                    return "标签"
                case .about:
                    return "关于"
            }
        }
    }
    
    struct ItemMetadata: WebsiteItemMetadata {
        // Add any site-specific metadata that you want to use here.
    }
    
    // Update these properties to configure your website:
    var url = URL(string: "https://your-website-url.com")!
    var name = "陈斌的记事本"
    var description = "陈斌 Publish Blogs"
    var language: Language { .chinese }
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
        .sctionTitle(), //修改section 标题
        .installPlugin(.dateFormatter()), //设置时间显示格式
        .installPlugin(.countTag()), //计算tag的数量,tag必须在 addMarkDownFiles 之后,否则alltags没有值
        .installPlugin(.colorfulTags(defaultClass: "tag", variantPrefix: "variant", numberOfVariants: 8)), //给tag多种颜色
        .sortItems(by: \.date, order: .descending), //对所有文章排序
        .generateHTML(withTheme: .fatTheme),
//        .installPlugin(.rssSetting(including:[.posts])),
        .generateRSSFeed(
            including: [.posts],
            itemPredicate: nil
        ),
        .generateSiteMap(),
        .unwrap(.gitHub("wnyfk/wnyfk.github.io", useSSH: true), PublishingStep.deploy)
    ])


