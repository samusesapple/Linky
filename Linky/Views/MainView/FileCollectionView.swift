//
//  FileCollectionView.swift
//  Linky
//
//  Created by Sam Sung on 2023/04/16.
//

import UIKit

class FileCollectionView: UICollectionReusableView {

    // MARK: - Properties
    
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
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        addSubview(collectionView)
        collectionView.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 203, height: 260)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
// MARK: - UICollectionViewDataSource
extension FileCollectionView: UICollectionViewDataSource {
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
extension FileCollectionView: UICollectionViewDelegate {
    // 셀 선택되면 실행되는 함수
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       print("Cell selected")
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension FileCollectionView: UICollectionViewDelegateFlowLayout {
    // 매 인덱스마다 cell 사이즈 정해주기
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 190, height: 260)
    }
}

