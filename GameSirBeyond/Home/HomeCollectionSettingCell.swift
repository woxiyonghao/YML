//
//  HomeCollectionSettingCell.swift
//  GameSirBeyond
//
//  Created by leslie lee on 2024/4/24.
//

import UIKit

//
//  HomeCollectionViewCell.swift
//  GameSirBeyond
//
///
/////  Created by leslie lee on 2024/3/7.
//

import UIKit
class HomeCollectionSettingCell: UICollectionViewCell, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource {
    
    var sectionNum: Int = 0
    var maxScale: CGFloat = 1.0
    var collectionView: UICollectionView!
    var gameListModel:GameListModel? {
        didSet {
            collectionView.reloadData()
        }
    }
    let titleLabel: UILabel = {
        let lab = UILabel()
        lab.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        lab.textColor = .white
        lab.text = "新游戏"
        return lab
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            let leftInset = 59.0
            make.left.equalToSuperview().offset(leftInset)
            make.top.equalToSuperview().offset(16)
        }
        configureCollectionView()
        //        print("init")
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureCollectionView()
        
    }
    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // 获取父视图（通常是 UICollectionView）
        guard let collectionView = self.superview as? UICollectionView else { return }
        
        // 获取安全布局指南
        let safeAreaLayoutGuide = collectionView.safeAreaLayoutGuide
        
        // 获取安全距离
        let safeAreaInsets = safeAreaLayoutGuide.layoutFrame.inset(by: collectionView.safeAreaInsets)
        
        // 在这里使用安全距离，例如打印它
        
        
    }
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: CGRect(x: 0, y:0, width: self.bounds.size.width, height: self.bounds.size.height), collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .clear
        collectionView.register(HomeSettingCell.self, forCellWithReuseIdentifier: "HomeSettingCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let layout =  GSHorizontalFlowLayout()
        layout.itemSize = CGSize(width: 200 , height: 100)
        layout.scrollDirection = .horizontal
        layout.itemSpacing = 10.0
        layout.sideItemScale = 1.0
        layout.sideItemAlpha = 0.7
        layout.sideItemOffset = 0.0
        return layout
    }
    

    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView){
        guard let collectionView = scrollView as? UICollectionView  else { return }
        
        // 获取 collectionView 当前可见的 cell
        let visibleCells = collectionView.visibleCells
        
        // 找到距离 x = cell.with/2 最近的 cell
        var nearestCell: UICollectionViewCell?
        var minDistance = CGFloat.greatestFiniteMagnitude
        
        for cell in visibleCells {
            let cellX = collectionView.convert(cell.frame.origin, to: nil).x
            let distance = abs(cellX - 100)
            if distance < minDistance {
                minDistance = distance
                nearestCell = cell
            }
            guard let newCell = cell as? HomeSettingCell else { return }
            newCell.isFocus = false
        }
        
        if let nearest = nearestCell {
            if let indexPath = collectionView.indexPath(for: nearest) {
                print("Nearest cell index path: \(indexPath)")
                guard let cell = nearestCell as? HomeSettingCell else { return }
                cell.isFocus = true
                cell.contentView.alpha = 1
                cell.titleLabel.alpha = 1
                cell.subTitleLabel.alpha = 1
            }
        }
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gameListModel?.list.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeSettingCell", for: indexPath) as! HomeSettingCell
        cell.titleLabel.text = "sectionNum :\(self.sectionNum) \n item \(indexPath.item)  "
        cell.titleLabel.numberOfLines = 0
        if indexPath.item == 0 {
            cell.isFocus = true
        }
        cell.maxScale = maxScale
        cell.model = gameListModel?.list[indexPath.item]
        return cell
        
    }

    
}






class HomeSettingCell: UICollectionViewCell {
    var isFocus:Bool = false
    var maxScale:CGFloat = 1.0
    var model:SimpleListModel?{
        didSet{
            titleLabel.text = model?.name
            subTitleLabel.text = model?.total_game_num
        }
    }
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 28, weight: .semibold)
        return label
    }()
    
    let subTitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.text = "168个游戏"
        label.textColor = UIColor.hex("#B4B4B4")
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // 设置统一的圆角
        layer.cornerRadius = 10
        layer.masksToBounds = true
       
    }
    
    private func setupUI() {
        contentView.addSubview(subTitleLabel)
        contentView.addSubview(titleLabel)
        contentView.backgroundColor = UIColor.hex("#3D434F")
        titleLabel.snp.makeConstraints {
            $0.left.equalTo(self.left).offset(18)
            $0.top.equalTo(self.top).offset(16)
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.left.equalTo(self.left).offset(18)
            $0.top.equalTo(titleLabel.snp.bottom).offset(1)
        }
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        
        if (layoutAttributes.transform.a > 1.01 && isFocus){
            let customX = (1 - (layoutAttributes.transform.a  - 1.0) / (maxScale - 1.0))*60
            let alpha = (layoutAttributes.transform.a  - 1.0) / (maxScale - 1.0)
            titleLabel.alpha = alpha
            subTitleLabel.alpha = alpha
        }else{
            titleLabel.alpha = 0.0
            subTitleLabel.alpha = 0.0
        }
    }
    

    
}


