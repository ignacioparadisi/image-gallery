//
//  PreviewPhotos.swift
//  ImageGallery
//
//  Created by Ignacio Paradisi on 10/5/26.
//

import Foundation

#if DEBUG
extension PhotoDTO {
    static let previews: [PhotoDTO] = (1...20).map { index in
        let url = "https://images.unsplash.com/photo-1530281700549-e82e7bf110d6?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMDkzNjQ0fDB8MXxzZWFyY2h8MXx8RG9nfGVufDB8fHx8MTc5MTIxOTA4NXww&ixlib=rb-4.1.0&q=80&w=200"
        return PhotoDTO(
            id: "preview-\(index)",
            width: 2000,
            height: 2000,
            color: nil,
            altDescription: "Preview photo \(index)",
            description: nil,
            blurHash: nil,
            urls: URLs(
                raw: nil,
                full: nil,
                regular: url,
                small: url,
                thumb: url,
                smallS3: nil
            )
        )
    }
}
#endif
