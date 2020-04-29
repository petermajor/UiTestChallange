import UIKit
import Resolver

class HomeViewController: UIViewController {

    @Injected private var homeViewModel: HomeViewModel
    
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<SectionType, ShowcaseEventKey>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.accessibilityIdentifier = "HomeViewController"
        
        let layout = createCompositionalLayout()
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        collectionView.register(FeaturedCell.self, forCellWithReuseIdentifier: FeaturedCell.reuseIdentifier)
        collectionView.register(OnDemandCell.self, forCellWithReuseIdentifier: OnDemandCell.reuseIdentifier)
        collectionView.register(SectionView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionView.reuseIdentifier)
        view.addSubview(collectionView)
        
        dataSource = UICollectionViewDiffableDataSource<SectionType, ShowcaseEventKey>(collectionView: collectionView, cellProvider: getCell)
        dataSource.supplementaryViewProvider = getSupplementaryView

        homeViewModel.sections.bind { [weak self] (_, _) in
            self?.reload()
        }
        
        navigationItem.title = homeViewModel.title

        reload()
    }
    
    private func reload() {
        guard let sections = homeViewModel.sections.value else { return }
        
        var snapshot = NSDiffableDataSourceSnapshot<SectionType, ShowcaseEventKey>()
        
        snapshot.appendSections(sections.map { $0.type })
        sections.forEach { snapshot.appendItems($0.events, toSection: $0.type) }
        dataSource.apply(snapshot)
        
        scrollToFirstItemInEachSection(eventsInSections: sections)
    }
    
    private func scrollToFirstItemInEachSection(eventsInSections: [SectionViewModel]) {
        for (sectionIndex, section) in eventsInSections.enumerated() {
            if section.events.count > 0 {
                DispatchQueue.main.async { [weak self] in
                    self?.collectionView.scrollToItem(at: IndexPath(item: 0, section: sectionIndex), at: UICollectionView.ScrollPosition.centeredHorizontally, animated: false)
                }
            }
        }
    }

    private func getCell(collectionView: UICollectionView, indexPath: IndexPath, eventKey: ShowcaseEventKey) -> UICollectionViewCell? {
        switch indexPath.section {
        case SectionType.onDemand.rawValue:
            guard let viewModel = homeViewModel.getOnDemandCellModel(for: eventKey) else { return nil }
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnDemandCell.reuseIdentifier, for: indexPath) as! OnDemandCell
            cell.bind(with: viewModel)
            return cell
        default:
            guard let viewModel = homeViewModel.getFeaturedCellModel(for: eventKey) else { return nil }
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeaturedCell.reuseIdentifier, for: indexPath) as! FeaturedCell
            cell.bind(with: viewModel)
            return cell
        }
    }
    
    private func getSupplementaryView(collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? {
        guard let eventsInSections = homeViewModel.sections.value else { return nil }
        let viewModel = eventsInSections[indexPath.section]
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionView.reuseIdentifier, for: indexPath) as! SectionView
        view.bind(with: viewModel)
        return view
    }
    
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout(sectionProvider: createLayoutSection)
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        configuration.interSectionSpacing = 20
        layout.configuration = configuration
        return layout
    }
    
    private func createLayoutSection(sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        let isWideView = layoutEnvironment.container.effectiveContentSize.width > 500
        switch sectionIndex {
        case SectionType.onDemand.rawValue:
            return self.createOnDemandLayoutSection(isWideView: isWideView)
        default:
            return self.createFeaturedLayoutSection(isWideView: isWideView)
        }
    }
    
    private func createFeaturedLayoutSection(isWideView: Bool) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)
        let groupSize = NSCollectionLayoutSize(widthDimension: isWideView ? .fractionalWidth(0.46) : .fractionalWidth(0.92), heightDimension: .absolute(350))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        return section
    }
    
    private func createOnDemandLayoutSection(isWideView: Bool) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.2))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.93), heightDimension: .absolute(370))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        let sectionHeader = createSectionHeader()
        section.boundarySupplementaryItems = [sectionHeader]
        return section
    }
    
    private func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let sectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(80))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: sectionHeaderSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        sectionHeader.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        return sectionHeader
    }
}

/* not implemented yet
extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        homeViewModel.itemTapped(for: indexPath)
    }
}
*/
