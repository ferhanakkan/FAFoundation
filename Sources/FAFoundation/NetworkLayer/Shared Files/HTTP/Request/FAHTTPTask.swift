//
//  FAHTTPTask.swift
//  
//
//  Created by Ferhan Akkan on 10.09.2022.
//

import Foundation

public enum FAHTTPTask {
    case request

    case requestParameters(bodyParameters: FAParameters?,
                           bodyEncoding: FAParameterEncoding,
                           urlParameters: FAParameters?)

    case requestParametersAndHeaders(bodyParameters: FAParameters?,
                                     bodyEncoding: FAParameterEncoding,
                                     urlParameters: FAParameters?,
                                     additionHeaders: FAHTTPHeaders?)

    case requestMultipartParameters(multipartParameters: [FAMultipartEncodable],
                                    urlParameters: FAParameters?)
}
