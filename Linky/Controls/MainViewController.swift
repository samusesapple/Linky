//
//  ViewController.swift
//  Linky
//
//  Created by Sam Sung on 2023/04/16.
//

import UIKit

protocol MainViewControllerDelegate: AnyObject {
    func didTapMenuButton()
}

class MainViewController: UIViewController {
    
    
    // MARK: - Properties
    weak var delegate: MainViewControllerDelegate?
    
    private let headerView = HeaderSearchView(icon: UIImage(systemName: "text.justify")!)
    private let footerAddButton = AddLinkButton()
    
    private let cellSize = CGSize(width: 190, height: 313)
    private var minItemSpacing: CGFloat = 20
    private var cellCount = 8
    private var previousIndex = 0
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.contentInsetAdjustmentBehavior = .never
        cv.backgroundColor = .clear
        cv.isPagingEnabled = false
        cv.decelerationRate = .fast
        cv.showsHorizontalScrollIndicator = false
        // collectionView의 delegate, dataSource 세팅, cell 등록
        cv.delegate = self
        cv.dataSource = self
        cv.register(FolderCell.self, forCellWithReuseIdentifier: "folderCell")
        return cv
    }()
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.isNavigationBarHidden = true
        configureUI()
        setupCollectionView()
        
        footerAddButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        headerView.delegate = self
    }
    
    
    // MARK: - Actions
    
    @objc func addButtonTapped() {
        let addVC = AddViewController()
        present(AddViewController(), animated: true)
    }
    
    
    // MARK: - Helpers
    
    func setupCollectionView() {
        collectionView.contentInsetAdjustmentBehavior = .never
        let cellWidth: CGFloat = floor(cellSize.width)
        let insetX = (view.bounds.width - cellWidth) / 2.0
        
        collectionView.contentInset = UIEdgeInsets(top: 0, left: insetX, bottom: 0, right: insetX)
        collectionView.decelerationRate = .fast
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func configureUI() {
        view.addSubview(headerView)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        
        view.addSubview(footerAddButton)
        footerAddButton.translatesAutoresizingMaskIntoConstraints = false
        footerAddButton.centerX(inView: view)
        footerAddButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -22).isActive = true
        
        view.addSubview(collectionView)
        collectionView.anchor(top: headerView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 150, height: 313)
        
        collectionView.centerX(inView: view)
    }
    
}


// MARK: - UICollectionViewDataSource
extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // collectionView에 사용할 cell dequeue하기
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "folderCell", for: indexPath) as! FolderCell
        //        cell.viewModel = FileCellViewModel(isFocused: true, labelText: "🎾", title: "개발", linkCount: 5)
        cell.delegate = self
        cell.contentView.backgroundColor = .white
        if indexPath.row != 0 {
            cell.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        }
        
        if indexPath.row == cellCount - 1 {
            print("indexPath row: \(indexPath.row)")
            print("indexPath count: \(indexPath.count)")
            cell.viewModel = FolderCellViewModel(isFocused: false, isEmpty: true, labelText: "", title: "", linkCount: 5)
        }
        
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
        return cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return minItemSpacing
    }
    
    // 페이지 넘어갈 때 호출 - 페이징 조정
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        //cell의 width + cell간 minimum inter spacing길이를 포함하는 cell의 넓이 정보
        let cellWidthIncludeSpacing = cellSize.width + minItemSpacing
        
        // 어디가 스크롤 중인 애니메이션이 끝나는 지점인지를 조정할 변수
        var offSet = targetContentOffset.pointee
        
        // 여태 스크롤한 스크롤뷰의 지점 위치 / spacing 포함된 cell 넓이 -> 해당되는 셀의 index 구하기
        let index = (offSet.x + scrollView.contentInset.left) / cellWidthIncludeSpacing
        
        // index값 반올림하기
        let roundedIndex: CGFloat = round(index)
        
        // 가운데로 정렬되게 페이징 되도록 스크롤 위치 설정
        offSet = CGPoint(x: roundedIndex * cellWidthIncludeSpacing - scrollView.contentInset.left, y: scrollView.contentInset.top)
        targetContentOffset.pointee = offSet
    }
    
    // Carousel Effect
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let cellWidthIncludeSpacing = cellSize.width + minItemSpacing
        let offSetX = collectionView.contentOffset.x
        let index = (offSetX + collectionView.contentInset.left) / cellWidthIncludeSpacing
        let roundedIndex = round(index)
        let indexPath = IndexPath(item: Int(roundedIndex), section: 0)
        if let cell = collectionView.cellForItem(at: indexPath) {
            animateZoomForCell(zoomCell: cell)
        }
        
        if Int(roundedIndex) != previousIndex {
            let preIndexPath = IndexPath(item: previousIndex, section: 0)
            if let preCell = collectionView.cellForItem(at: preIndexPath) {
                animateZoomForCellRemove(zoomCell: preCell)
            }
            previousIndex = indexPath.item
        }
    }
    
    private func animateZoomForCell(zoomCell: UICollectionViewCell) {
        UIView.animate(
            withDuration: 0.2,
            delay: 0,
            options: .curveEaseOut,
            animations: {
                zoomCell.transform = .identity
            },
            completion: nil)
    }
    
    private func animateZoomForCellRemove(zoomCell: UICollectionViewCell) {
        UIView.animate(
            withDuration: 0.2,
            delay: 0,
            options: .curveEaseOut,
            animations: {
                zoomCell.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
            },
            completion: nil)
    }
    
}

// MARK: - HeaderSearchViewDelegate
extension MainViewController: HeaderSearchViewDelegate {
    func handleLeftButtonActions() {
        delegate?.didTapMenuButton()
    }
    
    func searchLink() {
        print(#function)
    }
    
    
}

// MARK: - FileCellDelegate
extension MainViewController: FolderCellDelegate {
    
    func handleFileEdit() {
        print(#function)
    }
    
    func presentFileView() {
        let folderVC = FolderViewController()
        navigationController?.pushViewController(folderVC, animated: true)
    }
    
    func addNewFolder() {
        print(#function)
        // present add folder view
    }
}
