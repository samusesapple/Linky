//
//  NewFolderAlertViewController.swift
//  Linky
//
//  Created by Sam Sung on 2023/04/19.
//

import UIKit
import RealmSwift

protocol AddFolderAlertControllerDelegate: AnyObject {
    func createNewFolder(newFolder: Folder)
}

class AddFolderAlertController: UIViewController {
    
    // MARK: - Properties
    
    weak var delegate: AddFolderAlertControllerDelegate?
    
    private let alertView: UIView = {
        let view = UIView()
        view.setDimensions(height: 370, width: 250)
        view.backgroundColor = .white
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        view.layer.shadowOpacity = 0.5
        view.layer.shadowRadius = 2.5
        view.layer.cornerRadius = 10
        return view
    }()
    
    private let alertLabel: UILabel = {
        let label = UILabel()
        label.text = "새 폴더"
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = .black
        return label
    }()
    
    private var iconBox: UIButton = {
        let view = UIButton()
        view.setDimensions(height: 150, width: 150)
        view.layer.borderColor = UIColor.gray.cgColor
        view.layer.borderWidth = 1
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        return view
    }()
    
    private let iconTextField: UITextField = {
        let tf = EmojiTextField()
        tf.placeholder = "+"
        tf.font = UIFont.systemFont(ofSize: 40, weight: .light)
        tf.returnKeyType = .done
        return tf
    }()
    
    private let titleTextField: UITextField = {
        let tf = CustomTextField(placeholder: "폴더명 (최대 8글자)")
        tf.layer.borderColor = UIColor.gray.cgColor
        tf.font = UIFont.systemFont(ofSize: 15)
        tf.layer.borderWidth = 1
        tf.setDimensions(height: 35, width: 150)
        tf.returnKeyType = .done
        return tf
    }()
    private let saveButton: UIButton = {
        let button = CustomButton(type: .system)
        button.setDimensions(height: 35, width: 150)
        button.setTitle("생성", for: .normal)
        button.backgroundColor = UIColor(named: "MainGreenColor")?.withAlphaComponent(0.5)
        button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        return button
    }()
    
    
    private let cancelButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "x.circle.fill")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .gray
        button.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 33/255, green: 33/255, blue: 33/255, alpha: 0.3)
        view.addSubview(alertView)
        alertView.centerInSuperview()
        
        iconTextField.delegate = self
        titleTextField.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        configureUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: self.view.window)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: self.view.window)
    }
    
    // MARK: - Actions
    @objc func addButtonTapped() {
        guard iconTextField.text?.isEmpty != true else { return }
        let folder = Folder()
        folder.icon = iconTextField.text
        folder.title = titleTextField.text
        
        delegate?.createNewFolder(newFolder: folder)
        
        self.dismiss(animated: true)
    }
    
    @objc func cancelButtonTapped() {
        self.dismiss(animated: true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if view.frame.origin.y == 0 {
                view.frame.origin.y -= keyboardSize.height / 4
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if view.frame.origin.y != 0 {
            view.frame.origin.y = 0
        }
    }
    
    // MARK: - Helpers
    func configureUI() {
        alertView.addSubview(alertLabel)
        alertLabel.centerX(inView: alertView)
        alertLabel.anchor(top: alertView.topAnchor, paddingTop: 20)
        
        alertView.addSubview(cancelButton)
        cancelButton.centerY(inView: alertLabel)
        cancelButton.anchor(left: alertView.leftAnchor, paddingLeft: 20)
        
        alertView.addSubview(iconBox)
        iconBox.centerX(inView: alertView)
        iconBox.anchor(top: alertLabel.bottomAnchor, paddingTop: 20)
        
        iconBox.addSubview(iconTextField)
        iconTextField.centerInSuperview()
        
        alertView.addSubview(titleTextField)
        titleTextField.centerX(inView: alertView)
        titleTextField.anchor(top: iconBox.bottomAnchor, paddingTop: 25)
        
        alertView.addSubview(saveButton)
        
        saveButton.centerX(inView: alertView)
        saveButton.anchor(bottom: alertView.bottomAnchor, paddingBottom: 35)
    }
    
}

extension AddFolderAlertController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text,
              let rangeOfTextToReplace = Range(range, in: textFieldText) else {
            return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        if textField == iconTextField {
            return count <= 1 } else { return count <= 8 }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    
}
