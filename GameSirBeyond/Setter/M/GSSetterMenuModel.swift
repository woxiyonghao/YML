//
//  GSSetterMenuModel.swift
//  GameSirBeyond
//
//  Created by lu on 2024/4/8.
//

import UIKit
import RxSwift
import RxCocoa
// viewmodel
class GSSetterViewModel {
    
    let itemDatas = BehaviorSubject<[GSSetterMenuModel]>(value: [])
    
    public let selectIndexPath: PublishSubject<IndexPath> = PublishSubject()
    
    public let pages: PublishSubject<Int> = PublishSubject()
    
    let aboutDatas = BehaviorSubject<[GSSetterMenuOPModel]>(value: [])
    
    let helpDatas = BehaviorSubject<[GSSetterMenuOPModel]>(value: [])
    
    let recodeDatas = BehaviorSubject<[GSSetterMenuOPModel]>(value: [])
    
    let linkDatas = BehaviorSubject<[GSSetterMenuOPModel]>(value: [])
    
    let accoundDatas = BehaviorSubject<[GSSetterMenuOPModel]>(value: [])
    
    let joyconDatas = BehaviorSubject<[GSSetterMenuOPModel]>(value: [])
    
    let joyconDetailDatas = BehaviorSubject<[GSSetterMenuOPModel]>(value: [])
    
    fileprivate let dispaseBag = DisposeBag()
    
    let recodeFPSDatas = BehaviorSubject<[GSSetterMenuOPModel]>(value: [])
    
    let recodeFormatDatas = BehaviorSubject<[GSSetterMenuOPModel]>(value: [])
    
    let recodeBitRateDatas = BehaviorSubject<[GSSetterMenuOPModel]>(value: [])
    func loadDatas(){
        
        // 左边的data
        lazy var items = [
            GSSetterMenuModel(normalIcon: "setter_accound_normal", selectIcon: "setter_accound_select", iconTxt: "账号", normalIconTxtColor: .hex("#CCCCCC"), selectIconTxtColor: .hex("#252525"), inSubMenuColor: .hex("#3E424A"),tipViewColor: .hex("#1A9FFC"), select: false,inSubMenu:false),
            
            GSSetterMenuModel(normalIcon: "setter_link_normal", selectIcon: "setter_link_select", iconTxt: "链接", normalIconTxtColor: .hex("#CCCCCC"), selectIconTxtColor: .hex("#252525"), inSubMenuColor: .hex("#3E424A"),tipViewColor: .hex("#1A9FFC"), select: false,inSubMenu:false),
            
            GSSetterMenuModel(normalIcon: "setter_joycon_normal", selectIcon: "setter_joycon_select", iconTxt: "手柄", normalIconTxtColor: .hex("#CCCCCC"), selectIconTxtColor: .hex("#252525"),inSubMenuColor: .hex("#3E424A"), tipViewColor: .hex("#1A9FFC"), select: false,inSubMenu:false),
            
            GSSetterMenuModel(normalIcon: "setter_recode_normal", selectIcon: "setter_recode_select", iconTxt: "录制", normalIconTxtColor: .hex("#CCCCCC"), selectIconTxtColor: .hex("#252525"), inSubMenuColor: .hex("#3E424A"),tipViewColor: .hex("#1A9FFC"), select: false,inSubMenu:false),
            
            GSSetterMenuModel(normalIcon: "setter_help_normal", selectIcon: "setter_help_select", iconTxt: "帮助", normalIconTxtColor: .hex("#CCCCCC"), selectIconTxtColor: .hex("#252525"), inSubMenuColor: .hex("#3E424A"),tipViewColor: .hex("#1A9FFC"), select: false,inSubMenu:false),
            
            GSSetterMenuModel(normalIcon: "setter_about_normal", selectIcon: "setter_about_select", iconTxt: "关于", normalIconTxtColor: .hex("#CCCCCC"), selectIconTxtColor: .hex("#252525"), inSubMenuColor: .hex("#3E424A"),tipViewColor: .hex("#1A9FFC"), select: false,inSubMenu:false)
        ]
        
        
        let infoDictionary:Dictionary = Bundle.main.infoDictionary!
        //版本号
        let majorVersion:String = infoDictionary ["CFBundleShortVersionString"] as? String ?? ""
        //build号
        let minorVersion:String = infoDictionary ["CFBundleVersion"] as? String ?? ""
        let iosVersion:String = UIDevice.current.systemVersion as String
        let model = UIDevice.current.model
        lazy var about = [
            
            GSSetterMenuOPModel(title: "App版本",subtitle: majorVersion,id: 0),
            GSSetterMenuOPModel(title: "构建",subtitle: minorVersion,id: 1),
            GSSetterMenuOPModel(title: "系统版本",subtitle: iosVersion,id: 2),
            GSSetterMenuOPModel(title: "手机型号",subtitle: model,id:3),
            
        ]
        
        
        
        lazy var help = [
            GSSetterMenuOPModel(title: "新手教程",id: 0),
            GSSetterMenuOPModel(title: "帮助&客户支持",id: 1),
            GSSetterMenuOPModel(title: "提交意见反馈",id: 2),
            GSSetterMenuOPModel(title: "兑换免费适配器",id: 3),
            GSSetterMenuOPModel(title: "请求删除数据",id: 4)
        ]
        
        
        lazy var recode = [
            GSSetterMenuOPModel(title: "录制模式",subtitle: "录制一切",id: 0),
            GSSetterMenuOPModel(title: "录制视频",subtitle: "分辨率为1080p，帧率为30FPS",id: 1),
            GSSetterMenuOPModel(title: "格式",subtitle: "H264",id: 2),
            GSSetterMenuOPModel(title: "比特率",subtitle: "H264",id: 3),
        ]
        
        
        
        lazy var link = [
            GSSetterMenuOPModel(title: "关联Steam账号",normalIcon: "stream_logo_white",selectIcon: "stream_logo_black",id: 0),
            GSSetterMenuOPModel(title: "关联Xbox账号",normalIcon: "xbox_logo_white",selectIcon: "xbox_logo_black",id: 1),
            GSSetterMenuOPModel(title: "关联PlayStation账号",normalIcon: "ps_logo_white",selectIcon: "ps_logo_black",id: 2)
        ]
        
        
        lazy var accound = [
            GSSetterMenuOPModel(title: "编辑用户信息",id: 0),
            GSSetterMenuOPModel(title: "编辑游戏用户名",id: 1),
            GSSetterMenuOPModel(title: "通知",id: 2),
            GSSetterMenuOPModel(title: "退出",id: 3),
        ]
        
        lazy var joycon = [
            GSSetterMenuOPModel(title: "手柄",subtitle: "型号",id: 0),
            GSSetterMenuOPModel(title: "在任何屏幕上进行游戏",subtitle: "禁用",id: 1),
            GSSetterMenuOPModel(title: "快速访问快捷方式",subtitle: "无",id: 2),
            GSSetterMenuOPModel(title: "摇杆校准",id: 3),
            GSSetterMenuOPModel(title: "测试游戏手柄按键",id: 4),
            GSSetterMenuOPModel(title: "按键映射",id: 5),
            GSSetterMenuOPModel(title: "出厂设置",id: 6),
        ]
        
        
        let joyconName =  UserDefaults.standard.value(forKey: gamepadNameKey) as? String
        lazy var jonconDetail = [
            GSSetterMenuOPModel(title: "名称",subtitle: joyconName ?? ""),
            GSSetterMenuOPModel(title: "型号",subtitle: "BB-02-W-S"),
            GSSetterMenuOPModel(title: "序列号",subtitle: "HJ64738HJK"),
            GSSetterMenuOPModel(title: "固件版本",subtitle: ""),
        ]
        
        itemDatas.onNext(items)
        
        aboutDatas.onNext(about)
        
        helpDatas.onNext(help)
        
        recodeDatas.onNext(recode)
        
        accoundDatas.onNext(accound)
        
        linkDatas.onNext(link)
        
        joyconDatas.onNext(joycon)
        
        joyconDetailDatas.onNext(jonconDetail)
        
        pages.onNext(items.count)
        
        loadJoyconDeviceData(jonconDetail:jonconDetail)
        
        lazy var recodeFPS = [
            GSSetterMenuOPModel(title: "1080P 60 FPS"),
            GSSetterMenuOPModel(title: "1080P 30 FPS"),
            GSSetterMenuOPModel(title: "720P 30 FPS"),
        ]
        recodeFPSDatas.onNext(recodeFPS)
        
        lazy var recodeFormat = [
            GSSetterMenuOPModel(title: "高效（HEVC）"),
            GSSetterMenuOPModel(title: "兼容性最好（H.264）"),
        ]
        recodeFormatDatas.onNext(recodeFormat)
        
        lazy var bitRate = [
            GSSetterMenuOPModel(title: "自动（推荐）"),
            GSSetterMenuOPModel(title: "30 Mbps"),
            GSSetterMenuOPModel(title: "24 Mbps"),
            GSSetterMenuOPModel(title: "20 Mbps"),
            GSSetterMenuOPModel(title: "16 Mbps"),
            GSSetterMenuOPModel(title: "10 Mbps"),
        ]
        recodeBitRateDatas.onNext(bitRate)
        
    }
    
    
    fileprivate func loadJoyconDeviceData(jonconDetail:[GSSetterMenuOPModel]){
        
        guard let app = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        app.writeCommandReadFirmwareVersion()
        
        // 监听固件版本回调
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didReadJoyconFrimware),
                                               name: NSNotification.Name("DidGetFirmwareVersionNotification"),
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didConnectJoycont),
                                               name: NSNotification.Name("DidConnectControllerNotification"),
                                               object: nil)
       
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func didReadJoyconFrimware(noti:Notification){
        guard let data = try? joyconDetailDatas.value() else { return }
        if let versionData = noti.object as? [String] {
            //由于固件的错误，把大小版本互换了。原版本号为0.3，而实际数据代表3.0。iOS端显示逻辑为"00 03" -> 0.3
            let bigVersion = GSDataTool.int(withHexString: versionData[0])
            let smallVersion = GSDataTool.int(withHexString: versionData[1])
            let version = "\(bigVersion).\(smallVersion)"
            data[3].subtitle = version
            self.joyconDetailDatas.onNext(data)
            print("jonconDetail == \(data)")
        }
    }
    
    @objc func didConnectJoycont(){
        if let datas = try? joyconDetailDatas.value(){
            let joyconName =  UserDefaults.standard.value(forKey: gamepadNameKey) as? String
            datas[0].subtitle = joyconName ?? ""
            joyconDetailDatas.onNext(datas)
            print("joyconName == \(joyconName)")
        }
    }
}


class GSSetterMenuModel: NSObject {
    var normalIcon = ""
    var selectIcon = ""
    var iconTxt = ""
    var normalIconTxtColor = UIColor.clear
    var selectIconTxtColor = UIColor.clear
    var inSubMenuColor = UIColor.clear
    var tipViewColor = UIColor.clear
    var select = false
    var inSubMenu = false
    var id = 0
    var datas = [GSSetterMenuOPModel]()
    init(normalIcon: String = "", selectIcon: String = "", iconTxt: String = "", normalIconTxtColor: UIColor = UIColor.clear, selectIconTxtColor: UIColor = UIColor.clear, inSubMenuColor: UIColor = UIColor.clear, tipViewColor: UIColor = UIColor.clear, select: Bool = false, inSubMenu: Bool = false ,id:Int = 0,datas:[GSSetterMenuOPModel] = [GSSetterMenuOPModel]()) {
        self.normalIcon = normalIcon
        self.selectIcon = selectIcon
        self.iconTxt = iconTxt
        self.normalIconTxtColor = normalIconTxtColor
        self.selectIconTxtColor = selectIconTxtColor
        self.inSubMenuColor = inSubMenuColor
        self.tipViewColor = tipViewColor
        self.select = select
        self.inSubMenu = inSubMenu
        self.id = id
        self.datas = datas
    }
}


class GSSetterMenuOPModel: NSObject {
    var title = ""
    var subtitle = ""
    var select = false
    var normalIcon = ""
    var selectIcon = ""
    var arrow = false
    var enter = false
    var id = 0
    init(title: String = "", subtitle: String = "", select: Bool = false, normalIcon: String = "", selectIcon: String = "", arrow: Bool = false, enter: Bool = false,id:Int = 0) {
        self.title = title
        self.subtitle = subtitle
        self.select = select
        self.normalIcon = normalIcon
        self.selectIcon = selectIcon
        self.arrow = arrow
        self.enter = enter
        self.id = id
    }
}
