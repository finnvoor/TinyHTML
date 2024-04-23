import Foundation
import libxml2

public extension HTML {
    class Element {
        // MARK: Lifecycle

        init(pointer: xmlNodePtr) {
            self.pointer = pointer
        }

        // MARK: Public

        public lazy var innerText: String = {
            func innerText(from pointer: xmlNodePtr?) -> String {
                guard let pointer else { return "" }
                var result = ""
                var cursor: xmlNodePtr? = pointer
                while let currentNode = cursor {
                    switch currentNode.pointee.type {
                    case XML_TEXT_NODE:
                        if let content = xmlNodeGetContent(currentNode) {
                            result += String(cString: content)
                            xmlFree(content)
                        }
                    default:
                        result += innerText(from: currentNode.pointee.children)
                    }
                    cursor = currentNode.pointee.next
                }
                return result
            }
            return innerText(from: self.pointer.pointee.children)
        }()

        public func attribute(named name: String) -> String? {
            guard let children = xmlHasProp(pointer, name)?.pointee.children else {
                return nil
            }
            let txtContent = xmlNodeGetContent(children)!
            defer { xmlFree(txtContent) }
            return String(cString: txtContent)
        }

        // MARK: Internal

        let pointer: xmlNodePtr
    }
}
