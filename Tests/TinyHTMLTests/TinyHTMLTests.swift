@testable import TinyHTML
import XCTest

@available(iOS 17.0, *) final class TinyHTMLTests: XCTestCase {
    func testAttribute() throws {
        let html = try HTML(Data("""
        <!DOCTYPE html>
        <html>
            <body>
                <div id='foo' class='bar' test=''>Hello World</div>
            </body>
        </html>
        """.utf8))
        let elements = html.evaluate(xPath: "//div[@id='foo']")
        XCTAssertEqual(elements.count, 1)
        XCTAssertEqual(elements[0].attribute(named: "class"), "bar")
        XCTAssertEqual(elements[0].attribute(named: "null"), nil)
        XCTAssertEqual(elements[0].attribute(named: "test"), "")
    }

    func testInnerText() throws {
        let html = try HTML(Data("""
        <html>
            <head>
                <title>Hello World</title>
            </head>
            <body>Body</body>
        </html>
        """.utf8))
        let elements = html.evaluate(xPath: "//title")
        XCTAssertEqual(elements.count, 1)
        XCTAssertEqual(elements[0].innerText, "Hello World")
    }

    func testEmpty() throws {
        XCTAssertThrowsError(try HTML(Data("".utf8))) { error in
            XCTAssertEqual(error as! HTML.Error, .invalidHTML)
        }
    }
}
