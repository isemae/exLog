//
//  UIImage+Extensions.swift
//  exLog
//
//  Created by Jiwoon Lee on 2/2/24.
//

import Foundation
import UIKit

extension UIImage {
	func createThumbnail(scaleTo scaleValue: CGFloat, completion: @escaping (_ thumbnail: UIImage?) -> Void) {
		DispatchQueue.global(qos: .background).async {
			guard let imageData = self.pngData() else {
				completion(nil)
				return
			}

			guard let imageSource = CGImageSourceCreateWithData(imageData as CFData, nil) else {
				completion(nil)
				return
			}

			let thumbnailSize = max(self.size.width, self.size.height) * scaleValue

			let options = [
				kCGImageSourceThumbnailMaxPixelSize: thumbnailSize,
				kCGImageSourceCreateThumbnailWithTransform: true,
				kCGImageSourceCreateThumbnailFromImageAlways: true
			] as CFDictionary

			guard let thumbnail = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, options) else {
				completion(nil)
				return
			}

			completion(UIImage(cgImage: thumbnail))
		}
	}

	func createThumbnail(scaleTo scaleValue: CGFloat) async -> UIImage? {
		await withUnsafeContinuation({ continuation in
			createThumbnail(scaleTo: scaleValue) { thumbnail in
				continuation.resume(returning: thumbnail)
			}
		})
	}

	func resized(to targetSize: CGSize) -> UIImage? {
		let renderer = UIGraphicsImageRenderer(size: targetSize)
		return renderer.image { _ in
			self.draw(in: CGRect(origin: .zero, size: targetSize))
		}
	}
}
