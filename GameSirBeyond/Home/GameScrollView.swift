//
//  GameScrollView.swift
//  Eggshell
//
//  Created by 刘富铭 on 2022/10/19.
//

import UIKit

class GameScrollView: UIScrollView, UIScrollViewDelegate {
    
    // MARK: 参数定义
    private var lineCellWidths: [CGFloat] = []// 每行卡片的宽度
    private var lineCellHeights: [CGFloat] = []// 每行卡片的高度
    private let lineVerticalSpacing: CGFloat = 50// 行间距，需同时看见3行
    private var linesScales: [CGFloat] = []// 每行的Focus卡片的缩放比例，会变化
    private let maxScale: CGFloat = 1.2// 最大的缩放比例
    private var lineFrames: [CGRect] = []// 每行的frame，用于判断居中行
    private var lastOffsetY: CGFloat = -1
    private var isRecordCenterLine = false
    private var lastCenterLineIndex = -1
    private var centerUpLineIndex = -1// 处于屏幕中央2行的上行
    private var centerDownLineIndex = -1// 处于屏幕中央2行的下行
    private var isSwipingUp = false// 往上滑
    private var firstLineY = 0.0// 第一行的origin.y
    
    // MARK: 数据
    var topicModels: [TopicModel] = [] {
        didSet {
            if topicModels.count == 0 {
                return
            }
            
            for _ in topicModels {
                lineCellWidths.append(smallCardWidth())
                lineCellHeights.append(smallCardHeight())
            }
            
            initCollectionViews()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    let errorMsg = i18n(string: "An error occurred")
    let collectionViewStartTag = 888
    func initCollectionViews() {
        // 设定初始放大倍数，仅作用于Focus cell
        for index in 0..<lineCellWidths.count {
            if index == 0 {
                linesScales.append(1.2)
            }
            else {
                linesScales.append(1.0)
            }
        }
        
        var currentLineY = 0.0// 遍历时，当前行的origin.y
        for index in 0..<topicModels.count {
            let topicModel = topicModels[index]
            let cellWidth = lineCellWidths[index]
            let cellHeight = lineCellHeights[index]
            let collectionHeight = cellHeight*maxScale
            // 注意：行高collectionView.height = cellHeight*1.2
            if index == 0 {
                currentLineY = (UIScreen.main.bounds.size.height-collectionHeight)/2.0// 使第一行处于屏幕中央
                firstLineY = currentLineY
            }
            else if index > 0 {
                let lastCellHeight = lineCellHeights[index-1]
                let lastLineBottom = lastCellHeight*maxScale
                currentLineY += (lastLineBottom + lineVerticalSpacing)
            }
            
            // 创建CollectionView
            let flowLayout = UICollectionViewFlowLayout()
            flowLayout.scrollDirection = .horizontal
            flowLayout.itemSize = CGSize.init(width: cellWidth, height: cellHeight)
            // ❗️collectionView的height必须大于卡片的height，否则报错（这里设为1.2倍才不报错）
            let collectionView = GameCollectionView(frame: CGRect.init(x: 0, y: currentLineY, width: UIScreen.main.bounds.width, height: collectionHeight), collectionViewLayout: flowLayout)
            collectionView.tag = collectionViewStartTag+index
            collectionView.cellScale = linesScales[index]
            collectionView.backgroundColor = .clear
            collectionView.index = index
            if index == 0 {
                collectionView.isFocusing = true// 默认第一行focusing
            }
            addSubview(collectionView)
            var gameModels: [SimpleGameModel] = []
            for model in topicModel.games {
                let newModel = ModelManager.shared.getSimpleGameModelFrom(model: model)// 转数据
                gameModels.append(newModel)
            }
            // 主题类型
            if topicModel.type == 2 {// 分类主题
                collectionView.isCategoryTopic = true
            }
            else if topicModel.type == 3 {// 产品说明主题
                collectionView.isProductIntroTopic = true
            }
            
            // 数据
            if index == 0 {
                collectionView.collectionViewDatas = gameModels
                collectionView.updateBackgroundImage()// 放在设置数据后边
            }
            else {
                // 每隔0.5秒加载一行图片
                delay(interval: Double(index)/2.0) {
                    collectionView.collectionViewDatas = gameModels
                }
            }
            
            // 点击跳转页面
            collectionView.tapFocusingCell = { collectionView, row in
                if row < 0 || row >= collectionView.collectionViewDatas.count {
                    return
                }
                
                let gameModel = collectionView.collectionViewDatas[row]
//                print("主题类型：", gameModel.linkType)
                switch gameModel.linkType {
                case 0:// App内打开游戏详情页面
                    self.updateFocusingStatus(line: -1)
                    self.displayGameDetailViewFromHome(collectionView: collectionView, topicIndex: index)
                case 1:// App内跳转到游戏搜索页面，根据分类ID显示不同页面
                    if row < 0 || row >= gameModels.count {
                        return
                    }
                    
                    let model = gameModels[row]
                    let categoryId = model.categoryId
                    let categoryName = model.name
                    print("游戏类型：", categoryName)
                    print("跳转类型：App内跳转到游戏搜索页面");
                    self.updateFocusingStatus(line: -1)
                    self.displaySearchView(categoryId: categoryId, categoryName: categoryName)
                case 2:// App内打开视频播放页面
                    if row < 0 || row >= gameModels.count {
                        return
                    }
                    // TODO: 要求后台返回视频绑定的游戏ID
                    let model = gameModels[row]
                    let videoUrl = model.videoURL
                    let videoId = model.videoId
                    let likeNum = model.likeNum
                    let coverUrl = model.coverURL
                    print("视频地址：", videoUrl)
                    print("跳转类型：App内跳转到视频播放页面");
                    self.updateFocusingStatus(line: -1)
                    // 获取最新数据
                    self.displayHighlightDetailView(videoUrl: videoUrl, videoId: videoId, likeNum: likeNum, coverUrl: coverUrl)
                case 3:// App外跳转到H5链接
                    print("跳转类型：App外跳转到H5链接");
                    let success = self.jumpToSafari(urlString: gameModel.linkUrl)
                    if !success {
                        MBProgressHUD.showMsgWithtext(self.errorMsg)
                    }
                case 4:// App外跳转到App Store的游戏下载页面
                    print("跳转类型：App外跳转到App Store");
                    let downloadUrl = GameManager.shared.getDownloadUrlString(fromModel: gameModel)
                    let success = self.jumpToAppStoreDetailView(urlString: downloadUrl)
                    if !success {
                        MBProgressHUD.showMsgWithtext(self.errorMsg)
                    }
                case 5:// App内打开弹窗
                    print("跳转类型：App内打开弹窗");
                    self.displayPopView(gameModel: gameModel)
                case 6:// App外跳转到游戏App
                    print("跳转类型：App外打开游戏App");
                    let success = self.openGame(urlSchemes: gameModel.urlSchemes)
                    if !success {// 跳转App失败，则打开跳转链接
                        let downloadUrl = gameModel.linkUrl
                        let success = self.jumpToAppStoreDetailView(urlString: downloadUrl)
                        if !success {
                            MBProgressHUD.showMsgWithtext(self.errorMsg)
                        }
                    }
                default:
                    self.displayGameDetailViewFromHome(collectionView: collectionView, topicIndex: index)
                }
            }
            
            lineFrames.append(collectionView.frame)

            // 标题
            let titleLabel = UILabel.init(frame: CGRect.init(x: 57, y: currentLineY-40, width: UIScreen.main.bounds.size.width-57*2, height: 30))
            titleLabel.text = topicModel.title
            titleLabel.textColor = UIColor.white
            titleLabel.font = pingFangM(size: 20)
//            addSubview(titleLabel)
            titleLabel.tag = 999+index
        }
        
        contentSize = CGSize.init(width: UIScreen.main.bounds.width, height: currentLineY + lineCellHeights[lineCellHeights.count-1] + UIScreen.main.bounds.height/2.0)// height：增加半个屏幕高度，以便最后1行可以居中显示
    }
    
    func commonInit() {
        delegate = self
        contentInsetAdjustmentBehavior = .never
        decelerationRate = .fast
        showsVerticalScrollIndicator = false
    }
    
    // MARK: Highlight详情
    func displayHighlightDetailView(videoUrl: String, videoId: Int, likeNum: Int, coverUrl: String) {
        if videoUrl == "" {
            MBProgressHUD.showMsgWithtext(errorMsg)
            return
        }
        
        let destView = HighlightDetailView(frame: UIScreen.main.bounds)
        superview?.addSubview(destView)
        destView.videoUrl = videoUrl
        destView.likeNum = likeNum
        destView.videoId = videoId
        destView.coverUrl = coverUrl
        
        destView.closeCallback = {
            self.updateFocusingStatus(line: self.centerLineIndex)
        }
    }
    
    // MARK: 弹窗页
    func displayPopView(gameModel: SimpleGameModel) {
        let destView = GamePopView(frame: UIScreen.main.bounds)
        superview?.addSubview(destView)
        destView.titleLabel.text = gameModel.title
        destView.contentTextView.text = gameModel.content
        destView.imgView.sd_setImage(with: URL(string: gameModel.coverURL))
        
        destView.closeCallback = {
            self.updateFocusingStatus(line: self.centerLineIndex)
        }
    }
    
    // MARK: 跳转到Safari浏览器
    func jumpToSafari(urlString: String) -> Bool {
        if urlString.isEmpty {
            return false
        }
        
        if UIApplication.shared.canOpenURL(URL(string: urlString)!) {
            UIApplication.shared.open(URL(string: urlString)!)
            return true
        }
        
        return false
    }
    
    // MARK: 跳转到App Store的游戏详情页
    func jumpToAppStoreDetailView(urlString: String) -> Bool {
        return jumpToSafari(urlString: urlString)
    }
    
    // MARK: 打开游戏
    func openGame(urlSchemes: [String]) -> Bool {
        if urlSchemes.count == 0 {
            return false
        }
        
        for scheme in urlSchemes {
            let openUrl = URL.init(string: scheme + "://")!
            if UIApplication.shared.canOpenURL(openUrl) {
                UIApplication.shared.open(openUrl)
                return true
            }
        }
        
        return false
    }
    
    // MARK: 搜索游戏
    func displaySearchView(categoryId: Int, categoryName: String) {
        let destView = GameSearchView(frame: UIScreen.main.bounds)
        superview?.addSubview(destView)
        destView.categoryId = categoryId
        destView.categoryName = categoryName
        destView.searchGame(categoryId: categoryId)
        destView.didTapCloseButton = {
            destView.removeFromSuperview()
        }
        destView.didSelectGame = { gameModel in
            self.displayGameDetailFromSearchView(gameModel: gameModel)
        }
    }
    
    // MARK: 搜索页的游戏详情
    func displayGameDetailFromSearchView(gameModel: SearchGameModel) {
        let detailView = GameDetailView.init(frame: UIScreen.main.bounds)
        superview?.addSubview(detailView)
        detailView.scrollView.collectionModels = [gameModel]
        detailView.scrollView.focusIndexPath = IndexPath(row: 0, section: 0)
        detailView.scrollView.gameCollectionView.isHidden = false
        detailView.backCallback = {
            detailView.removeFromSuperview()
        }
    }
    
    // MARK: 游戏详情
    // 4.0
    func displayGameDetailViewFromHome(collectionView: GameCollectionView, topicIndex: Int) {
        /** 动画过程
         进入：创建GameDetailView且隐藏游戏列表；放大collectionView并移动到superview后隐藏；显示游戏列表；隐藏collectionView
         退出：删除GameDetailView；显示collectionView；缩小并移动到self上
         */
        
        let detailView = GameDetailView.init(frame: UIScreen.main.bounds)
        superview?.addSubview(detailView)
        // 先设置focusIndexPath，再设置collectionModels，否则无法滚动到特定卡片
        detailView.scrollView.focusIndexPath = collectionView.focusIndexPath
        detailView.scrollView.collectionModels = topicModels[topicIndex].games
        
        let originalCollectionViewFrame = collectionView.frame// 转换frame前记录frame
        let convertFrame = convert(collectionView.frame, to: superview)
        collectionView.frame = convertFrame
        superview?.addSubview(collectionView)// 重点：把collectionView移到superview
        let destY = CGRectGetMinY(collectionView.frame) -  (CGRectGetHeight(frame)/2-CGRectGetHeight(collectionView.frame)/2)+32
        UIView.animate(withDuration: animationDuration()) {
            collectionView.cellSize = CGSize(width: superBigCardWidth(), height: superBigCardHeight())
            collectionView.frame = CGRect(x: 0, y: destY, width: CGRectGetWidth(self.frame), height: superBigCardHeight()*self.maxScale)
            collectionView.reloadData()
        } completion: { _ in
            delay(interval: 0.2) {
                detailView.scrollView.gameCollectionView.isHidden = false
                
                collectionView.isHidden = true
                self.addSubview(collectionView)// 把collectionView移回scrollView，以免影响手柄操作
                let convertFrame = self.superview!.convert(collectionView.frame, to: self)
                collectionView.frame = convertFrame
            }
        }
        
        // 返回操作
        detailView.backCallback = {
            collectionView.focusIndexPath = detailView.scrollView.gameCollectionView.focusIndexPath// 更新焦点
            detailView.removeFromSuperview()
            collectionView.isHidden = false

            UIView.animate(withDuration: animationDuration(), delay: 0.0, options: .curveEaseIn) {
                collectionView.cellSize = CGSize(width: smallCardWidth(), height: smallCardHeight())
                collectionView.frame = originalCollectionViewFrame
                collectionView.reloadData()
            } completion: { _ in
                self.updateFocusingStatus(line: self.centerLineIndex)
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//        print(#function)
        updateFocusingStatus(line: -1)// 重置focusing状态
    }
    
    
    // MARK: 需求一：ScrollView上下滑动时，更改中间2行的缩放比例
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        print("偏移量：", scrollView.contentOffset.y)
        
        var offsetY = scrollView.contentOffset.y
        if offsetY < 0 {
            offsetY = 0
        }
        
        // 更新背景图模糊效果
//        if offsetY <= 0 {
//            (UIViewController.current() as? GameViewController)?.updateBackgroundTransparency(alpha: 0.2)
//        }
//        else {
            // 0 -> 0  10 ->0.2  20-> 0.4  30 -> 0.6  40 -> 0.8  50 -> 1.0
            (UIViewController.current() as? GameViewController)?.updateBackgroundTransparency(alpha: offsetY*0.02+0.2)
//        }
        
        // 保证在特定偏移量处，目标行的scale为maxScale
        for line in 0..<lineCellWidths.count {
            if offsetY == CGFloat(line)*(smallCardHeight()*maxScale+lineVerticalSpacing) {// 0、182、182*2...
                let collectionView = self.viewWithTag(collectionViewStartTag + line) as? GameCollectionView
                collectionView?.cellScale = maxScale
                collectionView?.updateLayout(animated: true)
                return
            }
        }
        
        // 1. 确定滑动方向
        var swipeUp = false
        if lastOffsetY < 0 {// 第一次滑动
            if offsetY > 0 {
                swipeUp = true
            }
            else if offsetY < 0 {
                swipeUp = false
            }
        }
        else {// 第二次及以后滑动
            if offsetY > lastOffsetY {// 数值变大 -> 上滑
                swipeUp = true
            }
            else if lastOffsetY > offsetY {// 数值变小 -> 下滑
                swipeUp = false
            }
        }
        
        lastOffsetY = offsetY
        isSwipingUp = swipeUp
        
        // 2. 判断当前处于中间的行Index
        var centerLineIndex = -1
        for index in 0..<lineFrames.count {
            let frame = lineFrames[index]
            if frame.contains(CGPoint.init(x: 0, y: offsetY + UIScreen.main.bounds.height/2)) {
                centerLineIndex = index
                lastCenterLineIndex = index
                break
            }
        }
        
        if centerLineIndex == -1 {// 没有行处于中间
            if isRecordCenterLine == false {
                if swipeUp {
                    if lastCenterLineIndex >= lineCellWidths.count-1 { return }
                    
                    centerUpLineIndex = lastCenterLineIndex
                    centerDownLineIndex = lastCenterLineIndex + 1
                    updateUpLineLayout()
                    updateDownLineLayout()
                }
                else {
                    if lastCenterLineIndex == 0 { return }
                    
                    centerUpLineIndex = lastCenterLineIndex - 1
                    centerDownLineIndex = lastCenterLineIndex
                    updateUpLineLayout()
                    updateDownLineLayout()
                }
                
                isRecordCenterLine = true
            }
            else {// 根据之前确定的行，继续计算一些数据，进行更细的判断
                updateUpLineLayout()
                updateDownLineLayout()
            }
        }
        else {
            isRecordCenterLine = false// 复位
        }
    }
    
    // 根据collectionView的底部和屏幕中线的距离，算出缩放比例，并缩放
    func updateUpLineLayout() {
        if centerUpLineIndex < 0 { return }
        
        // 1.算出目标行的frame与中线的差距diff
        let scrollViewCenterY = contentOffset.y + UIScreen.main.bounds.height/2// scrollView的中线的y值会随着滚动一直变化
        let targetCollectionViewFrame = lineFrames[centerUpLineIndex]
        let targetCollectionViewBottom = targetCollectionViewFrame.origin.y + targetCollectionViewFrame.size.height
        let diff = abs(scrollViewCenterY - targetCollectionViewBottom)
        // 2.根据差距diff和行间距lineVerticalSpacing算出该行变化的scale
        let scale = calculateScaleWith(diff: diff)
        // 3.根据scale更新目标行
        updateCollectionView(lineIndex: centerUpLineIndex, scale: scale, animated: false)// 不能使用动画，否则会出现UI问题
//        print("=====\n接近【第\(centerUpLineIndex)行】，还差\(diff)，比例：\(scale)")
    }
    
    // 根据collectionView的顶部和屏幕中线的距离，算出缩放比例，并缩放
    func updateDownLineLayout() {
        if centerDownLineIndex < 0 { return }
        
        let scrollViewCenterY = contentOffset.y + UIScreen.main.bounds.height/2
        let targetCollectionViewFrame = lineFrames[centerDownLineIndex]
        let targetCollectionViewTop = targetCollectionViewFrame.origin.y
        let diff = abs(scrollViewCenterY - targetCollectionViewTop)
        // 最后一行特殊处理：滑动时，当屏幕中心线大于该行的centerY，不再处理该行的缩放。以解决问题：滑到最后一行后，继续往上滑，当屏幕中心线大于最后一行的底部，回弹时，最后一行的的Focus cell的缩放倍率变为1.0
        if centerDownLineIndex == lineFrames.count - 1 &&
            scrollViewCenterY > targetCollectionViewTop + targetCollectionViewFrame.size.height/2.0 { return }
        
        let scale = calculateScaleWith(diff: diff)
        updateCollectionView(lineIndex: centerDownLineIndex, scale: scale, animated: false)// 不能使用动画，否则会出现UI问题
//        print("=====\n接近【第\(centerDownLineIndex)行】，还差\(diff)，比例：\(scale)")
    }
    
    /** 计算Scale
     scale由行间距lineVerticalSpacing 和 目标行的frame与屏幕横向中线的差距diff 的差值决定。
     差值越小（表示距离中线越远，最小为0），scale越小，最小为1.0；
     差值越大（表示距离中线越近，最大为lineVerticalSpacing），scale越大，最大为maxScale。
     */
    func calculateScaleWith(diff: CGFloat) -> CGFloat {
//        var scaleDiff = 0.0// 0.00 ~ 0.20 只精确到小数点后3位
//        let cuts: CGFloat = 200// 分越多份，过渡越细腻
//        for index in 0..<Int(cuts) {// 根据差值算出合适scale值，注意Int和Float的运算，保证scaleDiff的正确
//            let left = lineVerticalSpacing*CGFloat(index) / cuts
//            let right = lineVerticalSpacing*CGFloat(index+1) / cuts
//
//            if diff > left && diff <= right {
//                let scaleDiffString = String.init(format: "%.4f", (maxScale - 1.0)/cuts * CGFloat(index+1))
//                scaleDiff = Double(scaleDiffString)!// 精确到小数点后3位，影响卡片缩放过渡效果。精确度是2的效果不好
//            }
//        }
//        let scaleString = String.init(format: "%.4f", maxScale - scaleDiff)
//        let scale = Double(scaleString)!
//        return scale
        
        // TODO: 解决问题：diff到不了最大值lineVerticalSpacing和最小值0
//        let maxScale: CGFloat = 1.2 // 定义最大缩放比例
//        let minScale: CGFloat = 1.0 // 定义最小缩放比例
//        let scaleRange = maxScale - minScale // 缩放范围
//        let maxDiff = lineVerticalSpacing // 定义最大差量
//        var scale = maxScale - (diff / maxDiff) * scaleRange // 根据偏移量计算缩放比例
//        scale = min(max(scale, minScale), maxScale) // 确保缩放比例在最小值和最大值之间
//
//        // 最终修正：防止出现1.17、1.05等比例（这也会影响临界时的放大缩小的速度）
//        if scale >= maxScale-0.02 {
//            scale = maxScale
//        }
//        else if scale <= minScale+0.02 {
//            scale = minScale
//        }
//
//        return scale
        
        var scaleDiff = 0.0// 0.00 ~ 0.20 只精确到小数点后2位
        let cuts: CGFloat = 500// 分越多份，过渡越细腻
        let scaleRange = maxScale - 1.0
        let boundScaleRange = 0.01// 临近边界的缩放率容错值
        if true {
            for index in 0..<Int(cuts) {// 根据差值算出合适scale值，注意Int和Float的运算，保证scaleDiff的正确
                let left = lineVerticalSpacing*CGFloat(index) / cuts
                let right = lineVerticalSpacing*CGFloat(index+1) / cuts
                if diff > left && diff <= right {
                    let scaleDiffString = String.init(format: "%.3f", (maxScale - 1.0)/cuts * CGFloat(index+1))
                    scaleDiff = Double(scaleDiffString)!
                    break
                }
            }
            // 会出现diff == 50.00000000000006的情况
            if diff >= lineVerticalSpacing {
                scaleDiff = scaleRange
            }
            // 边界容错
            if scaleDiff <= boundScaleRange {
                scaleDiff = 0.0
            }
            else if scaleDiff >= scaleRange-boundScaleRange && scaleDiff <= scaleRange {
                scaleDiff = scaleRange
            }
        }
        
        let scaleString = String.init(format: "%.3f", maxScale - scaleDiff)
        var scale = Double(scaleString)!
        if scale >= maxScale - boundScaleRange {
            scale = maxScale
        }
        else if scale <= 1.0 + boundScaleRange {
            scale = 1.0
        }
        return scale
    }
    
    // 上下滑动时更新指定行的卡片布局
    func updateCollectionView(lineIndex: Int, scale: CGFloat, animated: Bool) {
        if lineIndex == 1 { print("第1行Scale：\(scale)") }
        if lineIndex < 0 || lineIndex > lineCellWidths.count-1 { return }
        
        let collectionView = self.viewWithTag(collectionViewStartTag + lineIndex) as? GameCollectionView
        collectionView?.cellScale = scale
        collectionView?.updateLayout(animated: animated)
    }
    
    // MARK: 需求二：ScrollView上下滑动停止后，目标行停留在屏幕中间
    // 手指松开时触发（后于scrollViewWillEndDragging）
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        print(#function)
        // 如果即将开始减速，说明滑动还没停止，因此这里不做任何处理
        if decelerate { return }
        
        _ = scrollTo(line: calculateDestinationLineAfterScrolling())
    }
    // 停止减速（触发前提：松开手指后仍在滑动）
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        print(#function)
        _ = scrollTo(line: calculateDestinationLineAfterScrolling())
    }
    // 算出停止滚动后应该居中显示的目标行。规则：以目标行的frame和屏幕中线的距离作为判断条件，差值最小的行是目标行
    func calculateDestinationLineAfterScrolling() -> Int {
        var targetLine = 0
        var smallestDiff = -1.0
        
        for index in 0..<lineFrames.count {// 最后一行空白行不参与
            let scrollViewCenterY = contentOffset.y + UIScreen.main.bounds.height/2
            let targetLineFrame = lineFrames[index]
            
            // 顶部距离
            let targetLineFrameTop = targetLineFrame.origin.y
            let topDiff = abs(scrollViewCenterY - targetLineFrameTop)
            
            // 底部距离
            let targetLineFrameBottom = targetLineFrame.origin.y + targetLineFrame.size.height
            let bottomDiff = abs(scrollViewCenterY - targetLineFrameBottom)

            // 取2个距离中最小的那个
            let targetDiff = topDiff >= bottomDiff ? topDiff : bottomDiff
            
            if smallestDiff < 0 {// 第一次记录
                smallestDiff = targetDiff
                targetLine = index
            }
            else if targetDiff < smallestDiff {// 保存更小值
                smallestDiff = targetDiff
                targetLine = index
            }
        }
        
        return targetLine
    }
    
    var centerLineIndex = 0// 居中行
    // 滚动到指定行，返回实际滚动行
    func scrollTo(line: Int) -> Int {
        if line < 0 {
            return 0
        }
        
        if line > lineCellWidths.count-1 {
            return lineCellWidths.count-1
        }

        let frame = lineFrames[line]
        let offsetY = frame.origin.y - (UIScreen.main.bounds.height - frame.size.height)/2// 此offsetY指屏幕顶部的offsetY
        setContentOffset(CGPoint.init(x: 0, y: offsetY), animated: true)
        
        centerLineIndex = line
        
        updateFocusingStatus(line: line)
        
        return line
    }
    
    // 更新行的Focus状态，可传入-1~9999
    func updateFocusingStatus(line: Int) {
        if line < 0 {
            appRemoveVideoPlayer()
        }
        
        for index in 0..<lineCellWidths.count {
            let tag = collectionViewStartTag+index
            let destView = viewWithTag(tag) as? GameCollectionView
            if index == line {
                destView?.isFocusing = true
            }
            else {
                destView?.isFocusing = false
            }
        }
    }
    
    // MARK: 手柄操控
    func gamepadKeyLeftAction() {
        let collectionView = self.viewWithTag(collectionViewStartTag + centerLineIndex) as? GameCollectionView
        collectionView?.gamepadKeyLeftAction()
    }
    func gamepadKeyRightAction() {
        let collectionView = self.viewWithTag(collectionViewStartTag + centerLineIndex) as? GameCollectionView
        collectionView?.gamepadKeyRightAction()
    }
    func gamepadKeyAAction() {
        let collectionView = self.viewWithTag(collectionViewStartTag + centerLineIndex) as? GameCollectionView
        collectionView?.collectionView(collectionView!, didSelectItemAt: collectionView!.focusIndexPath)
    }
}
