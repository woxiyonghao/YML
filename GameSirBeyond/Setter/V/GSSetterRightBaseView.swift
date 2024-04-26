
//
//  GSSetterAboutView.swift
//  GameSirBeyond
//
//  Created by lu on 2024/4/8.
//

import UIKit
import SnapKit
//import YYText
class GSSetterRightBaseView: UIView {
    
    
    var myStyle:GSSetterRightCellStyle = .accound
    var onFcous = -1
    fileprivate var cellID = ""
    
    public var didSelectCellHandler = {(cell:GSSetterRightCell,menuModel:GSSetterMenuModel) in}
    public var enterSelectCellHandler = {(cell:GSSetterRightCell,menuModel:GSSetterMenuModel) in}
    
    
    /*
     public var model:GSSetterMenuModel!
     public var datas = [GSSetterMenuOPModel]()
     二选一
     */
    public var datas = [GSSetterMenuOPModel](){
        didSet{
            scrSubviews.forEach {$0.removeFromSuperview()}
            scrSubviews.removeAll()
            
            let header = setupTabHeader()
            scrSubviews.append(header)
            scr.addSubview(header)
            var allHeight = CGRectGetMaxY(header.frame)
            
    
            for i in 0..<datas.count {
                allHeight += GSSetterRightCellH
                let cell = GSSetterRightCell(style: .default, reuseIdentifier: nil)
                cell.fullModel(model:datas[i], style: myStyle)
                cell.frame = CGRectMake(80.widthScale, 0, self.width-160.widthScale, GSSetterRightCellH)
                scrSubviews.append(cell)
                scr.addSubview(cell)
                cell.touchEnterHandler = {[weak self](this:GSSetterRightCell) in
                    self?.touchEnter(cell: this)
                }
                cell.touchLeaveHandler = {[weak self](this:GSSetterRightCell) in
                    self?.touchLeave(cell: this)
                }
            }
            
            let footer = setupTabFooter()
            scrSubviews.append(footer)
            scr.addSubview(footer)
            allHeight += footer.height
            let maxHeight = self.height
            if allHeight < maxHeight {
                let startY = (maxHeight - allHeight) * 0.5
                for i in 0..<scrSubviews.count {
                    if i == 0 {
                        scrSubviews[i].y = startY
                    }
                    else {
                        scrSubviews[i].y = CGRectGetMaxY(scrSubviews[i-1].frame)
                    }
                }
                scr.contentSize = CGSizeMake(0, kHeight)
            }else {
                for i in 0..<scrSubviews.count {
                    if i == 0 {
                        scrSubviews[i].y = 0
                    }
                    else {
                        scrSubviews[i].y = CGRectGetMaxY(scrSubviews[i-1].frame)
                    }
                }
                scr.contentSize = CGSizeMake(0, allHeight)
            }
        }
    }
    
    /// 赋值一次便可【如果是二级界面，请不要使用model，使用datas】
    public var model:GSSetterMenuModel!{
        didSet{
            scrSubviews.forEach {$0.removeFromSuperview()}
            scrSubviews.removeAll()
            
            let header = setupTabHeader()
            scrSubviews.append(header)
            scr.addSubview(header)
            var allHeight = CGRectGetMaxY(header.frame)
            
    
            for i in 0..<model.datas.count {
                allHeight += GSSetterRightCellH
                let cell = GSSetterRightCell(style: .default, reuseIdentifier: nil)
                cell.fullModel(model: model.datas[i], style: myStyle)
                cell.frame = CGRectMake(80.widthScale, 0, self.width-160.widthScale, GSSetterRightCellH)
                cell.myModel = model.datas[i]
                scrSubviews.append(cell)
                scr.addSubview(cell)
                cell.touchEnterHandler = {[weak self](this:GSSetterRightCell) in
                    self?.touchEnter(cell: this)
                }
                cell.touchLeaveHandler = {[weak self](this:GSSetterRightCell) in
                    self?.touchLeave(cell: this)
                }
            }
            
            let footer = setupTabFooter()
            scrSubviews.append(footer)
            scr.addSubview(footer)
            allHeight += footer.height
            let maxHeight = self.height
            if allHeight < maxHeight {
                let startY = (maxHeight - allHeight) * 0.5
                for i in 0..<scrSubviews.count {
                    if i == 0 {
                        scrSubviews[i].y = startY
                    }
                    else {
                        scrSubviews[i].y = CGRectGetMaxY(scrSubviews[i-1].frame)
                    }
                }
                scr.contentSize = CGSizeMake(0, kHeight)
            }else {
                for i in 0..<scrSubviews.count {
                    if i == 0 {
                        scrSubviews[i].y = 0
                    }
                    else {
                        scrSubviews[i].y = CGRectGetMaxY(scrSubviews[i-1].frame)
                    }
                }
                scr.contentSize = CGSizeMake(0, allHeight)
            }
        }
    }
    
  
    
    @objc func touchEnter(cell:GSSetterRightCell){
        print(cell.myStyle!)
        if cell.myStyle! == .joyconDetail ||
            cell.myStyle! == .recodeFPS {
            datas.forEach {
                $0.select = false
                $0.enter = false
            }
            cell.myModel!.select = false
            cell.myModel!.enter = true
            scrSubviews.forEach { view in
                if let tag = view as? GSSetterRightCell{
                    tag.fullModel(model: tag.myModel!, style: tag.myStyle!)
                }
            }
        }
        else {
            model.datas.forEach {
                $0.select = false
                $0.enter = false
            }
            cell.myModel!.select = false
            cell.myModel!.enter = true
            scrSubviews.forEach { view in
                if let tag = view as? GSSetterRightCell{
                    tag.fullModel(model: tag.myModel!, style: tag.myStyle!)
                }
            }
            
            enterSelectCellHandler(cell,model)
        }
        
    }
    
    @objc func touchLeave(cell:GSSetterRightCell){
        print(cell.myStyle!)
        if cell.myStyle! == .joyconDetail ||
            cell.myStyle! == .recodeFPS {
            cell.myModel!.select = true
            cell.myModel!.enter = true
            scrSubviews.forEach { view in
                if let tag = view as? GSSetterRightCell{
                    tag.fullModel(model: tag.myModel!, style: tag.myStyle!)
                }
            }
        }else {
            cell.myModel?.enter = true
            cell.myModel?.select = true
            scrSubviews.forEach { view in
                if let tag = view as? GSSetterRightCell{
                    tag.fullModel(model: tag.myModel!, style: tag.myStyle!)
                }
            }
            if onFcous == cell.myModel?.id {
                didSelectCellHandler(cell,model)
            }
            onFcous = cell.myModel!.id
        }
       
    }
    
    
    init(frame: CGRect,style:GSSetterRightCellStyle) {
        self.myStyle = style
        super.init(frame: frame)
        backgroundColor = .clear
        scr.showsVerticalScrollIndicator = false
        scr.showsHorizontalScrollIndicator = false
        scr.backgroundColor = .clear
        scr.frame = self.bounds
        scr.bounces = false
        self.addSubview(scr)
        scr.contentInsetAdjustmentBehavior = .never
    }
    
    lazy var scr = UIScrollView()
    lazy var scrSubviews = [UIView]()
    
    func setupTabHeader() -> UIView{
        if myStyle == .recodeFPS {
            let header = UIView(frame: CGRect(x: 80.widthScale, y: 0, width: kWidth-GSSetterMenuWidth-160.widthScale, height: 96.widthScale)).then({ view in
                view.backgroundColor = .clear
            })
            let title = UILabel()
            title.backgroundColor = .clear
            title.textColor = .hex("#CCCCCC")
            title.font = font_24(weight: .semibold)
            title.textAlignment = .center
            title.text = "录制视频"
            title.frame = CGRectMake(0, 36.widthScale, header.width, header.height-36.widthScale)
            header.addSubview(title)
            return header
        }
        
        else if myStyle == .recodeFormat {
            let header = UIView(frame: CGRect(x: 80.widthScale, y: 0, width: kWidth-GSSetterMenuWidth-160.widthScale, height: 120.widthScale)).then({ view in
                view.backgroundColor = .clear
            })
            let title = UILabel()
            title.backgroundColor = .clear
            title.textColor = .hex("#CCCCCC")
            title.font = font_24(weight: .semibold)
            title.textAlignment = .center
            title.text = "格式"
            title.frame = CGRectMake(0, 36.widthScale, header.width, header.height-36.widthScale)
            header.addSubview(title)
            return header
        }
        
        else if myStyle == .recodeBitRate {
            let header = UIView(frame: CGRect(x: 80.widthScale, y: 0, width: kWidth-GSSetterMenuWidth-160.widthScale, height: 90.widthScale)).then({ view in
                view.backgroundColor = .clear
            })
            let title = UILabel()
            title.backgroundColor = .clear
            title.textColor = .hex("#CCCCCC")
            title.font = font_24(weight: .semibold)
            title.textAlignment = .center
            title.text = "比特率"
            title.frame = CGRectMake(0, 36.widthScale, header.width, header.height-36.widthScale)
            header.addSubview(title)
            return header
        }
        
        else {
            let header = UIView(frame: CGRect(x: 80.widthScale, y: 0, width: kWidth-GSSetterMenuWidth-160.widthScale, height: GSSetterRightViewContentTop)).then({ view in
                view.backgroundColor = .clear
            })
            return header
        }
        
    }
    
    
    func setupTabFooter() -> UIView {
        
        if self.myStyle == .help {
            // 增加一个【收集的信息将根据个人信息收集通知和隐私政策中的描述来使用。】
            return UIView(frame: CGRect(x: 80.widthScale, y: 0, width: kWidth-GSSetterMenuWidth-160.widthScale, height: GSSetterRightViewContentBottom)).then({ view in
                view.backgroundColor = .clear
                let label = YYLabel()
                label.numberOfLines = 1
                let str:NSString = "收集的信息将根据个人信息收集通知和隐私政策中的描述来使用"
                let tag1 = "个人信息收集通知"
                let tag2 = "隐私政策"
                label.isUserInteractionEnabled = true
                let text = NSMutableAttributedString.init(string: str as String)
                text.addAttribute(NSAttributedString.Key.font, value: font_12(weight: .regular), range: NSMakeRange(0, str.length))
                text.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.hex("#B4B4B4"), range: NSMakeRange(0, str.length))
                text.yy_setTextHighlight(str.range(of: tag1), color: UIColor.orange, backgroundColor: .clear) { _, attr, _, _ in
                    print("\(tag1)")
                }
                text.yy_setTextHighlight(str.range(of: tag2), color: UIColor.orange, backgroundColor: .clear) { _, attr, _, rang in
                    print("\(tag2)")
                }
                
                let para = NSMutableParagraphStyle()
                para.alignment = .left
                text.addAttribute(NSAttributedString.Key.paragraphStyle, value: para, range: NSMakeRange(0, str.length))
                label.attributedText = text
                view.addSubview(label)
                label.snp.makeConstraints { make in
                    make.left.equalToSuperview().offset(12.widthScale)
                    make.top.equalToSuperview()
                }
            })
        }
        
        
        else if myStyle == .recodeFPS {
            let footer =  UIView(frame: CGRect(x: 80.widthScale, y: 0, width: kWidth-GSSetterMenuWidth-160.widthScale, height: 148.widthScale)).then({ view in
                view.backgroundColor = .clear
            })
            
            let label = UILabel()
            label.backgroundColor = .clear
            label.textColor = .hex("#B4B4B4")
            label.font = font_12(weight: .medium)
            label.textAlignment = .left
            label.text = "默认设置下，一分钟的视频大约会是 …. "
            label.frame = CGRectMake(12.widthScale, 12.widthScale, footer.width, 20.widthScale)
            footer.addSubview(label)
            
            let array = [
                "大小为150MB，分辨率为1080p，帧率为60FPS",
                "大小为75MB，分辨率为1080p，帧率为30FPS",
                "大小为50MB，分辨率为720p，帧率为30FPS",
            ]
            
            
            for i in 0..<array.count {
                let view = UIView()
                view.layer.cornerRadius = 3.widthScale
                view.layer.masksToBounds = true
                view.backgroundColor = .hex("#D9D9D9")
                view.width = 6.widthScale
                view.height = 6.widthScale
                view.x = label.x
                view.y = (CGRectGetMidY(label.frame) + 15.widthScale) + CGFloat(i) * (10.widthScale + view.height)
                footer.addSubview(view)
                
                let lb = UILabel()
                lb.backgroundColor = .clear
                lb.textColor = .hex("#B4B4B4")
                lb.font = font_12(weight: .medium)
                lb.textAlignment = .left
                lb.text = array[i]
                lb.frame = CGRectMake(CGRectGetMaxX(view.frame) + 6.widthScale, view.y - 6.widthScale, footer.width - (CGRectGetMaxX(view.frame) + 6.widthScale), 18.widthScale)
                footer.addSubview(lb)
            }
            
            return footer
        }
        
        else if myStyle == .recodeFormat {
            let footer = UIView(frame: CGRect(x: 80.widthScale, y: 0, width: kWidth-GSSetterMenuWidth-160.widthScale, height: 160.widthScale)).then({ view in
                view.backgroundColor = .clear
            })
            let title = UILabel()
            title.backgroundColor = .clear
            title.textColor = .hex("#CCCCCC")
            title.font = font_12(weight: .semibold)
            title.textAlignment = .left
            title.numberOfLines = 2
            title.text = "为了减小文件大少；建议使用 HEVC格式来录制视频。为了获得最\n佳兼容性，您也可以使用H264格式。"
            //title.frame = CGRectMake(0, 12.widthScale, footer.width, footer.height-12.widthScale)
            title.x = 8.widthScale
            title.y = 12.widthScale
            title.width = footer.width - 16.widthScale
            title.height = 34.widthScale
            footer.addSubview(title)
            return footer
        }
        
        else {
            return UIView(frame: CGRect(x: 80.widthScale, y: 0, width: kWidth-GSSetterMenuWidth-160.widthScale, height: GSSetterRightViewContentBottom)).then({ view in
                view.backgroundColor = .clear
            })
        }
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

