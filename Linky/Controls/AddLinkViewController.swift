//
//  AddViewController.swift
//  Linky
//
//  Created by Sam Sung on 2023/04/17.
//

import UIKit

protocol AddLinkViewControllerDelegate: AnyObject {
    func updateLink(link: Link)
}

class AddLinkViewController: UIViewController {
    
    // MARK: - Properties
    var viewModel = AddLinkViewModel() {
        didSet {
            configureUI()
        }
    }
    
    weak var delegate: AddLinkViewControllerDelegate?
    
    private let viewTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = "링크 추가"
        label.font = UIFont.systemFont(ofSize: 16)
        label.widthAnchor.constraint(equalToConstant: 60).isActive = true
        return label
    }()
    
    private let folderButton: UIButton = {
        let button = CustomButton(type: .system)
        button.backgroundColor = UIColor(named: "EditButtonColor")
        button.titleLabel?.textColor = .darkGray
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return button
    }()
    
    private let linkInputTextField = CustomTextFieldStack(placeholder: "링크를 입력해주세요.", width: 272)
    
    private let memoTextField: UITextField = {
        let tv = UITextField()
        let space = UIView()
        space.setDimensions(height: 38, width: 13)
        tv.leftView = space
        tv.leftViewMode = .always
        tv.setDimensions(height: 50, width: 272)
        tv.layer.borderWidth = 1
        tv.layer.borderColor = UIColor.gray.cgColor
        tv.clipsToBounds = true
        tv.layer.cornerRadius = 10
        tv.placeholder = "(선택) 메모를 입력해주세요."
        tv.clearButtonMode = .whileEditing
        tv.font = UIFont.systemFont(ofSize: 16)
        return tv
    }()
    
    private let backButton: UIButton = {
        let button = CustomButton(type: .system)
        button.heightAnchor.constraint(equalToConstant: 45).isActive = true
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(named: "MainGreenColor")?.cgColor
        button.backgroundColor = .clear
        return button
    }()
    private let saveButton: UIButton = {
        let button = CustomButton(type: .system)
        button.heightAnchor.constraint(equalToConstant: 45).isActive = true
        button.backgroundColor = UIColor(named: "MainGreenColor")?.withAlphaComponent(0.5)
        button.titleLabel?.textColor = .white
        return button
    }()
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(viewTitleLabel)
        viewTitleLabel.anchor(top: view.topAnchor, paddingTop: 30)
        viewTitleLabel.centerX(inView: view)
        
        let textField = linkInputTextField.subviews[0] as! UITextField
        textField.delegate = self
        
        folderButton.setTitle("기본 폴더", for: .normal)
        memoTextField.delegate = self
        let viewStack = UIStackView(arrangedSubviews: [folderButton, linkInputTextField, memoTextField])
        viewStack.axis = .vertical
        viewStack.spacing = 60
        viewStack.distribution = .equalSpacing
        
        view.addSubview(viewStack)
        viewStack.anchor(top: viewTitleLabel.bottomAnchor, paddingTop: 45)
        viewStack.centerX(inView: view)
        
        backButton.setTitle("취소", for: .normal)
        saveButton.setTitle("저장", for: .normal)
        let buttonStack = UIStackView(arrangedSubviews: [backButton, saveButton])
        buttonStack.axis = .horizontal
        buttonStack.spacing = 20
        buttonStack.distribution = .fillEqually
        buttonStack.setDimensions(height: 45, width: 272)
        
        view.addSubview(buttonStack)
        buttonStack.centerX(inView: view)
        buttonStack.anchor(bottom: view.bottomAnchor, paddingBottom: 100)
        setButtonActions()
        
        hideKeyboardWhenTappedAround()
    }
    
    
    // MARK: - Actions
    @objc func folderButtonTapped() {
        setFolderPicker()
    }
    
    @objc func backButtonTapped() {
        self.dismiss(animated: true)
    }
    
    @objc func saveButtonTapped() {
        let linkField = linkInputTextField.subviews[0] as! UITextField
        let folderID = viewModel.folderArray.filter { $0.title == folderButton.titleLabel?.text }.first?.folderID
        let linkData = Link()
        linkData.date = Date()
        linkData.folderID = folderID
        linkData.memo = memoTextField.text
        linkData.urlString = linkField.text
        
        delegate?.updateLink(link: linkData)
        self.dismiss(animated: true)
    }
    
    // MARK: - Helpers
    func configureUI() {
        guard let data = viewModel.linkData else { return }
        let linkField = linkInputTextField.subviews[0] as! UITextField
        viewTitleLabel.text = "링크 수정"
        linkField.isEnabled = false
        linkField.text = data.urlString
        memoTextField.text = data.memo
        
        
        guard let title = viewModel.folderTitle else { return }
        folderButton.setTitle(title, for: .normal)
        print(#function)
    }
    
    func setButtonActions() {
        folderButton.addTarget(self, action: #selector(folderButtonTapped), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
    }
    
    func setFolderPicker() {
        let folderPicker = UIPickerView()
        view.addSubview(folderPicker)
        folderPicker.delegate = self
        folderPicker.dataSource = self
        folderPicker.anchor(top: folderButton.bottomAnchor, bottom: linkInputTextField.topAnchor, width: folderButton.frame.width, height: 100)
        folderPicker.centerX(inView: view)
    }
    
}

// MARK: - UIPickerViewDataSource
extension AddLinkViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 30
    }

}
// MARK: - UIPickerViewDelegate
extension AddLinkViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        viewModel.folderNameArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return viewModel.folderNameArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerView.removeFromSuperview()
        folderButton.setTitle(viewModel.folderNameArray[row], for: .normal)
    }
}

extension AddLinkViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
