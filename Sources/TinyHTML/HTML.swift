import Foundation
import libxml2

// MARK: - HTML

public final class HTML {
    // MARK: Lifecycle

    public init(_ data: Data) throws {
        let buffer = data.withUnsafeBytes { $0.bindMemory(to: CChar.self) }
        guard let pointer = htmlReadMemory(
            buffer.baseAddress,
            Int32(buffer.count),
            "",
            nil,
            Int32(XML_PARSE_NOWARNING.rawValue | XML_PARSE_NOERROR.rawValue | XML_PARSE_RECOVER.rawValue)
        ) else { throw Error.invalidHTML }
        self.pointer = pointer
        guard let root = xmlDocGetRootElement(pointer) else { throw Error.invalidHTML }
        self.root = Element(pointer: root)
    }

    deinit { xmlFreeDoc(pointer) }

    // MARK: Public

    public let root: Element

    public func evaluate(xPath: String, on element: Element? = nil) -> [Element] {
        let context = xmlXPathNewContext(pointer)!
        defer { xmlXPathFreeContext(context) }

        if let element {
            context.pointee.node = element.pointer
        }

        let xPathEvalExpression = xmlXPathEvalExpression(xPath, context)
        defer { xmlXPathFreeObject(xPathEvalExpression) }

        var results: [Element] = []
        if let nodes = xPathEvalExpression?.pointee.nodesetval {
            let nodes = UnsafeBufferPointer(
                start: nodes.pointee.nodeTab,
                count: Int(nodes.pointee.nodeNr)
            )
            for node in nodes.compactMap({ $0 }) {
                results.append(Element(pointer: node))
            }
        }
        return results
    }

    // MARK: Private

    private let pointer: xmlDocPtr
}

// MARK: HTML.Error

extension HTML {
    enum Error: Swift.Error {
        case invalidHTML
    }
}
