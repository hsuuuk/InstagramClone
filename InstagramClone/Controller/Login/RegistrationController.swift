//
//  RegistrationController.swift
//  InstagramClone
//
//  Created by 심현석 on 2023/04/17.
//

import UIKit
import SnapKit
import FirebaseAuth

extension RegistrationController {
    @objc func handleSignUp() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        guard let fullName = fullNameTextField.text else { return }
        guard let userName = userNameTextField.text else { return }
        guard let profilImage = self.profilImage else { return }
        
        //        let credentials = AuthCredentials(email: email, password: password, fullname: fullname, username: username, profileImage: profilImage)
        //
        //        AuthServie.registerUser(withCredential: credentials) { error in
        //            if let error = error {
        //                print("DEBUG: Failed to register user \(error.localizedDescription)")
        //                return
        //            }
        //
        //            self.delegate?.authenticationDidComplete()
        //        }
        
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
                    
                    COLLECTION_USER.document(uid).setData(data)
                    
                    print("create success")
                    self.delegate?.loginComplete()
                }
            }
        }
    }
}

class RegistrationController: UIViewController {
    
    private var viewModel = RegistrationViewModel()
    
    private var profilImage: UIImage?
    
    weak var delegate: LoginDelegate?
    
    private let plusPhotoButton: UIButton = {
        let bt = UIButton(type: .system)
        bt.setImage(#imageLiteral(resourceName: "plus_photo"), for: .normal)
        bt.tintColor = .black
        bt.addTarget(self, action: #selector(handleProfilePhotoSelect), for: .touchUpInside)
        return bt
    }()
    
    private let emailTextField: CustomTextField = {
        let tf = CustomTextField(placeholder: "이메일")
        //tf.keyboardType = .emailAddress
        return tf
    }()
    
    private let passwordTextField: CustomTextField = {
        let tf = CustomTextField(placeholder: "비밀번호")
        //tf.isSecureTextEntry = true
        return tf
    }()
    
    private let fullNameTextField = CustomTextField(placeholder: "이름")
    private let userNameTextField = CustomTextField(placeholder: "사용자 이름")
    
    private lazy var signUpButton: UIButton = {
        let bt = UIButton(type: .system)
        bt.setTitle("가입하기", for: .normal)
        bt.setTitleColor(.white, for: .normal)
        bt.backgroundColor = .systemBlue
        bt.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        bt.layer.cornerRadius = 5
        bt.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        bt.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        //bt.isEnabled = false
        return bt
    }()
    
    private lazy var alreadyHaveAccountButton: UIButton = {
        let bt = UIButton()
        bt.attributedTitle(firstPart: "이미 가입되어 있으신가요?", secondPart: "돌아가기")
        bt.addTarget(self, action: #selector(handleShowLogIn), for: .touchUpInside)
        return bt
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureNotificationObservers()
        view.backgroundColor = .white
    }
    
    func configureUI() {
        //configureGradientLayer()
        
        view.addSubview(plusPhotoButton)
        plusPhotoButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).offset(32)
            make.height.width.equalTo(140)
        }
        
        let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, fullNameTextField, userNameTextField, signUpButton])
        stackView.axis = .vertical
        stackView.spacing = 20
        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalTo(plusPhotoButton.snp.bottom).offset(32)
            make.left.equalToSuperview().offset(32)
            make.right.equalToSuperview().offset(-32)
        }
        
        view.addSubview(alreadyHaveAccountButton)
        alreadyHaveAccountButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func configureNotificationObservers() {
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        fullNameTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        userNameTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
    
    @objc func handleShowLogIn() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func textDidChange(sender: UITextField) {
        if sender == emailTextField {
            viewModel.email = emailTextField.text
        } else if sender == passwordTextField {
            viewModel.password = passwordTextField.text
        } else if sender == fullNameTextField {
            viewModel.fullname = fullNameTextField.text
        } else {
            viewModel.username = userNameTextField.text
        }
        
        signUpButton.backgroundColor = viewModel.buttonBackgroundColor
        signUpButton.isEnabled = viewModel.formIsValid
    }
    
    @objc func handleProfilePhotoSelect() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        present(picker, animated: true)
    }
}

extension RegistrationController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let selectedImage = info[.editedImage] as? UIImage else { return }
        profilImage = selectedImage
        
        plusPhotoButton.layer.cornerRadius = plusPhotoButton.frame.width / 2
        plusPhotoButton.layer.masksToBounds = true
        plusPhotoButton.layer.borderColor = UIColor.white.cgColor
        plusPhotoButton.layer.borderWidth = 1
        plusPhotoButton.setImage(selectedImage.withRenderingMode(.alwaysOriginal), for: .normal)
        
        self.dismiss(animated: true)
    }
}

