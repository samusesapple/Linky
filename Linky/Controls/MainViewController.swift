//
//  ViewController.swift
//  Linky
//
//  Created by Sam Sung on 2023/04/16.
//

import UIKit
import RealmSwift


class MainViewController: UIViewController {
    
    // MARK: - Properties
    
    private var viewModel = MainViewViewModel()
        
    private let footerAddButton = AddLinkButton(type: .system)
    
    private let cellSize = CGSize(width: 190, height: 313)
    private var minItemSpacing: CGFloat = 20
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
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        view.backgroundColor = .white
        
        // set navigationBar
        let searchVC = SearchResultViewController()
        let searchController = UISearchController(searchResultsController: searchVC)
        searchVC.customDelegate = self
        self.navigationItem.searchController = searchController
        self.navigationItem.searchController?.searchBar.placeholder = "전체에서 링크 찾기"
        navigationController?.navigationBar.tintColor = .darkGray
        searchController.searchResultsUpdater = self
        
        configureUI()
        setupCollectionView()
        
        footerAddButton.addTarget(self, action: #selector(addLinkButtonTapped), for: .touchUpInside)
        setDefaultMenu()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.setSharedLinkData()
        resetCollectionView()
    }
    
    // MARK: - Actions
    @objc func addLinkButtonTapped() {
        let addVC = AddLinkViewController()
        addVC.delegate = self
        present(addVC, animated: true)
    }
    
    
    
    // MARK: - Helpers
    func setDefaultMenu() {
        guard viewModel.folderArray.count < 1 else { return }
        let folder = Folder()
        folder.icon = ""
        folder.title = "기본 폴더"
        viewModel.createNewFolder(folder: folder)
    }
    
    func configureUI() {
        view.addSubview(footerAddButton)
        footerAddButton.centerX(inView: view)
        footerAddButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingBottom: 22)
        
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.setDimensions(height: 313, width: view.frame.width)
        collectionView.centerInSuperview()        
    }
    
    func setupCollectionView() {
        collectionView.contentInsetAdjustmentBehavior = .never
        let cellWidth: CGFloat = floor(cellSize.width)
        let insetX = (view.bounds.width - cellWidth) / 2.0
        
        collectionView.contentInset = UIEdgeInsets(top: 0, left: insetX, bottom: 0, right: insetX)
        collectionView.decelerationRate = .fast
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func resetCollectionView() {
        collectionView.reloadData()
        let indexPath = collectionView.indexPathsForSelectedItems?.last ?? IndexPath(item: 0, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    
}

// MARK: - UICollectionViewDataSource
extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.folderArray.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // collectionView에 사용할 cell dequeue하기
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "folderCell", for: indexPath) as! FolderCell
        cell.delegate = self
        cell.contentView.backgroundColor = .white
        if indexPath.row != 0 {
            cell.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        }
        
        if viewModel.folderArray.count > indexPath.row { cell.viewModel = FolderCellViewModel(folder: viewModel.folderArray[indexPath.item])
            cell.fileButton.layer.borderWidth = 0
        } else if indexPath.item == viewModel.folderArray.count {
            cell.viewModel = FolderCellViewModel()
        }

        
        return cell
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



// MARK: - FileCellDelegate
extension MainViewController: FolderCellDelegate {
    func presentAlertView(cell: FolderCell) {
        cell.shake()
        let alert = UIAlertController(title: "폴더 삭제시, 해당되는 링크 또한 삭제됩니다.", message: nil, preferredStyle: .actionSheet)
        let delete = UIAlertAction(title: "폴더 삭제", style: .destructive) { [weak self] action in
            guard (self?.viewModel.folderArray.count)! > 1 else {
                cell.stopShaking(); self?.makeToast(message: "최소 1개 이상의 폴더가 필요합니다.\n\n*새로운 폴더를 만든 후, 기존 폴더를 삭제해주세요 :)")
                return }
            guard let folderID = cell.viewModel?.folder?.folderID else { return }
            self?.viewModel.deleteFolder(folderID: folderID)
            DispatchQueue.main.async { [weak self] in
                self?.resetCollectionView()
                cell.stopShaking()
            }
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel) { action in
            cell.stopShaking()
        }
        
        alert.addAction(delete)
        alert.addAction(cancel)
        
        if self.presentedViewController == nil {
            self.present(alert, animated: true, completion: nil)
            }
        }
        
    
    func presentFolderView(folder: Folder) {
        let folderVC = FolderViewController(folder: folder)
        folderVC.delegate = self
        navigationController?.pushViewController(folderVC, animated: true)
    }
    
    func addNewFolder() {
        let alertVC = AddFolderAlertController()
        alertVC.delegate = self
        alertVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        alertVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.present(alertVC, animated: true)
        
    }
    
}

// MARK: - AddFolderAlertControllerDelegate
extension MainViewController: AddFolderAlertControllerDelegate {
    func createNewFolder(newFolder: Folder) {
        viewModel.createNewFolder(folder: newFolder)
        resetCollectionView()
    }
}

// MARK: - AddLinkDelegate
extension MainViewController: AddLinkViewControllerDelegate {
    func updateLink(link: Link) {
        resetCollectionView()
    }
    
}

extension MainViewController: FolderViewControllerDelegate {
    func needsToUpdate() {
        print(#function)
        resetCollectionView()
    }
    
}

// MARK: - UISearchResultsUpdating
extension MainViewController: UISearchResultsUpdating, SearchResultViewControllerDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text?.lowercased() else { return }
        let resultVC = searchController.searchResultsController as! SearchResultViewController
        resultVC.viewModel.getLinks(with: text)
    }
    
}
