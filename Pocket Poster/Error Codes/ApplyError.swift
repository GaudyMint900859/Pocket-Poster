//
//  ApplyError.swift
//  Pocket Poster
//
//  Created by lemin on 6/18/25.
//

import Foundation

enum ApplyError: LocalizedError {
    // Throw when the app hash is incorrect
    case wrongAppHash
    
    // Throw when the collections need to be reset
    case collectionsNeedsReset
    
    // Throw in all other cases
    case unexpected(info: String)
    
    public var errorDescription: String? {
        switch self {
        case .wrongAppHash:
            return "Your app hash is incorrect. Please set it again."
        case .collectionsNeedsReset:
            return "The folder is improperly set up. Please tap \"Reset Collections\" and try again."
        case .unexpected(let info):
            return info
        }
    }
}
