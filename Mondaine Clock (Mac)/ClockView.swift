//
//  ContentView.swift
//  Mondaine Clock (Mac)
//
//  Created by Steve Wang on 8/10/24.
//


import SwiftUI

struct ClockView: View {
    @State private var currentTime = CurrentTime()
    @State private var lastSecond: Int = 0
    @State private var timer: Timer?
    @State private var secondsElapsed: Double = 0
    @State private var shouldAnimate: Bool = true

    var body: some View {
        ZStack {
            // 背景图像
            Image("BG")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)

            // 表盘
            Image("ClockFace")
                .resizable()
                .scaledToFit()
                .frame(width: 785, height: 785)
                .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 5)

            // 刻度
            Image("ClockIndicator")
                .resizable()
                .scaledToFit()
                .frame(width: 730, height: 730)
                .offset(y: 4)
                .shadow(color: .black.opacity(0.5), radius: 2, x: 0, y: 2)

            // 时针
            Image("HOURBAR")
                .resizable()
                .frame(width: 50, height: 433.87)
                .rotationEffect(Angle.degrees(currentTime.hoursAngle))
                .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 5)

            // 分针
            Image("MINBAR")
                .resizable()
                .frame(width: 50, height: 685.73)
                .rotationEffect(Angle.degrees(currentTime.minutesAngle))
                .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 5)

            // 秒针
            Image("REDINDICATOR")
                .resizable()
                .frame(width: 383, height: 579)
                .offset(y: -1)
                .rotationEffect(Angle.degrees(secondsElapsed * 6)) // 每秒 6 度
                .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 5)
                .animation(shouldAnimate ? .linear(duration: 1.0) : .none, value: secondsElapsed) // 动态控制动画
        }
        .onAppear(perform: startClock)
    }

    func startClock() {
        let calendar = Calendar.current
        let now = Date()
        
        // 计算当前秒数已过的时间
        let nanoseconds = calendar.component(.nanosecond, from: now)
        let timeToNextSecond = Double(1_000_000_000 - nanoseconds) / 1_000_000_000.0
        
        // 创建一个定时器
        timer = Timer(timeInterval: 1.0, repeats: true) { _ in
            let newSecond = calendar.component(.second, from: Date())
            
            // 动态控制是否需要动画
            if newSecond == 0 {
                shouldAnimate = false // 在0秒时禁用动画
                secondsElapsed = 0 // 确保秒针直接跳回起始位置
            } else {
                shouldAnimate = true // 其他时间启用动画
                secondsElapsed = Double(newSecond)
            }

            // 更新分针
            self.currentTime = CurrentTime()
            lastSecond = newSecond
        }
        
        // 设置定时器的第一次触发时间为下一个整秒
        timer?.fireDate = now.addingTimeInterval(timeToNextSecond)
        
        // 将定时器添加到运行循环中
        if let timer = timer {
            RunLoop.main.add(timer, forMode: .common)
        }
    }
}

struct CurrentTime {
    var hoursAngle: Double
    var minutesAngle: Double
    var secondsAngle: Double

    init() {
        let calendar = Calendar.current
        let date = Date()

        let hours = Double(calendar.component(.hour, from: date) % 12) + Double(calendar.component(.minute, from: date)) / 60.0
        let minutes = Double(calendar.component(.minute, from: date)) + Double(calendar.component(.second, from: date)) / 60.0
        let seconds = Double(calendar.component(.second, from: date))

        self.hoursAngle = (hours / 12.0) * 360.0
        self.minutesAngle = (minutes / 60.0) * 360.0
        self.secondsAngle = (seconds / 60.0) * 360.0
    }
}

struct ClockView_Previews: PreviewProvider {
    static var previews: some View {
        ClockView()
            .previewLayout(.sizeThatFits)
            .frame(width: 1470, height: 956)
            .previewDisplayName("macOS Preview")
    }
}
