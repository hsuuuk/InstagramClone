//
//  ImageUploader.swift
//  InstagramClone
//
//  Created by 심현석 on 2023/04/17.
//

import UIKit
import FirebaseStorage

struct ImageUploader {
    static func imageUpload(image: UIImage, completion: @escaping (String) -> ()) {
        // 지정된 압축 품질로 JPEG 이미지의 데이터 반환
        guard let imageData = image.jpegData(compressionQuality: 0.75) else { return }
        // 고유한 식별자 문자열을 생성
        let DataName = NSUUID().uuidString
        // 고유한 식별자 문자열을 생성
        let ref = Storage.storage().reference(withPath: "/profile_images/\(DataName)")
        // Firebase Storage에 파일을 업로드
        ref.putData(imageData) { metaData, error in
            // Firebase Storage에서 이미지 업로드가 완료된 후, 업로드된 파일의 다운로드 URL을 가져오기 위해 사용
            ref.downloadURL { url, error in
                guard let imageUrl = url?.absoluteString else { return }
                completion(imageUrl)
            }
        }
    }
}
