//
//  PageModel.swift
//  Pinch App
//
//  Created by Yusril on 12/02/23.
//

import Foundation

struct Page: Identifiable {
    let id: Int
    let imageName: String
}

extension Page {
    var thumbnailName: String {
        return "thumb-" + imageName
    }
}
