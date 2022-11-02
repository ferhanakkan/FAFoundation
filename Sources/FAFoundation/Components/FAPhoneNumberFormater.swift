//
//  FAPhoneNumberFormater.swift
//  
//
//  Created by Ferhan Akkan on 12.09.2022.
//

import Foundation

public enum FAPhoneNumberFormat: String {
    case first = "+## (###) ###-####"
    case second = "### ##### ##"
    case third = "(###) ### ## ##"
}

/// TextFormatter protocol, Provides a formatting standard.
public protocol FATextFormatter {
    /// Describes format
    var textFormat: FAPhoneNumberFormat { get }

    /**
     Formats String applying given parameters and returns

     - Parameters:
        - replacementString: replacement string to format
        - numbersAlreadyInField: string to keep outside of format

     - Returns: Formatted string
     */
    func format(replacementString: String) -> String
}

/// Class responsible of formatting phone numbers.
public final class FAPhoneNumberFormater: FATextFormatter {
    /// Describes format
    public var textFormat: FAPhoneNumberFormat

    /// Decides if formatted phone number can start with 0
    var isInitialZeroEnabled: Bool

    /**
     Main constructor

     - Parameters:
        - textFormat: String format of phone number
        - isInitialZeroEnabled: Boolean decides if formatted phone number can start with 0
     */
    public init(textFormat: FAPhoneNumberFormat, isInitialZeroEnabled: Bool) {
        self.textFormat = textFormat
        self.isInitialZeroEnabled = isInitialZeroEnabled
    }

    /// TextFormatter protocol.
    public func format(replacementString: String) -> String {
        let maxCharacterCount = (textFormat.rawValue.components(separatedBy: "#").count - 1)
        var plainString = replacementString.components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: "").description

        if plainString.isEmpty {
            return ""
        }

        if plainString.count > 1, !isInitialZeroEnabled, plainString.starts(with: "0") {
            plainString.removeFirst()
        }

        let plainStringArray = Array(plainString.prefix(maxCharacterCount).description)
        let formatStringArray = Array(textFormat.rawValue)

        var formattedString = ""
        var position = 0

        for index in 0 ..< plainStringArray.count {
            while formatStringArray[position] != "#" {
                formattedString += String(formatStringArray[position])
                position += 1
            }
            formattedString += String(plainStringArray[index])
            position += 1
        }

        return formattedString
    }
}
