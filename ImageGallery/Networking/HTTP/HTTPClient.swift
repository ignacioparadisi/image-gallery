//
//  HTTPClient.swift
//  ImageGallery
//
//  Created by Ignacio Paradisi on 10/5/26.
//

import Foundation

protocol APIClient {
}

public final class HTTPClient: APIClient {
    private let session: URLSession
    
    public init(session: URLSession) {
        self.session = session
    }
}
