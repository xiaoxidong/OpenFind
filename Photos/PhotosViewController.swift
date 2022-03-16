//
//  PhotosViewController.swift
//  Photos
//
//  Created by Zheng on 11/18/21.
//

import SwiftUI

class PhotosViewController: UIViewController, PageViewController, Searchable {
    var tabType: TabState = .photos
    
    var model: PhotosViewModel
    var tabViewModel: TabViewModel
    var toolbarViewModel: ToolbarViewModel
    var searchNavigationModel: SearchNavigationModel
    var searchViewModel: SearchViewModel
    var slidesSearchViewModel: SearchViewModel
    var slidesSearchPromptViewModel: SearchPromptViewModel
    var permissionsViewModel = PhotosPermissionsViewModel()
    var resultsHeaderViewModel = ResultsHeaderViewModel()
    
    var headerContentModel = HeaderContentModel()
    lazy var resultsHeaderView = ResultsHeaderView(model: resultsHeaderViewModel)
    
    var baseSearchBarOffset = CGFloat(0)
    var additionalSearchBarOffset: CGFloat? = CGFloat(0)
    var updateNavigationBar: (() -> Void)?
    
    /// selection
    var selectBarButton: UIBarButtonItem!
    var photosSelectionViewModel = PhotosSelectionViewModel()
    lazy var selectionToolbar = PhotosSelectionToolbarView(model: photosSelectionViewModel)
    lazy var scanningIconController = PhotosScanningIconController(model: model)
    lazy var scanningNavigationViewController = UINavigationController(
        rootViewController: PhotosScanningViewController(model: model)
    )
    
    // MARK: Collection View
    @IBOutlet weak var collectionViewContainer: UIView!
    @IBOutlet var collectionView: UICollectionView!
    lazy var flowLayout = PhotosCollectionFlowLayout(model: model)
    lazy var dataSource = makeDataSource()
    typealias DataSource = UICollectionViewDiffableDataSource<PhotosSection, Photo>
    typealias Snapshot = NSDiffableDataSourceSnapshot<PhotosSection, Photo>
    
    @IBOutlet var resultsCollectionView: UICollectionView!
    lazy var resultsFlowLayout = createFlowLayout()
    lazy var resultsDataSource = makeResultsDataSource()
    typealias ResultsDataSource = UICollectionViewDiffableDataSource<PhotoSlidesSection, FindPhoto>
    typealias ResultsSnapshot = NSDiffableDataSourceSnapshot<PhotoSlidesSection, FindPhoto>
    
    // MARK: Filtering
    @IBOutlet weak var sliderContainerView: UIView!
    @IBOutlet weak var sliderContainerViewHeightC: NSLayoutConstraint!
    @IBOutlet weak var sliderContainerViewBottomC: NSLayoutConstraint!
    
    init?(
        coder: NSCoder,
        model: PhotosViewModel,
        tabViewModel: TabViewModel,
        toolbarViewModel: ToolbarViewModel,
        searchNavigationModel: SearchNavigationModel,
        searchViewModel: SearchViewModel,
        slidesSearchViewModel: SearchViewModel,
        slidesSearchPromptViewModel: SearchPromptViewModel
    ) {
        self.model = model
        self.tabViewModel = tabViewModel
        self.toolbarViewModel = toolbarViewModel
        self.searchNavigationModel = searchNavigationModel
        self.searchViewModel = searchViewModel
        self.slidesSearchViewModel = slidesSearchViewModel
        self.slidesSearchPromptViewModel = slidesSearchPromptViewModel
        super.init(coder: coder)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("You must create this view controller with metadata.")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Photos"
        setup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        baseSearchBarOffset = getCompactBarSafeAreaHeight(with: Global.safeAreaInsets)
        if model.resultsState != nil {
            updateNavigationBlur(with: resultsCollectionView)
        } else {
            updateNavigationBlur(with: collectionView)
        }
    }
}
