//
//  MediaManager.swift
//  Shortlist
//
//  Created by Mark Wong on 4/7/2026.
//  Copyright © 2026 Mark Wong. All rights reserved.
//

import UIKit

enum MediaManager {

    private static let imagesSubdirectory = "images"

    static func imageURL(for taskID: UUID) -> URL? {
        guard let groupURL = FileManager.default.containerURL(
            forSecurityApplicationGroupIdentifier: CoreDataStack.appGroupIdentifier)
        else { return nil }
        let dir = groupURL.appendingPathComponent(imagesSubdirectory, isDirectory: true)
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        return dir.appendingPathComponent(taskID.uuidString + ".jpg")
    }

    static func saveImage(_ image: UIImage, for taskID: UUID) -> String? {
        guard let url = imageURL(for: taskID),
              let data = image.jpegData(compressionQuality: 0.8) else { return nil }
        try? data.write(to: url)
        return url.lastPathComponent
    }

    static func loadImage(filename: String) -> UIImage? {
        guard let groupURL = FileManager.default.containerURL(
            forSecurityApplicationGroupIdentifier: CoreDataStack.appGroupIdentifier)
        else { return nil }
        let url = groupURL.appendingPathComponent(imagesSubdirectory).appendingPathComponent(filename)
        guard let data = try? Data(contentsOf: url) else { return nil }
        return UIImage(data: data)
    }

    static func deleteImage(filename: String) {
        guard let groupURL = FileManager.default.containerURL(
            forSecurityApplicationGroupIdentifier: CoreDataStack.appGroupIdentifier)
        else { return }
        let url = groupURL.appendingPathComponent(imagesSubdirectory).appendingPathComponent(filename)
        try? FileManager.default.removeItem(at: url)
    }

    static func thumbnail(from image: UIImage, size: CGSize = CGSize(width: 40, height: 40)) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
