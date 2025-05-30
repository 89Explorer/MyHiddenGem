//
//  EateryDetailViewController.swift
//  MyHiddenGem
//
//  Created by 권정근 on 5/23/25.
//

import UIKit
import Combine


class EateryDetailViewController: UIViewController {
    
    
    // MARK: - Variable
    private var contentId: String = ""
    private var contentTypeId: String = ""
    
    
    private var detailVM: DetailViewModel = DetailViewModel()
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - UI Component
    
    private var detailCollectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<DetailSectionType, DetailItemType>?
    
    
    // MARK: - Init
    
    init(contentId: String, contentTypeId: String) {
        super.init(nibName: nil, bundle: nil)
        self.contentId = contentId
        self.contentTypeId = contentTypeId
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        print("✅ 선택된 음식점 Id: \(contentId)")
        setupNavigationBar()
        
        fetchDetailAllData(contentId: contentId, contentTypeId: contentTypeId)
        bindViewModel()
        
        setupCollectionView()
        createDataSource()
    }
    
}


// MARK: - Extension: 네비게이션을 설정하는 함수

extension EateryDetailViewController {
    
    /// 네비게이션바 설정하는 함수
    func setupNavigationBar() {
        //navigationItem.title = regionName
        
        navigationItem.hidesBackButton = true
        let backBarButton = UIBarButtonItem(image: UIImage(systemName: "chevron.backward.circle.fill"), style: .done, target: self, action: #selector(didTappedBackButton))
        backBarButton.tintColor = .label
        self.navigationItem.leftBarButtonItem = backBarButton
        
        let settingBarButton = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal"), style: .done, target: self, action: #selector(didTappedSettingButton))
        settingBarButton.tintColor = .label
        self.navigationItem.rightBarButtonItem = settingBarButton
    }
    
    /// 뒤로가기 액션 메서드
    @objc private func didTappedBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func didTappedSettingButton() {
        print("설정 버튼이 눌림")
        
        let actionSheet = ActionSheetViewController()
        
//        if let sheet = actionSheet.sheetPresentationController {
//            sheet.detents = [.medium()]
//        }
        
        present(actionSheet, animated: true)
    }
}


// MARK: - Extension: CollectionView 설정

extension EateryDetailViewController {
    
    
    /// 컬렉션뷰를 설정하는 메서드
    private func setupCollectionView() {
        detailCollectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompostionalLayout())
        detailCollectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        detailCollectionView.backgroundColor = .systemBackground
        detailCollectionView.showsHorizontalScrollIndicator = false
        detailCollectionView.showsVerticalScrollIndicator = false
        
        view.addSubview(detailCollectionView)
        
        detailCollectionView.register(RecommendationCell.self, forCellWithReuseIdentifier: RecommendationCell.reuseIdentifier)
        detailCollectionView.register(DetailIntroCell.self, forCellWithReuseIdentifier: DetailIntroCell.reuseIdentifier)
        detailCollectionView.register(DetailImageCell.self, forCellWithReuseIdentifier: DetailImageCell.reuseIdentifier)
        
        detailCollectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeader.reuseIdentifier)
        
    }
    
    
    private func reloadData() {
        
        guard let commonSection = detailVM.detailTotalModel.first(where: { $0.type == .common }) else {
            print("⚠️ .common 섹션이 없습니다.")
            return
        }
        
        guard let introSection = detailVM.detailTotalModel.first(where: { $0.type == .intro }) else {
            print("⚠️ .intro 섹션이 없습니다.")
            return
        }
        
        guard let imageSection = detailVM.detailTotalModel.first(where: { $0.type == .image }) else {
            print("⚠️ .image 섹션이 없습니다.")
            return
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<DetailSectionType, DetailItemType>()
        snapshot.appendSections([.common, .intro, .image])
        snapshot.appendItems(commonSection.item, toSection: .common)
        snapshot.appendItems(introSection.item, toSection: .intro)
        snapshot.appendItems(imageSection.item, toSection: .image)
        
        dataSource?.apply(snapshot, animatingDifferences: true)
        
    }
    
    
    private func createDataSource() {
        dataSource = UICollectionViewDiffableDataSource<DetailSectionType, DetailItemType>(
            collectionView: detailCollectionView
        ) { collectionView, indexPath, item in
            
            switch item {
            case .common(let commonInfo):
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: RecommendationCell.reuseIdentifier,
                    for: indexPath
                ) as? RecommendationCell else {
                    return UICollectionViewCell()
                }
                cell.configure(with: commonInfo)
                return cell
                
            case .intro(let intro):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailIntroCell.reuseIdentifier, for: indexPath) as? DetailIntroCell else { return UICollectionViewCell() }
                cell.configure(info: intro)
                return cell
                
            case .image(let image):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailImageCell.reuseIdentifier, for: indexPath) as? DetailImageCell else { return UICollectionViewCell() }
                cell.configure(info: image)
                return cell

            }
        }
        
        dataSource?.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            guard kind == UICollectionView.elementKindSectionHeader else { return nil }
            guard let sectionType = self?.dataSource?.snapshot().sectionIdentifiers[indexPath.section] else { return nil }
            
            guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: SectionHeader.reuseIdentifier,
                for: indexPath
            ) as? SectionHeader else { return nil }
            
            switch sectionType {
            case .intro:
                sectionHeader.configure(main: "기본 정보", sub: "")
                return sectionHeader
            case .image:
                sectionHeader.configure(main: "관련 이미지", sub: "")
                return sectionHeader
            default:
                return nil
            }
            
        }
    }

    
    
    private func createCompostionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout {
            sectionIndex, environment in
            let sectionIdentifier = DetailSectionType.allCases[sectionIndex]
            
            switch sectionIdentifier {
                
            case .common:
                return self.createFeaturedSection()
            case .intro:
                return self.createIntroSection()
            case .image:
                return self.createImageSection()
            }
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 5
        layout.configuration = config
        return layout
    }
    
    
    private func createFeaturedSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)
        
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.93), heightDimension: .estimated(300))
        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize, subitems: [layoutItem])
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.orthogonalScrollingBehavior = .groupPagingCentered
        
        return layoutSection
    }
    
    
    /// 상세페이지 내에 Intro 섹션 부분 UI 설정 메서드
    private func createIntroSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(300.0))
        
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        //layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(300.0))
        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize, subitems: [layoutItem])
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 15, bottom: 10, trailing: 15)
        
        let layoutSectionHeader = createSectionHeader()
        layoutSection.boundarySupplementaryItems = [layoutSectionHeader]
        return layoutSection
    }
    
    
    private func createImageSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1))
        
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)
        
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.93), heightDimension: .estimated(300))
        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize, subitems: [layoutItem])
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.orthogonalScrollingBehavior = .groupPagingCentered
        layoutSection.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 15, bottom: 10, trailing: 15)
        
        let layoutSectionHeader = createSectionHeader()
        layoutSection.boundarySupplementaryItems = [layoutSectionHeader]
        
        return layoutSection
    }
    
    
    
    private func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let layoutSectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.93), heightDimension: .estimated(80))
        let layoutSectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: layoutSectionHeaderSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top)
        return layoutSectionHeader
    }
    
}



// MARK: - Extension: 바인딩 목적

extension EateryDetailViewController {
    
    func fetchDetailAllData(contentId: String, contentTypeId: String) {
        
        Task {
            async let common:() = detailVM.fetchCommonIntroInfo(contentId: contentId)
            async let intro:() = detailVM.fetchDetailInfo(contentId: contentId, contentType: contentTypeId)
            async let image:() = detailVM.fetchDetailImageList(contentId: contentId)
            
            await common
            await intro
            await image
            
            // 모든 데이터가 완료된 후 섹션 생성
            detailVM.makeAllSections()
        }
    }
    
    private func bindViewModel() {
        detailVM.$detailTotalModel
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.reloadData()
            }
            .store(in: &cancellables)
    }
    
    
    
    //    private func bindViewModel() {
    //        detailVM.$detailTotalModel
    //            .receive(on: DispatchQueue.main)
    //            .sink { [weak self] sections in
    //                print("✅ 섹션 데이터 수신 완료")
    //
    //                for section in sections {
    //                    switch section.type {
    //                    case .common:
    //                        print("📘 [기본 정보]")
    //                        section.item.forEach { item in
    //                            if case let .common(title, value) = item {
    //                                print(" - \(title): \(value ?? "없음")")
    //                            }
    //                        }
    //
    //                    case .intro:
    //                        print("📗 [소개]")
    //                        section.item.forEach { item in
    //                            if case let .intro(title, value) = item {
    //                                print(" - \(title): \(value ?? "없음")")
    //                            }
    //                        }
    //
    //                    case .image:
    //                        print("📙 [이미지]")
    //                        section.item.forEach { item in
    //                            if case let .image(title, value) = item {
    //                                print(" - \(title): \(value ?? "없음")")
    //                            }
    //                        }
    //
    //                    }
    //                }
    //            }
    //            .store(in: &cancellables)
    //    }
}


