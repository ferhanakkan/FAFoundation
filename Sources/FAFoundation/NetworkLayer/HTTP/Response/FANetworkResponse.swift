//
//  FANetworkResponse.swift
//  
//
//  Created by Ferhan Akkan on 10.09.2022.
//

import Foundation

public struct FANetworkResponse<ResponseModel: Decodable> {
    public let httpStatus: HTTPStatus
    public let response: ResponseModel

    init(urlResponse: HTTPURLResponse, with data: Data) throws {
        httpStatus = HTTPStatus(httpUrlResponse: urlResponse)
        response = try JSONDecoder().decode(ResponseModel.self, from: data)
    }
}
