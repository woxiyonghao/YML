//
//  TimerManger.swift
//  zzt_oc
//
//  Created by liwu cao on 2022/7/8.
//
import UIKit
struct TimeTask {
    var taskId: String = ""
    var interval: Int //interval 1 == 1/60秒
    var event: () -> ()
}

 class TimerManger: NSObject {
    static let share = TimerManger()

    override private init() {
        super.init()
        RunLoop.main.add(self.timer, forMode: .common)
    }

    open var taskArr = [TimeTask]()

    private lazy var timer: Timer = {
        var index = 0
        let timer = Timer.scheduledTimer(withTimeInterval: 1 / 60, repeats: true) { _ in
            if index == 59 {
                index = 0
            }
            for task in self.taskArr {
                if index % task.interval == 0 {
                    task.event()
                }
            }
            index += 1
        }
        return timer
    }()

    func runTask(task: TimeTask) {
        objc_sync_enter(self.taskArr)
        for t in self.taskArr {
            if t.taskId == task.taskId {
                objc_sync_exit(self.taskArr)
                return
            }
        }
        self.taskArr.append(task)
        objc_sync_exit(self.taskArr)
    }

    func cancelTaskWithId(_ id: String) {
        objc_sync_enter(self.taskArr)
        let tasks = self.taskArr
        for i in 0 ..< tasks.count {
            if tasks[i].taskId == id {
                self.taskArr.remove(at: i)
            }
        }
        objc_sync_exit(self.taskArr)
        
    }
}
