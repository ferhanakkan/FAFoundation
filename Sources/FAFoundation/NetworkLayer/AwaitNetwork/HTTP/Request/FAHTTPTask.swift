//
//  FAAwaitHTTPTask.swift
//  
//
//  Created by Ferhan Akkan on 10.09.2022.
//

import Foundation

public enum FAAwaitHTTPTask {
    case request

    case requestParameters(bodyParameters: FAAwaitParameters?,
                           bodyEncoding: FAAwaitParameterEncoding,
                           urlParameters: FAAwaitParameters?)

    case requestParametersAndHeaders(bodyParameters: FAAwaitParameters?,
                                     bodyEncoding: FAAwaitParameterEncoding,
                                     urlParameters: FAAwaitParameters?,
                                     additionHeaders: FAAwaitHTTPHeaders?)

    case requestMultipartParameters(multipartParameters: [FAAwaitMultipartEncodable],
                                    urlParameters: FAAwaitParameters?)
}
