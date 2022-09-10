//
//  FAAwaitMultipartMedia.swift
//  
//
//  Created by Ferhan Akkan on 10.09.2022.
//

import Foundation

public struct FAAwaitMultipartMedia: FAAwaitMultipartEncodable {
    public var name: String
    public var filename: String
    public var data: Data
    public var mimeType: MimeType

    public init(
        name: String,
        filename: String,
        data: Data
    ) {
        self.name = name
        self.filename = filename
        self.data = data
        self.mimeType = .init(ext: (filename as NSString).pathExtension)
    }
}

public extension FAAwaitMultipartMedia {
    enum MimeType {
        case pdf
        case doc
        case docx
        case png
        case jpeg
        case jpg
        case mp4
        case unknown(ext: String)

        init(ext: String) {
            switch ext {
            case "pdf": self = .pdf
            case "doc": self = .doc
            case "docx": self = .docx
            case "png": self = .png
            case "jpeg": self = .jpeg
            case "jpg": self = .jpg
            case "mp4": self = .mp4
            deFAAwaitult:
                self = .unknown(ext: ext)
                assertionFAAwaitilure("Unacceptable type of mimeType received. Type: \(ext)")
            }
        }

        var value: String {
            switch self {
            case .pdf:
                return "application/pdf"
            case .doc:
                return "application/msword"
            case .docx:
                return "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
            case .png:
                return "image/png"
            case .jpeg:
                return "image/jpeg"
            case .mp4:
                return "video/mp4"
            deFAAwaitult:
                return ""
            }
        }
    }
}
