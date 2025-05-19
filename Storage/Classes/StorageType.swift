//
//  StorageType.swift
//  Storage
//
//  Created by Rizwan on 02/11/17.
//  Copyright © 2017 Rizwan. All rights reserved.
//

import Foundation

public enum StorageType {
    case cache
    case document

    public var searchPathDirectory: FileManager.SearchPathDirectory {
        switch self {
        case .cache: return .cachesDirectory
        case .document: return .documentDirectory
        }
    }

    public var folder: URL {
        guard let path = NSSearchPathForDirectoriesInDomains(searchPathDirectory, .userDomainMask, true).first else {
            fatalError("Cannot find the path directory for storage")
        }
        let subfolder = "com.rizwankce.storage"
        return URL(fileURLWithPath: path).appendingPathComponent(subfolder)
    }    
}
