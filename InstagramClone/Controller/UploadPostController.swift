//
//  UploadPostController.swift
//  InstagramClone
//
//  Created by 심현석 on 2023/05/08.
//

import UIKit
import SnapKit

//protocol UploadPostControllerDelegate: AnyObject {
//    func controllerDidFinishUploadingPost(_ controller: UploadPostController)
//}

extension UploadPostController {
    @objc func didTapDone() {
        guard let image = selectedImage else { return }
        guard let caption = captionTextView.text else { return }
        guard let user = currentUser else { return }
        
        showLoader(true)
        
        FirestoreManager.addPost(caption: caption, image: image, user: user) {
            self.dismiss(animated: true)
            // 첫번째 탭으로 이동 코드
        }
    }
}

class UploadPostController: UIViewController {
    
    // MARK: - Properties
    
    //weak var delegate: UploadPostControllerDelegate?
    
    var currentUser: UserData?
    
    var selectedImage: UIImage? {
        didSet { photoImageView.image = selectedImage }
    }

    private let photoImageView : UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 10
        return iv
    }()
    
    private lazy var captionTextView: InputTextView = {
        let tv = InputTextView()
        tv.placeholderText = "문구 입력..."
        tv.font = UIFont.systemFont(ofSize: 16)
        return tv
    }()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    // MARK: - Actions
    
    @objc func didTapCancle() {
        dismiss(animated: true)
    }

    // MARK: - Helpers

    func setupLayout() {
        view.backgroundColor = .white
        
        navigationItem.title = "새 게시물"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "취소", style: .done, target: self, action: #selector(didTapCancle))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "공유", style: .done, target: self, action: #selector(didTapDone))
        
        view.addSubview(photoImageView)
        photoImageView.snp.makeConstraints { make in
            make.height.width.equalTo(180)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(8)
            make.centerX.equalToSuperview()
        }

        view.addSubview(captionTextView)
        captionTextView.snp.makeConstraints { make in
            make.top.equalTo(photoImageView.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-12)
            make.height.equalTo(64)
        }
    }
}

