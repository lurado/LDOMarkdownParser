import XCTest
import LDOMarkdownParser

class LDOMarkdownParserTests: XCTestCase {
    private var parser: LDOMarkdownParser!
    
    override func setUp() {
        super.setUp()
        
        parser = LDOMarkdownParser()
        parser.generalAttributes = [:]
        // use dummy attributes to be able to write nicer expectations
        parser.boldAttributes = [.textEffect: "bold"]
        parser.italicAttributes = [.textEffect: "italic"]
        parser.linkAttributes = [.textEffect: "link"]
    }
    
    func parse(_ input: String) -> String {
        let output = parser.parse(input)
        return String(describing: output)
    }

    func testSingleBold() {
        let expected = """
        A {
        }bold{
            NSTextEffect = bold;
        } statement{
        }
        """
        XCTAssertEqual(parse("A **bold** statement"), expected)
    }
    
    func testMultipleBold() {
        let expected = """
        Something{
            NSTextEffect = bold;
        } is {
        }not{
            NSTextEffect = bold;
        } right!{
        }
        """
        XCTAssertEqual(parse("**Something** is **not** right!"), expected)
    }
    
    func testSingleUnderscore() {
        let expected = """
        Very{
            NSTextEffect = italic;
        } nice.{
        }
        """
        XCTAssertEqual(parse("_Very_ nice."), expected)
    }
    
    func testMultipleUnderscore() {
        let expected = """
        Very{
            NSTextEffect = italic;
        } nice {
        }indeed{
            NSTextEffect = italic;
        }
        """
        XCTAssertEqual(parse("_Very_ nice _indeed_"), expected)
    }
    
    func testLink() {
        let expected = """
        A {
        }road{
            NSLink = "http://example.com";
            NSTextEffect = link;
        } to nowhere{
        }
        """
        XCTAssertEqual(parse("A [road](http://example.com) to nowhere"), expected)
    }
}
