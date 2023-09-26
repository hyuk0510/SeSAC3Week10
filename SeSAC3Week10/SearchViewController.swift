//
//  SearchViewController.swift
//  SeSAC3Week10
//
//  Created by 선상혁 on 2023/09/21.
//

import UIKit
import SnapKit
import Kingfisher

class SearchViewController: UIViewController, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    let list = ["이모티콘", "새싹", "추석", "족발", "아아아아아", "abcdefg"]
    
    var collectionView = UICollectionView(frame: .zero, collectionViewLayout: configureTagLayout())
    var dataSource: UICollectionViewDiffableDataSource<Int, PhotoResult>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHierarchy()
        configureLayout()
        configureDataSource()
        
        let bar = UISearchBar()
        bar.delegate = self
        navigationItem.titleView = bar
        bar.backgroundColor = .white
    }
    
    func configureHierarchy() {
        view.addSubview(collectionView)
    }
    
    func configureLayout() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        Network.shared.requestConvertible(type: Photo.self, api: .search(query: searchBar.text!)) { response in
            switch response {
            case .success(let success):
                //데이터 + UI스냅샷
                let ratios = success.results.map { Ratio(ratio: $0.width / $0.height)}
                
                let layout = PinterestLayout(columnsCount: 2, itemRatios: ratios, spacing: 10, contentWidth: self.view.frame.width)
                
                self.collectionView.collectionViewLayout = UICollectionViewCompositionalLayout(section: layout.section)
                self.configureSnapshot(success)
                
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
    
    func configureSnapshot(_ item: Photo) {
        
        var snapshot = NSDiffableDataSourceSnapshot<Int, PhotoResult>()
        snapshot.appendSections([0])
        snapshot.appendItems(item.results)
        dataSource.apply(snapshot)
    }
    
    func configurePinterestLayout() -> UICollectionViewLayout {
        // .fractionalWidth, .absolute, .estimated
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .estimated(150))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(150))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 2)
        
        group.interItemSpacing = .fixed(10)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        section.interGroupSpacing = 10
        
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        configuration.scrollDirection = .vertical
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        layout.configuration = configuration
        
        return layout
    }
    
    static func configureTagLayout() -> UICollectionViewLayout {
        // .fractionalWidth, .absolute, .estimated
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(80), heightDimension: .fractionalHeight(1.0))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(80), heightDimension: .absolute(30))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        group.interItemSpacing = .fixed(10)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        section.interGroupSpacing = 10
        
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        configuration.scrollDirection = .vertical
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        layout.configuration = configuration
        
        return layout
    }
    
//    static func configureCollectionLayout() -> UICollectionViewLayout {
//        // .fractionalWidth, .absolute, .estimated
//
//        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3), heightDimension: .fractionalHeight(1.0))
//
//        let item = NSCollectionLayoutItem(layoutSize: itemSize)
//
//        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(80))
//
//        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 3)
//        group.interItemSpacing = .fixed(30)
//
//        let section = NSCollectionLayoutSection(group: group)
//        section.contentInsets = NSDirectionalEdgeInsets(top: 30, leading: 30, bottom: 30, trailing: 30)
//        section.interGroupSpacing = 30
//
//        let configuration = UICollectionViewCompositionalLayoutConfiguration()
//        configuration.scrollDirection = .horizontal
//
//        let layout = UICollectionViewCompositionalLayout(section: section)
//        layout.configuration = configuration
//
//        return layout
//    }
    
//    static func configureCollectionLayout() -> UICollectionViewLayout {
//        let layout = UICollectionViewFlowLayout()
//        layout.itemSize = CGSize(width: 50, height: 50)
//        layout.scrollDirection = .vertical
//        return layout
//    }
    
    func configureDataSource() {
        
        let cellRegistration = UICollectionView.CellRegistration<SearchCollectionViewCell, PhotoResult> { cell, indexPath, itemIdentifier in
            cell.imageView.kf.setImage(with: URL(string: itemIdentifier.urls.thumb)!)
            cell.label.text = "\(itemIdentifier.created_at)번"
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        })
   
    }
    
}

//class SearchViewController: UIViewController {
//
//    let scrollView = UIScrollView()
//    let contentView = UIView()
//
//    let imageView = UIImageView()
//    let label = UILabel()
//    let button = UIButton()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        configureHierarchy()
//        configureLayout()
//        configureContentView()
//    }
//
//    func configureContentView() {
//        contentView.addSubview(imageView)
//        contentView.addSubview(label)
//        contentView.addSubview(button)
//
//        imageView.backgroundColor = .orange
//        button.backgroundColor = .magenta
//        label.backgroundColor = .systemGreen
//
//        imageView.snp.makeConstraints { make in
//            make.top.horizontalEdges.equalTo(contentView).inset(10)
//            make.height.equalTo(200)
//        }
//
//        button.snp.makeConstraints { make in
//            make.bottom.horizontalEdges.equalTo(contentView).inset(10)
//            make.height.equalTo(80)
//        }
//
//        label.text = "Adfsa\nfs\nda\nsd\nfa\nsf\nds\nfasfadsAdfsa\nfs\nda\nsd\nfa\nsf\nds\nfasfadsAdfsa\nfs\nda\nsd\nfa\nsf\nds\nfasfadsAdfsa\nfs\nda\nsd\nfa\nsf\nds\nfasfadsAdfsa\nfs\nda\nsd\nfa\nsf\nds\nfasfadsAdfsa\nfs\nda\nsd\nfa\nsf\nds\nfasfads"
//        label.numberOfLines = 0
//        label.textColor = .white
//        label.snp.makeConstraints { make in
//            make.horizontalEdges.equalTo(contentView)
//            make.top.equalTo(imageView.snp.bottom).offset(50)
//            make.bottom.equalTo(button.snp.top).offset(-50)
//        }
//    }
//
//    func configureHierarchy() {
//        view.addSubview(scrollView)
//        scrollView.addSubview(contentView)
//    }
//
//    func configureLayout() {
//        scrollView.bounces = false
//        scrollView.backgroundColor = .lightGray
//        scrollView.snp.makeConstraints { make in
//            make.edges.equalTo(view.safeAreaLayoutGuide)
//        }
//
//        contentView.backgroundColor = .white
//        contentView.snp.makeConstraints { make in
//            make.verticalEdges.equalTo(scrollView)
//            make.width.equalTo(scrollView.snp.width)
//        }
//    }
//}

//class SearchViewController: UIViewController {
//
//    let scrollView = UIScrollView()
//    let stackView = UIStackView()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .white
//        configureHierarchy()
//        configureLayout()
//    }
//
//    func configureHierarchy() {
//        view.addSubview(scrollView)
//        scrollView.addSubview(stackView)
//    }
//
//    func configureLayout() {
//        scrollView.backgroundColor = .lightGray
//        scrollView.snp.makeConstraints { make in
//            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
//            make.height.equalTo(70)
//        }
//
//        stackView.spacing = 16
//        stackView.backgroundColor = .black
//        stackView.snp.makeConstraints { make in
//            make.height.equalTo(scrollView)
//        }
//        configureStackView()
//    }
//
//    func configureStackView() {
//        let label1 = UILabel()
//        label1.text = "안녕하세요"
//        label1.textColor = .white
//        label1.backgroundColor = .brown
//        stackView.addArrangedSubview(label1)
//
//        let label2 = UILabel()
//        label2.text = "가나다라"
//        label2.textColor = .white
//        stackView.addArrangedSubview(label2)
//
//        let label3 = UILabel()
//        label3.text = "1234"
//        label3.textColor = .white
//        stackView.addArrangedSubview(label3)
//
//        let label4 = UILabel()
//        label4.text = "asdf"
//        label4.textColor = .white
//        stackView.addArrangedSubview(label4)
//
//        let label5 = UILabel()
//        label5.text = "아아아아"
//        label5.textColor = .white
//        stackView.addArrangedSubview(label5)
//    }
//}
