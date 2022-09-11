//
//  String+Extensions.swift
//  
//
//  Created by Ferhan Akkan on 10.09.2022.
//

import Foundation
import UIKit

/// Extension of String. Adds many capabilities to String.
public extension String {
    /// Returns Dictionary representation of JSON Serializable string.
    var asDictionary: [String: Any] {
        if let data = self.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return [:]
    }

    /// Returns attributed string from the original string. So that we could use NSMutableAttributedString Extension via String.
    var asMutableAttrString: NSMutableAttributedString {
        NSMutableAttributedString(string: self)
    }
    
    /// Returns whitespace trimmed version of string.
    /// Input = " test string " -> output: "test string"
    var whitespaceTrimmed: String {
        self.trimmingCharacters(in: .whitespaces)
    }

    /// Returns whitespace removed version of string
    /// Input = " test string " -> output: "teststring"
    var stringByRemovingWhitespaces: String {
        components(separatedBy: .whitespaces).joined()
    }

    /// Returns isNotEmpty
    var isNotEmpty: Bool {
        !isEmpty
    }

    /// Returns isNewLine
    var isNewLine: Bool {
        !self.rangeOfCharacter(from: .newlines).isNil
    }

    /// Returns string by adding ********** to current value.
    var maskedCardNumber: String {
        self + "********"
    }

    /// Returns string by adding * to current value.
    var required: String {
        self + " *"
    }
    
    func validateEmail() -> Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: self)
    }

    /**
        Returns if whitespace trimmed character count is satisfied with count or not.

        - Parameter count: Count of characters to check.

        - Returns: True if character count satisfied, false otherwise.
     */
    func characterCountSatisfied(with count: Int) -> Bool {
        guard self.whitespaceTrimmed.count >= count else { return false }
        return true
    }
    /**
        Finds first index of given character and returns.

        - Parameter char: Character to check for first index.

        - Returns: First index of given character.
     */
    func firstIndex(of char: Character) -> Int? {
        for (index, currentChar) in self.enumerated() where currentChar == char {
            return index
        }
        return nil
    }
    /**
        Finds last index of given character and returns.

        - Parameter char: Character to check for last index.

        - Returns: Last index of given character.
     */
    func lastIndex(of char: Character) -> Int? {
        var index = -1
        for (currentIndex, currentChar) in self.enumerated() where currentChar == char {
            index = currentIndex
        }
        return index == -1 ? nil : index
    }
    /**
        Replaces character for string at index with newChar.

        - Parameter string: String to replace character.
        - Parameter index: Index of character to replace.
        - Parameter newChar: New character to replace.

        - Returns: String with newChar at given index.
     */
    func replace(string: String, _ index: Int, _ newChar: Character) -> String {
        var chars = Array(string)
        if chars.count > index {
            chars[index] = newChar
        }
        return String(chars)
    }
    /**
        Slices string with using lower/higher bounds.

        - Parameter from: Lower bound string of slice.
        - Parameter to: Upper bound string of slice.

        - Returns: Sliced String.
     */
    func slice(from: String, to: String) -> String? {
        (range(of: from)?.upperBound).flatMap { substringFrom in
            (range(of: to, range: substringFrom..<endIndex)?.lowerBound).map { substringTo in
                String(self[substringFrom..<substringTo])
            }
        }
    }
    /// Returns Date representation of String.
    var asDate: Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        return dateFormatter.date(from: self)
    }

    /// Returns Dotted Date representation of String.
    var asDottedDate: String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Date.CustomFormat.yyyyMMdd.rawValue
        guard let date = dateFormatter.date(from: self) else {
            return nil
        }

        dateFormatter.dateFormat = Date.CustomFormat.ddMMyyyDotted.rawValue
        return dateFormatter.string(from: date)
    }

    var asHourAndMinute: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Date.CustomFormat.yyyyMMddTHHmmss.rawValue
        let date = dateFormatter.date(from: self)
        return date?.string(withFormat: .HHmm, languageCode: Locale.current.languageCode) ?? ""
    }

    /// Returns underlined representation of String.
    var underlined: NSAttributedString {
        let textRange = NSRange(location: 0, length: self.count)
        let attributedText = NSMutableAttributedString(string: self)
        attributedText.addAttribute(NSAttributedString.Key.underlineStyle ,
                                    value: NSUnderlineStyle.single.rawValue,
                                    range: textRange)
        return attributedText
    }
    /// Returns strucked representation of String.
    var struck: NSMutableAttributedString {
        let textRange = NSRange(location: 0, length: self.count)
        let attributedText = NSMutableAttributedString(string: self)
        attributedText.addAttribute(.baselineOffset, value: 0, range: textRange)
        attributedText.addAttribute(.strikethroughStyle,
                                    value: NSUnderlineStyle.single.rawValue,
                                    range: textRange)
        attributedText.addAttribute(.baselineOffset,
                                    value: NSNumber(floatLiteral: 0),
                                    range: textRange)
        return attributedText
    }
    /// Returns NSAttributedString for String.
    var basicAttributedString: NSAttributedString {
        NSMutableAttributedString(string: self)
    }

    /// Returns NSAttributedString for HTML strings.
    func getHTMLAttributedString() -> NSAttributedString? {
        let data = Data(self.utf8)
        guard let attributedString = try? NSAttributedString(data: data,
                                                             options: [.documentType: NSAttributedString.DocumentType.html,
                                                                       .characterEncoding: String.Encoding.utf8.rawValue],
                                                             documentAttributes: nil) else {
            return nil
        }

        return attributedString
    }

    /**
        Calculates and returns height for font and width.

        - Parameter width: Constrained width of String.
        - Parameter font: Font

        - Returns: Height of String with specified font and width.
     */
    @available(*, deprecated, message: "Use height(withConstrainedWidth width: CGFloat, font: UIFont, numberOfLines: Int) instead of this one.")
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect,
                                            options: .usesLineFragmentOrigin,
                                            attributes: [.font: font],
                                            context: nil)

        return ceil(boundingBox.height)
    }
    /**
        Calculates and returns height for font, width and numberOfLines.

        - Parameter width: Constrained width of String.
        - Parameter font: Font
        - Parameter numberOfLines: The max number of lines should be constrained

        - Returns: Height of String with specified font, width and numberOfLines.
     */
    func height(withConstrainedWidth width: CGFloat,
                font: UIFont,
                numberOfLines: Int) -> CGFloat {
        guard self.isNotEmpty else {
            return .zero
        }
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect,
                                            options: .usesLineFragmentOrigin,
                                            attributes: [.font: font],
                                            context: nil)

        let height = ceil(boundingBox.height)
        if numberOfLines > 0 {
            let linesInt = Int((height / font.lineHeight).rounded(.down))
            if linesInt >= numberOfLines {
                return (boundingBox.height / linesInt.asCGFloat) * numberOfLines.asCGFloat
            }
        }
        return height
    }
    /**
        Calculates and returns width for font and height.

        - Parameter height: Constrained height of String.
        - Parameter font: Font

        - Returns: Width of String with specified font and width.
     */
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect,
                                            options: .usesLineFragmentOrigin,
                                            attributes: [.font: font],
                                            context: nil)
        return ceil(boundingBox.width)
    }
    /// Returns range for string between pipes.
    var rangeOfPipedText: NSRange {
        let stringInsidePipes = slice(from: "|", to: "|")
        let pipedString = "|" + stringInsidePipes.orEmptyString + "|"
        let str = NSString(string: self)
        let theRange = str.range(of: pipedString)
        let rangeOfDuration = NSRange(location: theRange.location, length: stringInsidePipes.orEmptyString.count)
        return rangeOfDuration
    }
    /// Returns string between pipes by slicing.
    var stringInsidePipes: String {
        slice(from: "|", to: "|").orEmptyString
    }
    /// Returns string array between pipes
    var stringArrayInsidePipes: [String] {
        stringArrayInsideCharacters(character: "|")
    }
    /// Slices the text that between the given characters
    /// - Parameter character: Character for splitting the hole string to array slice
    /// - Returns: Returns sliced array between the given seperator character
    func stringArrayInsideCharacters(character: Character) -> [String] {
        var stringArray: [String] = []
        var isInsideCharacters = false
        var stringInsideCharacters = ""
        for char in self {
            if char == character {
                if isInsideCharacters {
                    stringArray.append(stringInsideCharacters)
                    stringInsideCharacters = ""
                    isInsideCharacters = false
                } else {
                    isInsideCharacters = true
                }
            } else if isInsideCharacters {
                stringInsideCharacters.append(char)
            }
        }
        return stringArray
    }
    /// Returns pipe-free representation of String.
    var stringWithoutPipes: String {
        replacingOccurrences(of: "|", with: "")
    }
    /// Returns currency-signed string.
    var moneyStringForAccessibilityForTL: String {
        guard let symbol = self.first else { return self }
        if symbol == "₺" {
            let moneyWithoutSymbol = replacingOccurrences(of: String(symbol), with: "")
            return moneyWithoutSymbol + "TL"
        } else if symbol == "£" {
            let moneyWithoutSymbol = replacingOccurrences(of: String(symbol), with: "")
            return moneyWithoutSymbol + "GBP"
        }
        return self
    }
    /**
        Uses given string if self is empty.

        - Parameter str: String to use

        - Returns: self if self is not empty, str otherwise.
     */
    func ifEmptyUseThis(str: String) -> String {
        if self.isEmpty {
            return str
        }
        return self
    }
    /// Returns word array from string by splitting from single space.
    var parsedWords: [String.SubSequence] {
        split(separator: " ")
    }
    /// Returns count of words.
    var wordCount: Int {
        if isEmpty { return 0 }
        return parsedWords.count
    }
    /**
        Replaces all occurrences of Turkish characters

        - Returns: Turkish-trimmed representation of string.
     */
    func replaceTurkishCharacters() -> String {
        var result = self
        result = result.replacingOccurrences(of: "ç", with: "c")
        result = result.replacingOccurrences(of: "ö", with: "o")
        result = result.replacingOccurrences(of: "ı", with: "i")
        result = result.replacingOccurrences(of: "ğ", with: "g")
        result = result.replacingOccurrences(of: "ü", with: "u")
        result = result.replacingOccurrences(of: "ş", with: "s")
        result = result.replacingOccurrences(of: "Ç", with: "C")
        result = result.replacingOccurrences(of: "Ö", with: "O")
        result = result.replacingOccurrences(of: "İ", with: "I")
        result = result.replacingOccurrences(of: "Ğ", with: "G")
        result = result.replacingOccurrences(of: "Ü", with: "U")
        result = result.replacingOccurrences(of: "Ş", with: "S")
        return result
    }
    /**
        Returns string by removing spaces between words.

        - Returns: Space-free representation of String.
     */
    func removeSpaceBetweenWords() -> String {
        self.replacingOccurrences(of: "\\s", with: "", options: .regularExpression)
    }
}

// MARK: - Subscript methods
/// Subscript Extension of String. Adds usability for subscript methods.
public extension String {
    subscript (integer: Int) -> Character {
        self[index(startIndex, offsetBy: integer)]
    }
    subscript (bounds: CountableRange<Int>) -> Substring {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return self[start ..< end]
    }
    subscript (bounds: CountableClosedRange<Int>) -> Substring {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return self[start ... end]
    }
    subscript (bounds: CountablePartialRangeFrom<Int>) -> Substring {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(endIndex, offsetBy: -1)
        return self[start ... end]
    }
    subscript (bounds: PartialRangeThrough<Int>) -> Substring {
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return self[startIndex ... end]
    }
    subscript (bounds: PartialRangeUpTo<Int>) -> Substring {
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return self[startIndex ..< end]
    }
}
// MARK: - Static variables
public extension String {
    static var comma = ","
    static var dot = "."
}
public extension Substring {
    subscript (integer: Int) -> Character {
        self[index(startIndex, offsetBy: integer)]
    }
    subscript (bounds: CountableRange<Int>) -> Substring {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return self[start ..< end]
    }
    subscript (bounds: CountableClosedRange<Int>) -> Substring {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return self[start ... end]
    }
    subscript (bounds: CountablePartialRangeFrom<Int>) -> Substring {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(endIndex, offsetBy: -1)
        return self[start ... end]
    }
    subscript (bounds: PartialRangeThrough<Int>) -> Substring {
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return self[startIndex ... end]
    }
    subscript (bounds: PartialRangeUpTo<Int>) -> Substring {
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return self[startIndex ..< end]
    }
}
