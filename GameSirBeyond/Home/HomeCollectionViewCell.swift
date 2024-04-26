//
//  HomeCollectionViewCell.swift
//  GameSirBeyond
//
///
/////  Created by leslie lee on 2024/3/7.
//

import UIKit
#if targetEnvironment(simulator)
// "模拟器"
#else
// "真机"
import SwiftVideoBackground
#endif

class HomeCollectionViewCell: UICollectionViewCell, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource {
    
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
        collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: "CustomCollectionViewCell")
        collectionView.register(CollectionHeaderCell.self, forCellWithReuseIdentifier: "CollectionHeaderCell")
        collectionView.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderView")
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
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
            guard let newCell = cell as? CustomCollectionViewCell else { return }
            if newCell.model?.type == 4 {
                //数据类型 1应用 2资讯 3类别 4精彩瞬间
                newCell.pauseVideo()
            }
        }
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
            guard let newCell = cell as? CustomCollectionViewCell else { return }
            newCell.isFocus = false
            if newCell.model?.type == 4 {
                //数据类型 1应用 2资讯 3类别 4精彩瞬间
                newCell.pauseVideo()
            }
        }
        
        if let nearest = nearestCell {
            if let indexPath = collectionView.indexPath(for: nearest) {
                print("Nearest cell index path: \(indexPath)")
                guard let cell = nearestCell as? CustomCollectionViewCell else { return }
                cell.isFocus = true
                cell.contentView.alpha = 1
                cell.titleLabel.alpha = 1
                cell.logoView.alpha = 1
                if cell.model?.type == 4 {
                    //数据类型 1应用 2资讯 3类别 4精彩瞬间
                    cell.playVideo()
                }
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
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCollectionViewCell", for: indexPath) as! CustomCollectionViewCell
        cell.titleLabel.text = "sectionNum :\(self.sectionNum) \n item \(indexPath.item)  "
        cell.titleLabel.numberOfLines = 0
        if indexPath.item == 0 {
            cell.isFocus = true
        }
        cell.maxScale = maxScale
        cell.model = gameListModel?.list[indexPath.item]
        return cell
        
    }
    
    func playVideo(){
        // 获取 collectionView 当前可见的 cell
        let visibleCells = collectionView.visibleCells
        
        for cell in visibleCells {
            guard let newCell = cell as? CustomCollectionViewCell else { return }
            if newCell.model?.type == 4 && newCell.isFocus {
                //数据类型 1应用 2资讯 3类别 4精彩瞬间
                newCell.playVideo()
            }
        }
    }
    
    
    func removeVideoView(){
        // 获取 collectionView 当前可见的 cell
        let visibleCells = collectionView.visibleCells
        
        for cell in visibleCells {
            guard let newCell = cell as? CustomCollectionViewCell else { return }
            if newCell.model?.type == 4 {
                //数据类型 1应用 2资讯 3类别 4精彩瞬间
                print("pauseVideo")
                newCell.pauseVideo()
            }
        }
    }
    
    
}






class CustomCollectionViewCell: UICollectionViewCell {
    var isFocus:Bool = false
    var maxScale:CGFloat = 1.0
    var model:SimpleListModel?{
        didSet{
            titleLabel.text = model?.name
            backImageView.sd_setImage(with: URL.init(string: model?.cover_image ?? ""))
        }
    }
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    let backImageView: UIImageView = {
        let img = UIImageView.init(image: UIImage(named: "backImage_default"))
        img.contentMode = .scaleAspectFill
        return img
    }()
    
    let logoView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
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
        contentView.addSubview(logoView)
        backImageView.snp.makeConstraints { make in
            make.left.top.bottom.right.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.left.equalTo(self.left).offset(8)
            $0.bottom.equalTo(self.bottom).offset(-48)
        }
        
        logoView.snp.makeConstraints {
            $0.width.equalTo(120)
            $0.height.equalTo(26)
            $0.left.equalTo(self.left).offset(0)
            $0.bottom.equalTo(self.bottom).offset(-8)
        }
        let appImg = UIImageView.init(image: UIImage(named: "appsotre_icon"))
        logoView.addSubview(appImg)
        appImg.snp.makeConstraints { make in
            make.left.equalTo(logoView.snp.left).offset(10)
            make.centerY.equalToSuperview()
            make.width.equalTo(40)
            make.height.equalTo(26)
        }
        let appImg2 = UIImageView.init(image: UIImage(named: "xbox_icon"))
        logoView.addSubview(appImg2)
        appImg2.snp.makeConstraints { make in
            make.left.equalTo(appImg.snp.right).offset(10)
            make.centerY.equalToSuperview()
            make.width.equalTo(40)
            make.height.equalTo(26)
        }
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        
        if (layoutAttributes.transform.a > 1.01 && isFocus){
            let customX = (1 - (layoutAttributes.transform.a  - 1.0) / (maxScale - 1.0))*60
            let alpha = (layoutAttributes.transform.a  - 1.0) / (maxScale - 1.0)
            titleLabel.alpha = alpha
            logoView.alpha = alpha
            logoView.snp.updateConstraints { make in
                make.left.equalTo(self.left).offset(-customX)
            }
        }else{
            titleLabel.alpha = 0.0
            logoView.alpha = 0.0
            logoView.snp.updateConstraints { make in
                make.left.equalTo(self.left).offset(0)
            }
        }
    }
    
    func playVideo() {
        if model!.video_url != "" {
            guard let bgView = contentView.viewWithTag(888) else{
                let newVideoBgView = UIView.init(frame: bounds)
                addSubview(newVideoBgView)
                newVideoBgView.tag = 888
                waitingToPlayVideoBgView = newVideoBgView
                waitingToPlayVideoUrl = URL(string: model!.video_url)!
                appPlayVideo()
                return
            }
            
            appPlayVideo()
            print(model!.video_url)
        }
    }
    
    func pauseVideo() {
        appPauseVideo()
    }
    
    
}
private extension UICollectionViewCell {
    struct Constant {
        static let featuredHeight: CGFloat = 280
        static let standardHegiht: CGFloat = 100
        
        static let minAlpha: CGFloat = 0.3
        static let maxAlpha: CGFloat = 1.0
    }
}
extension UIColor {
    static var random: UIColor {
        return UIColor(red: .random(in: 0...1),
                       green: .random(in: 0...1),
                       blue: .random(in: 0...1),
                       alpha: 1.0)
    }
}

class HeaderView: UICollectionReusableView {
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 10)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    private func setupUI() {
        addSubview(titleLabel)
        //        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        //        NSLayoutConstraint.activate([
        //            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
        ////            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
        ////            titleLabel.topAnchor.constraint(equalTo: topAnchor),
        //            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        //        ])
        titleLabel.snp.makeConstraints {
            $0.left.bottom.equalToSuperview()
        }
    }
}
class FooterView: UICollectionReusableView {
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    private func setupUI() {
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
