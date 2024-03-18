//
//  Meme.swift
//  memeapp
//
//  Created by Khoa on 04/03/2024.
//

import Foundation
import UIKit

class Meme: Codable {
    var topText: String
    var bottomText: String
    var originalImage: UIImage
    var memedImage: UIImage?
    
    enum CodingKeys: String, CodingKey {
            case topText, bottomText, originalImage, memedImage
        }

        // Manual decoding for UIImage
        required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            topText = try container.decode(String.self, forKey: .topText)
            bottomText = try container.decode(String.self, forKey: .bottomText)

            // Decode the originalImage as Data
            let imageData = try container.decode(Data.self, forKey: .originalImage)
            if let image = UIImage(data: imageData) {
                originalImage = image
            } else {
                throw DecodingError.dataCorruptedError(forKey: .originalImage, in: container, debugDescription: "Failed to decode UIImage.")
            }

            // Decode the memedImage as Data
            if let memedImageData = try container.decodeIfPresent(Data.self, forKey: .memedImage) {
                memedImage = UIImage(data: memedImageData)
            }
        }

        // Manual encoding for UIImage
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(topText, forKey: .topText)
            try container.encode(bottomText, forKey: .bottomText)

            // Encode the originalImage as Data
            if let imageData = originalImage.pngData() {
                try container.encode(imageData, forKey: .originalImage)
            }

            // Encode the memedImage as Data
            if let memedImage = memedImage, let memedImageData = memedImage.pngData() {
                try container.encode(memedImageData, forKey: .memedImage)
            }
        }
    init(topText: String, bottomText: String, originalImage: UIImage, memedImage: UIImage?) {
        self.topText = topText
        self.bottomText = bottomText
        self.originalImage = originalImage
        self.memedImage = memedImage
    }
}

