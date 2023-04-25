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
        button.setDimensions(height: 50, width: 272)
        return button
    }()
    
    private let linkShareButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "link"), for: .normal)
        button.setDimensions(height: 23, width: 23)
        button.tintColor = UIColor(named: "MainGreenColor")
        return button
    }()
    
    private let memoTextField: UITextField = {
        let tv = CustomTextField(placeholder: "(선택) 표시할 제목을 입력해주세요.")
        let space = UIView()
        space.setDimensions(height: 38, width: 13)
        tv.leftView = space
        tv.setDimensions(height: 50, width: 272)
        tv.layer.borderWidth = 1
        tv.layer.borderColor = UIColor.gray.cgColor
        tv.clipsToBounds = true
        return tv
    }()
    
    private let linkInputTextView: UIView = {
        let view = UIView()
        view.setDimensions(height: 120, width: 272)
        view.layer.borderColor = UIColor.gray.cgColor
        view.layer.borderWidth = 1
        view.clipsToBounds = true
        view.layer.cornerRadius = 15
        view.backgroundColor = .clear
        
       let tv = UITextView()
        tv.textColor = .black
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.textAlignment = .left
        tv.backgroundColor = .clear
        tv.autocapitalizationType = .none
        tv.autocorrectionType = .no
        tv.spellCheckingType = .no
        tv.text = "복사한 링크를 입력해주세요."
        tv.clearsOnInsertion = true
        view.addSubview(tv)
        tv.setDimensions(height: 102, width: 272 - 24)
        tv.centerX(inView: view)
        tv.centerY(inView: view)
        tv.isEditable = true
        return view
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
        // set Delegate
        let linkTextView = linkInputTextView.subviews[0] as! UITextView
        linkTextView.delegate = self
        memoTextField.delegate = self
        
        folderButton.setTitle("기본 폴더", for: .normal)
        view.addSubview(folderButton)
        folderButton.anchor(top: viewTitleLabel.bottomAnchor, paddingTop: 40)
        folderButton.centerX(inView: view)
        
        let viewStack = UIStackView(arrangedSubviews: [linkInputTextView, memoTextField])
        viewStack.axis = .vertical
        viewStack.spacing = 30
        viewStack.distribution = .equalSpacing
        
        view.addSubview(viewStack)
        viewStack.anchor(top: folderButton.bottomAnchor, paddingTop: 65)
        viewStack.centerX(inView: view)
        
        view.addSubview(linkShareButton)
        linkShareButton.anchor(bottom: viewStack.topAnchor, right: viewStack.rightAnchor, paddingBottom: 7)
        
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
        guard let linkTextView = linkInputTextView.subviews[0] as? UITextView else { return }
        // 간혹 업데이트 안되고 새로 생성되는 버그 개선 필요
        guard linkTextView.text.count > 17 else { return }

        let folderID = viewModel.folderArray.filter { $0.title == folderButton.titleLabel?.text }.first?.folderID
        let linkData = Link()
        linkData.date = Date()
        linkData.folderID = folderID
        linkData.memo = memoTextField.text
        linkData.urlString = linkTextView.text
        
        if linkData.urlString == viewModel.linkData?.urlString {
            viewModel.updateLink(link: linkData)
        } else { viewModel.createLink(link: linkData) }
        
        delegate?.updateLink(link: linkData)
        
        self.dismiss(animated: true)
    }
    
    @objc func linkShareButtonTapped() {
        let linkTextView = linkInputTextView.subviews[0] as! UITextView
        UIPasteboard.general.string = linkTextView.text
    }
    
    // MARK: - Helpers
    func configureUI() {
        guard let data = viewModel.linkData else { return }
        viewTitleLabel.text = "링크 수정"
        guard let linkTextView = linkInputTextView.subviews[0] as? UITextView else { return }
        linkTextView.isEditable = false
        linkTextView.text = data.urlString
        memoTextField.text = data.memo

        DispatchQueue.main.async { [weak self] in
            self?.folderButton.setTitle(self?.viewModel.folderTitle, for: .normal)
        }
    }
    
    func setButtonActions() {
        folderButton.addTarget(self, action: #selector(folderButtonTapped), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        linkShareButton.addTarget(self, action: #selector(linkShareButtonTapped), for: .touchUpInside)
    }
    
    func setFolderPicker() {
        let folderPicker = UIPickerView()
        view.addSubview(folderPicker)
        folderPicker.delegate = self
        folderPicker.dataSource = self
        folderPicker.anchor(top: memoTextField.bottomAnchor, width: folderButton.frame.width, height: 120)
        folderPicker.centerX(inView: view)
    }
    
}

// MARK: - UIPickerViewDataSource
extension AddLinkViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 35
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

// MARK: - UITextFieldDelegate
extension AddLinkViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - UITextViewDelegate
extension AddLinkViewController: UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "복사한 링크를 입력해주세요." {
            textView.text = nil
            textView.textColor = .lightGray
        } else {
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = "복사한 링크를 입력해주세요."
            textView.textColor = .lightGray
        } else {
            textView.textColor = .black
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text?.count == 1 {
            if textView.text?.first == " " {
                textView.text = ""
                return
            }
        }
        textView.textColor = .black
    }
}
