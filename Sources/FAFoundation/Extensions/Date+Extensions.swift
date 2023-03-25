//
//  Date+Extensions.swift
//  
//
//  Created by Ferhan Akkan on 10.09.2022.
//

import Foundation

/// Extension of Date. Adds following capabilities; Defines a CustomFormat enum,
/// allows to convert string to Date, calculates date difference and converts any Date into Local Date.
public extension Date {
    /// Custom Format enum to define Date formats.
    enum CustomFormat: String {
        // 12 09 1990
        case ddMMyyy = "dd MM yyy"
        // 12.09.1990
        case ddMMyyyDotted = "dd.MM.yyy"
        // 12 Sep 1990
        case ddMMMMyyy = "dd MMMM yyy"
        // 12 Sep 1990 11:34
        case ddMMMyyyHHmm = "dd MMM yyy HH:mm"
        // 12 September 1990 11:34
        case ddMMMMyyyHHmm = "dd MMMM yyy HH:mm"
        // 11:34
        case HHmm = "HH:mm"
        // 1990-09-12
        case yyyyMMdd = "yyyy-MM-dd"
        // 1990-09-12T11:34:55.123
        case yyyyMMddTHHmmssSSS = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        // 2022-04-28T12:00:00
        case yyyyMMddTHHmmss = "yyyy-MM-dd'T'HH:mm:ss"
        // 2022-06-02T10:09:36.325171+03:00
        case yyyyMMddTHHmmssSSSZ = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    }
    /**
        Returns string represantation of Date with appliying format and language code.

        - Parameter format: Custom Format to apply
        - Parameter languageCode: Language Code

        - Returns: String representation of Date.
     */
    func string(withFormat format: CustomFormat, languageCode: String?) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.rawValue
        dateFormatter.locale = Locale(identifier: languageCode ?? Locale.current.languageCode ?? "en_US")
        return dateFormatter.string(from: self)
    }

    /**
        Returns string represantation of Date with appliying format and language code.

        - Parameter format: Custom Format string to apply
        - Parameter languageCode: Language Code

        - Returns: String representation of Date.
     */
    func string(withFormat format: String, languageCode: String?) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale(identifier: languageCode ?? Locale.current.languageCode ?? "en_US")
        return dateFormatter.string(from: self)
    }

    /**
        Calculates and Returns difference between self and anotherDate.
        TODO: 3-tuple is a violation of SwiftLint and this function is not used anywhere.

        - Parameter anotherDate: Date to compare with self.

        - Returns: Difference between dates as 3-tuple (hour, minute,second)
     */
    func difference(with anotherDate: Date) -> (hour: Int, minute: Int, second: Int) {
        let dateComponents = Calendar.current.dateComponents([.hour, .minute, .second],
                                                             from: self,
                                                             to: anotherDate)
        let hour = dateComponents.hour ?? 0
        let minute = dateComponents.minute ?? 0
        let second = dateComponents.second ?? 0
        return (hour, minute, second)
    }
    /**
        Converts Date to Local Time Zone from given time zone.

        - Parameter timeZoneAbbreviation: Time zone to convert from.

        - Returns: Local Date.
     */
    func convertToLocalTime(fromTimeZone timeZoneAbbreviation: String = "UTC") -> Date? {
        if let timeZone = TimeZone(abbreviation: timeZoneAbbreviation) {
            let targetOffset = TimeInterval(timeZone.secondsFromGMT(for: self))
            let localOffeset = TimeInterval(TimeZone.autoupdatingCurrent.secondsFromGMT(for: self))
            return self.addingTimeInterval(targetOffset - localOffeset)
        }
        return nil
    }
}
/// Extension of Date. Adds following capability;Calculates and returns current time as miliseconds.
public extension Date {
    /// Calculates and returns current time as miliseconds.
    var currentInMiliseconds: Double {
        self.timeIntervalSince1970 * 1000
    }
    
    var currentInSeconds: Double {
        self.timeIntervalSince1970
    }
}
