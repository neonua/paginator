import XCTest

import Vapor

@testable import Leaf
@testable import Paginator

class LeafTests: XCTestCase {
    static var allTest = [
        ("testExample", testExample)
    ]
    
    func testExample() {
        let tag = PaginatorTag()
        let paginator = buildPaginator()
        
        let result = try! run(
            tag: tag,
            context: paginator,
            arguments: [
                .variable(path: [], value: paginator)
            ]
        )
        
        guard result != nil, case .bytes(let bytes) = result! else {
            XCTFail("Should have returned bytes")
            return
        }
        
        let expectedHTML = "<nav class=\"paginator text-center\">\n<ul class=\"pagination\">\n<li><a href=\"/posts?page=1\" rel=\"prev\">«</a></li>\n<li><a href=\"?page=1\">1</a></li>\n<li class=\"active\"><span>2</span></li>\n<li><a href=\"?page=3\">3</a></li>\n<li><a href=\"?page=4\">4</a></li>\n<li><a href=\"?page=5\">5</a></li>\n<li><a href=\"?page=6\">6</a></li>\n<li><a href=\"?page=7\">7</a></li>\n<li><a href=\"?page=8\">8</a></li>\n<li><a href=\"?page=9\">9</a></li>\n<li><a href=\"?page=10\">10</a></li>\n<li><a href=\"/posts?page=3\" rel=\"next\">»</a></li>\n</ul>\n</nav>"
        
        XCTAssertEqual(bytes.string, expectedHTML)
    }
}

extension LeafTests {
    func buildPaginator() -> Node {
        return Node([
            "meta": Node([
                "paginator": Node([
                    "current_page": 2,
                    "total_pages": 10,
                    "links": Node([
                        "previous": "/posts?page=1",
                        "next": "/posts?page=3"
                    ])
                ])
            ])
        ])
    }
    
    func run(tag: Tag, context node: Node, arguments: [Argument]) throws -> Node? {
        let context = Context(node)
        
        return try tag.run(
            stem: Stem(workingDirectory: ""),
            context: context,
            tagTemplate: TagTemplate(name: "", parameters: [], body: nil),
            arguments: arguments
        )
    }
}
