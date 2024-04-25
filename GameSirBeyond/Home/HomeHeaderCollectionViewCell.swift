//
//  HomeHeaderCollectionViewCell.swift
//  GameSirBeyond
//
//  Created by leslie lee on 2024/4/16.
//

import UIKit

class HomeHeaderCollectionViewCell: UICollectionViewCell, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource {
    
    var sectionNum: Int = 0
    var maxScale: CGFloat = 1.0
    var collectionView: UICollectionView!
    var gameListModel:GameListModel?{
        didSet {
            collectionView.reloadData()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        contentView.addSubview(titleLabel)
//        titleLabel.snp.makeConstraints { make in
//            let leftInset = GlobalConstants.safeAreaInsets.left
//            make.left.equalToSuperview().offset(leftInset)
//            make.top.equalToSuperview().offset(16)
//        }
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
        collectionView.register(CollectionHeaderCell.self, forCellWithReuseIdentifier: "CollectionHeaderCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.left.right.bottom.equalToSuperview()
        }
        
    }
        
    private func createLayout() -> UICollectionViewLayout {
        let layout =  GSHorizontalFlowLayout()
        layout.itemSize = CGSize(width: 156 , height: 88)
        layout.scrollDirection = .horizontal
        layout.itemSpacing = 10.0
        layout.sideItemScale = 1.625
        layout.sideItemAlpha = 0.7
        layout.sideItemOffset = 0.0
        layout.sideItemBaselineType = .bottom
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
               let distance = abs(cellX - 70)
               if distance < minDistance {
                   minDistance = distance
                   nearestCell = cell
               }
               guard let newCell = cell as? CollectionHeaderCell else { return }
               newCell.isFocus = false
           }
           
           if let nearest = nearestCell {
               if let indexPath = collectionView.indexPath(for: nearest) {
                   print("Nearest cell index path: \(indexPath)")
                   guard let cell = nearestCell as? CollectionHeaderCell else { return }
                   cell.isFocus = true
                   cell.contentView.alpha = 1
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
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionHeaderCell", for: indexPath) as! CollectionHeaderCell
        cell.titleLabel.text = "sectionNum :\(self.sectionNum) \n item \(indexPath.item)  "
        cell.titleLabel.numberOfLines = 0
        cell.subTitleLabel.text = "查看详情"
        if indexPath.item == 0 {
            cell.isFocus = true
        }
        cell.maxScale = maxScale
        cell.model = gameListModel?.list[indexPath.item]
        return cell
    }
   
}


class CollectionHeaderCell: UICollectionViewCell {
    
    var maxScale:CGFloat = 1.625
    
    var isFocus:Bool = false
    var model:SimpleListModel?{
        didSet{
            titleLabel.text = model?.name
            backImageView.sd_setImage(with: URL.init(string: model?.back_image ?? ""))
            
        }
    }
    let backImageView: UIImageView = {
        let img = UIImageView.init(image: UIImage(named: "backImage_default"))
        img.contentMode = .scaleAspectFill
        return img
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14 ,weight: .bold)
        return label
    }()
    
    let subTitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 8)
        return label
    }()
    
    let buttonImage: UIImageView = {
        let imageView = UIImageView.init(image: UIImage(named: "gamepad_key_a"))
        return imageView
    }()
    
    let platformImage: UIImageView = {
        let imageView = UIImageView.init(image: UIImage(named: "appsotre_icon"))
        return imageView
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
        
        backImageView.clipsToBounds = true
        backImageView.addGradientMask(colors: [UIColor.hex("#000000", alpha: 0.80),UIColor.hex("#000000", alpha: 0.18)], locations: [0.0, 1])
    }
    
    private func setupUI() {
        addSubview(backImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subTitleLabel)
        contentView.addSubview(buttonImage)
        contentView.addSubview(platformImage)
        backImageView.snp.makeConstraints { make in
            make.left.top.bottom.right.equalToSuperview()
        }
       
        
        buttonImage.snp.makeConstraints {
            $0.left.equalTo(self.left).offset(10)
            $0.width.height.equalTo(12)
            $0.bottom.equalTo(self.snp.bottom).offset(-8)
        }
        subTitleLabel.snp.makeConstraints {
            $0.left.equalTo(self.buttonImage.snp.right).offset(5)
            $0.centerY.equalTo(self.buttonImage).offset(0)
        }
        platformImage.snp.makeConstraints {
            $0.right.equalTo(self.snp.right).offset(-8)
            $0.width.equalTo(25)
            $0.height.equalTo(16)
            $0.centerY.equalTo(self.buttonImage).offset(-2)
        }
        
        titleLabel.snp.makeConstraints {
            $0.left.equalTo(self.snp.left).offset(10)
            $0.bottom.equalTo(self.buttonImage.snp.top).offset(-5)
        }
    }
     
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        if (layoutAttributes.transform.a > 1.0 && isFocus){
            let scale = (layoutAttributes.transform.a / maxScale)
            let alpha = (layoutAttributes.transform.a  - 1.0) / (maxScale - 1.0)
            //        titleLabel.layer.anchorPoint = CGPoint(x: 0, y: 1.0) //取值0～1
            //        titleLabel.transform = CGAffineTransform(scaleX: scale, y: scale)
//            print("alpha:\(alpha)   transform: \(layoutAttributes.transform.a)  maxScale:\(maxScale)")
            contentView.alpha = alpha
        }else{
            contentView.alpha = 0.0
        }
    }
    
    
}
extension UIImageView {
    
    func addGradientMask(colors: [UIColor], locations: [NSNumber]? = nil) {
        // 创建 CAGradientLayer 实例
        let gradientLayer = CAGradientLayer()
        
        // 设置渐变层的大小为 UIImageView 的大小
        gradientLayer.frame = bounds
        
        // 设置渐变的颜色
        gradientLayer.colors = colors.map { $0.cgColor }
        
        // 设置渐变的位置
        gradientLayer.locations = locations
        
        // 添加渐变层到 UIImageView 的 layer 中
        layer.mask = gradientLayer
    }
}
