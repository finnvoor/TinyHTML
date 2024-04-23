# TinyHTML

A tiny Swift package for parsing HTML powered by `libxml2`.

### Usage

```swift
let data = try await URLSession.shared.data(from: URL(
    string: "https://finnvoorhees.com/words/reading-and-writing-spatial-photos-with-image-io"
)!).0

let html = try HTML(data)

let titleElement = html.evaluate(xPath: "//title").first!
let title = element.innerText
print(title) // "Reading and Writing Spatial Photos with Image I/O"

let ogImageElement = html.evaluate(xPath: "//meta[@property='og:image']").first!
let ogImage = ogImageElement.attribute(named: "content")
print(ogImage) // "https://finnvoorhees.com/_astro/spatial-photo.C-2k3Bzw.png"
```

> [!TIP]
> TinyHTML only supports XPath for selecting elements. CSS selectors can be converted to XPaths using a tool like https://css2xpath.github.io/
