//
//  LDOMarkdownParser.swift
//  LDOMarkdownParser
//
//  Created by Julian Raschke und Sebastian Ludwig GbR on 02.02.22.
//

import UIKit
import MobileCoreServices

public class LDOMarkdownParser {
    public enum LinkStyle {
        case link
        case attachment
    }
    public var font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
    public var boldFont = UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)
    public var italicFont = UIFont.italicSystemFont(ofSize: UIFont.systemFontSize)
    
    private var _generalAttributes: [NSAttributedString.Key: Any]?
    public var generalAttributes: [NSAttributedString.Key: Any] {
        get { _generalAttributes ?? [.font: font] }
        set { _generalAttributes = newValue }
    }
    
    private var _boldAttributes: [NSAttributedString.Key: Any]?
    public var boldAttributes: [NSAttributedString.Key: Any] {
        get { _boldAttributes ?? [.font: boldFont] }
        set { _boldAttributes = newValue }
    }
    private var _italicAttributes: [NSAttributedString.Key: Any]?
    public var italicAttributes: [NSAttributedString.Key: Any] {
        get { _italicAttributes ?? [.font: italicFont] }
        set { _italicAttributes = newValue }
    }
    /**
     There is no way to change the color of links in UILabels. Choose `.attachment` in this case.
     
     The attachments `.contents` will contain the UTF8 encoded link target.
     */
    public var linkStyle = LinkStyle.link
    public var linkColor = UIColor.blue
    private var _linkAttributes: [NSAttributedString.Key: Any]?
    public var linkAttributes: [NSAttributedString.Key: Any] {
        get { _linkAttributes ?? [.foregroundColor: linkColor, .underlineStyle: NSUnderlineStyle.styleSingle.rawValue]}
        set { _linkAttributes = newValue }
    }
    
    public init() {
    }
    
    public func parse(_ text: String) -> NSAttributedString {
        let attributedText = NSMutableAttributedString(string: text)
        
        func range(_ nsrange: NSRange) -> Range<String.Index> { Range(nsrange, in: attributedText.string)! }
        func range(_ text: NSAttributedString) -> NSRange { NSRange(attributedText.string.startIndex..., in: attributedText.string) }
        func iterateMatches(_ pattern: String, action: (NSTextCheckingResult) -> Void) {
            let regex = try! NSRegularExpression(pattern: pattern, options: .dotMatchesLineSeparators)
            while case let match = regex.firstMatch(in: attributedText.string, options: [], range: range(attributedText)), match != nil {
                action(match!)
            }
        }
        
        // general attributes
        attributedText.addAttributes(generalAttributes, range: range(attributedText))
        
        // **bold**
        iterateMatches(#"(?<leadingStars>\*\*).+?(?<trailingStars>\*\*)"#) { match in
            let fullMatch = match.range
            let leadingStars = match.range(withName: "leadingStars")
            let trailingStars = match.range(withName: "trailingStars")
            
            // make everything bold
            attributedText.addAttributes(boldAttributes, range: fullMatch)
            
            // remove markup characters
            attributedText.replaceCharacters(in: trailingStars, with: "")
            attributedText.replaceCharacters(in: leadingStars, with: "")
        }
        
        // _italic_
        iterateMatches(#"(?<leadingUnderscore>_).+?(?<trailingUnderscore>_)"#) { match in
            let fullMatch = match.range
            let leadingUnderscore = match.range(withName: "leadingUnderscore")
            let trailingUnderscore = match.range(withName: "trailingUnderscore")
            
            // make everything italic
            attributedText.addAttributes(italicAttributes, range: fullMatch)
            
            // remove markup characters
            attributedText.replaceCharacters(in: trailingUnderscore, with: "")
            attributedText.replaceCharacters(in: leadingUnderscore, with: "")
        }
        
        
        iterateMatches(#"(?<openBracket>\[)(?<linkText>[^\]]+)(?<middleBrackets>\]\()(?<linkTarget>[^ ]+)(?<closeBrace>\))"#) { match in
            let fullMatch = match.range
            let openBracket = match.range(withName: "openBracket")
            let middleBrackets = match.range(withName: "middleBrackets")
            let linkTarget = match.range(withName: "linkTarget")
            let closeBrace = match.range(withName: "closeBrace")
            
            let target = String(attributedText.string[range(linkTarget)])
            
            // add link
            var linkAttributes = self.linkAttributes
            if linkStyle == .link {
                linkAttributes[.link] = target
            } else {
                if let data = target.data(using: .utf8) {
                    linkAttributes[.attachment] = NSTextAttachment(data: data, ofType: kUTTypeUTF8PlainText as String)
                }
            }
            attributedText.addAttributes(linkAttributes, range: fullMatch)
            
            // remove markup characters
            attributedText.replaceCharacters(in: closeBrace, with: "")
            attributedText.replaceCharacters(in: linkTarget, with: "")
            attributedText.replaceCharacters(in: middleBrackets, with: "")
            attributedText.replaceCharacters(in: openBracket, with: "")
        }
        
        return NSAttributedString(attributedString: attributedText)
    }
}
