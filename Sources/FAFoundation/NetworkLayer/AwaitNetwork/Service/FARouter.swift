//
//  FAAwaitRouter.swift
//  
//
//  Created by Ferhan Akkan on 10.09.2022.
//

import Foundation

public typealias FAAwaitNetworkRouterCompletion = (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void

protocol FAAwaitNetworkRouter: AnyObject {
    @discardableResult
    func request<T: FAAwaitEndpoint>(_ route: T, timeout: TimeInterval, completion: @escaping FAAwaitNetworkRouterCompletion) -> URLSessionTask?
}

class FAAwaitTRouter: FAAwaitNetworkRouter {
    func request<T: FAAwaitEndpoint>(_ route: T, timeout: TimeInterval, completion: @escaping FAAwaitNetworkRouterCompletion) -> URLSessionTask? {
        let session = URLSession.shared
        do {
            let request = try self.buildRequest(from: route, timeout: timeout)
            FAAwaitNetworkLogger.log(request: request)
            let task = session.dataTask(with: request, completionHandler: { data, response, error in
                completion(data, response, error)
            })
            task.resume()
            return task
        } catch {
            completion(nil, nil, error)
            return nil
        }
    }

    fileprivate func buildRequest<T: FAAwaitEndpoint>(from route: T, timeout: TimeInterval) throws -> URLRequest {
        var request = URLRequest(url: route.baseURL.appendingPathComponent(route.path),
                                 cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                 timeoutInterval: timeout)

        request.httpMethod = route.httpMethod.rawValue

        request.allHTTPHeaderFields = route.allHeaders?.asDictionary

        do {
            switch route.task {
            case .request:
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")

            case .requestParameters(let bodyParameters,
                                    let bodyEncoding,
                                    let urlParameters):

                try self.configureParameters(bodyParameters: bodyParameters,
                                             bodyEncoding: bodyEncoding,
                                             urlParameters: urlParameters,
                                             request: &request)

            case .requestParametersAndHeaders(let bodyParameters,
                                              let bodyEncoding,
                                              let urlParameters,
                                              let additionalHeaders):

                self.addAdditionalHeaders(additionalHeaders, request: &request)
                try self.configureParameters(bodyParameters: bodyParameters,
                                             bodyEncoding: bodyEncoding,
                                             urlParameters: urlParameters,
                                             request: &request)

            case .requestMultipartParameters(let multipartParameters, let urlParameters):
                self.configureParameters(multipartParameters: multipartParameters, urlParameters: urlParameters, request: &request)
            }
            return request
        } catch {
            throw error
        }
    }

    fileprivate func configureParameters(bodyParameters: FAAwaitParameters?,
                                         bodyEncoding: FAAwaitParameterEncoding,
                                         urlParameters: FAAwaitParameters?,
                                         request: inout URLRequest) throws {
        do {
            try bodyEncoding.encode(urlRequest: &request,
                                    bodyParameters: bodyParameters, urlParameters: urlParameters)
        } catch {
            throw error
        }
    }

    fileprivate func addAdditionalHeaders(_ additionalHeaders: FAAwaitHTTPHeaders?, request: inout URLRequest) {
        guard let headers = additionalHeaders else { return }
        for header in headers.headers {
            request.setValue(header.value, forHTTPHeaderField: header.key)
        }
    }

    fileprivate func configureParameters(multipartParameters: [FAAwaitMultipartEncodable], urlParameters: FAAwaitParameters?, request: inout URLRequest) {
        if let url = request.url {
            var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: FAAwaitlse)
            let queryItems: [URLQueryItem] = urlParameters?.compactMap({ .init(name: $0.key, value: String(describing: $0.value))}) ?? []
            urlComponents?.queryItems = queryItems
            request.url = urlComponents?.url
        }
        let boundary = "Boundary-\(UUID.init().uuidString)"

        let lineBreak = "\r\n"
        var body = Data()

        for parameter in multipartParameters {
            if let parameter = parameter as? FAAwaitMultipartParameter {
                body.append("--\(boundary)\(lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(parameter.name)\"\(lineBreak)\(lineBreak)")
                body.append("\(parameter.value)\(lineBreak)")
            }
            if let media = parameter as? FAAwaitMultipartMedia {
                body.append("--\(boundary)\(lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(media.name)\"; filename=\"\(media.filename)\"\(lineBreak)")
                body.append("Content-Type: \(media.mimeType.value)\(lineBreak)\(lineBreak)")
                body.append(media.data)
                body.append(lineBreak)
            }
        }

        body.append("--\(boundary)--\(lineBreak)")
        request.httpBody = body

        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
    }
}

extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}