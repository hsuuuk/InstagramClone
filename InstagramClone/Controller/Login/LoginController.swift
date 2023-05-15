//
//  LoginController.swift
//  InstagramClone
//
//  Created by 심현석 on 2023/04/17.
//

import UIKit
import SnapKit
import FirebaseAuth

protocol LoginDelegate: AnyObject {
    func loginComplete()
}

extension LoginController {
    @objc func handleLogin() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if error != nil {
                print("longin error")
            } else {
                print("login success")
                self.dismiss(animated: true)
                self.delegate?.loginComplete()
            }
        }
    }
}

class LoginController: UIViewController {
    
    weak var delegate: LoginDelegate?
    
    private let iconImage: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.image = #imageLiteral(resourceName: "Instagram_logo_black")
        return iv
    }()
    
    private let emailTextField: UITextField = {
        let tf = CustomTextField(placeholder: "전화번호, 사용자 이름 또는 이메일")
        tf.keyboardType = .emailAddress
        return tf
    }()
    
    private let passwordTextField: UITextField = {
        let tf = CustomTextField(placeholder: "비밀번호")
        tf.isSecureTextEntry = true
        return tf
    }()
    
    private lazy var loginButton: UIButton = {
        let bt = UIButton(type: .system)
        bt.setTitle("로그인", for: .normal)
        bt.setTitleColor(.white, for: .normal)
        bt.backgroundColor = .systemBlue
        bt.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        bt.layer.cornerRadius = 5
        bt.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        bt.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return bt
    }()
    
    private lazy var dontHaveAccountButton: UIButton = {
        let bt = UIButton()
        bt.attributedTitle(firstPart: "계정이 없으신가요?", secondPart: "가입하기")
        bt.addTarget(self, action: #selector(showRegister), for: .touchUpInside)
        return bt
    }()
    
    private lazy var forgotPasswordButton: UIButton = {
        let bt = UIButton()
        bt.attributedTitle(firstPart: "비밀번호를 잊으셨나요?", secondPart: "비밀번호 찾기")
        return bt
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLayout()
    }
    
    func setupLayout() {
        //navigationController?.navigationBar.isHidden = true
        //navigationController?.navigationBar.barStyle = .black
                
        view.addSubview(iconImage)
        iconImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).offset(150)
            make.height.equalTo(80)
            make.width.equalTo(120)
        }

        let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, loginButton])
        stackView.axis = .vertical
        stackView.spacing = 20
        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalTo(iconImage.snp.bottom).offset(32)
            make.left.equalToSuperview().offset(32)
            make.right.equalToSuperview().offset(-32)
        }
        
        view.addSubview(forgotPasswordButton)
        forgotPasswordButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(loginButton.snp.bottom).offset(10)
        }
        
        view.addSubview(dontHaveAccountButton)
        dontHaveAccountButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    @objc func showRegister() {
        let controller = RegisterController()
        controller.delegate = delegate
        navigationController?.pushViewController(controller, animated: true)
    }
}

