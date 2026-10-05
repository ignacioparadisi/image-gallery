//
//  Configuration.swift
//  ImageGallery
//
//  Created by Ignacio Paradisi on 10/5/26.
//

import Foundation

@propertyWrapper
struct Configuration<Value> {
    let key: String
    var bundle: Bundle = .main
    
    var wrappedValue: Value? {
        return bundle.object(forInfoDictionaryKey: key) as? Value
    }
    
}
