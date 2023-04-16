//
//  ViewController.swift
//  Linky
//
//  Created by Sam Sung on 2023/04/16.
//

import UIKit

class MainViewController: UIViewController {
    
    // MARK: - Properties
    private let headerView = MainHeaderView()
    private let bottomView = BottomButtonView()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.showsHorizontalScrollIndicator = false
        // collectionView의 delegate, dataSource 세팅, cell 등록
        cv.delegate = self
        cv.dataSource = self
        cv.register(FileCell.self, forCellWithReuseIdentifier: "fileCell")
        return cv
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureUI()

    }
    
    // MARK: - Actions
    
    
    
    // MARK: - Helpers
    
    func configureUI() {
        view.addSubview(headerView)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        
        view.addSubview(bottomView)
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        bottomView.centerX(inView: view)
        bottomView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -22).isActive = true
        
        view.addSubview(collectionView)
        collectionView.anchor(top: headerView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 150, height: 313)
    }
    

    
}


// MARK: - UICollectionViewDataSource
extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // collectionView에 사용할 cell dequeue하기
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "fileCell", for: indexPath) as! FileCell
        cell.contentView.backgroundColor = .white
        return cell
    }
    
}

// MARK: - UICollectionViewDelegate
extension MainViewController: UICollectionViewDelegate {
    // 셀 선택되면 실행되는 함수
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       print("Cell selected")
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension MainViewController: UICollectionViewDelegateFlowLayout {
    // 매 인덱스마다 cell 사이즈 정해주기
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 190, height: collectionView.frame.height)
    }
}


