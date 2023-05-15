//
//  RegistrationController.swift
//  InstagramClone
//
//  Created by 심현석 on 2023/04/17.
//

import UIKit
import SnapKit
import FirebaseAuth

extension RegisterController {
    @objc func didTapRegister() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        guard let fullName = fullNameTextField.text else { return }
        guard let userName = userNameTextField.text else { return }
        guard let profilImage = self.profilImage else { return }
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                ImageUploader.imageUpload(image: profilImage) { imageUrl in
                    guard let uid = authResult?.user.uid else { return }
                    
                    let data: [String: Any] = [
                        "email": email,
                        "password": password,
                        "uid": uid,
                        "fullName": fullName,
                        "userName": userName,
                        "profileImageUrl": imageUrl
                    ]
                    
                    COLLECTION_user.document(uid).setData(data)
                    
                    print("create success")
                    self.delegate?.loginComplete()
                }
            }
        }
    }
}

class RegisterController: UIViewController {
        
    private var profilImage: UIImage?
    
    weak var delegate: LoginDelegate?
    
    private let plusPhotoButton: UIButton = {
        let bt = UIButton(type: .system)
        bt.setImage(#imageLiteral(resourceName: "plus_photo"), for: .normal)
        bt.layer.cornerRadius = 140 / 2
        bt.layer.borderColor = UIColor.white.cgColor
        bt.layer.borderWidth = 1
        bt.layer.masksToBounds = true
        bt.tintColor = .black
        bt.addTarget(self, action: #selector(didTapProfilePhotoSelector), for: .touchUpInside)
        return bt
    }()
    
    private let emailTextField = CustomTextField(placeholder: "이메일")
    private let passwordTextField = CustomTextField(placeholder: "비밀번호")
    private let fullNameTextField = CustomTextField(placeholder: "이름")
    private let userNameTextField = CustomTextField(placeholder: "사용자 이름")
    
    private lazy var signUpButton: UIButton = {
        let bt = UIButton(type: .system)
        bt.setTitle("가입하기", for: .normal)
        bt.setTitleColor(.white, for: .normal)
        bt.backgroundColor = .systemBlue
        bt.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        bt.layer.cornerRadius = 5
        bt.addTarget(self, action: #selector(didTapRegister), for: .touchUpInside)
        return bt
    }()
    
    private lazy var alreadyHaveAccountButton: UIButton = {
        let bt = UIButton()
        bt.attributedTitle(firstPart: "이미 가입되어 있으신가요?", secondPart: "돌아가기")
        bt.addTarget(self, action: #selector(didTapAlready), for: .touchUpInside)
        return bt
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLayout()
    }
    
    func setupLayout() {
        view.addSubview(plusPhotoButton)
        plusPhotoButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).offset(32)
            make.height.width.equalTo(140)
        }
        
        let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, fullNameTextField, userNameTextField])
        stackView.axis = .vertical
        stackView.spacing = 20
        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalTo(plusPhotoButton.snp.bottom).offset(32)
            make.left.equalToSuperview().offset(32)
            make.right.equalToSuperview().offset(-32)
        }
        emailTextField.keyboardType = .emailAddress
        passwordTextField.isSecureTextEntry = false
        
        view.addSubview(signUpButton)
        signUpButton.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
            make.left.equalToSuperview().offset(32)
            make.right.equalToSuperview().offset(-32)
        }
        
        view.addSubview(alreadyHaveAccountButton)
        alreadyHaveAccountButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    @objc func didTapAlready() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func didTapProfilePhotoSelector() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
    }
}

extension RegisterController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.editedImage] as? UIImage else { return }
        profilImage = selectedImage
        plusPhotoButton.setImage(selectedImage.withRenderingMode(.alwaysOriginal), for: .normal)
        self.dismiss(animated: true)
    }
}

