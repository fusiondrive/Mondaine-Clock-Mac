//
//  ContentView.swift
//  Mondaine Clock (Mac)
//
//  Created by Steve Wang on 8/10/24.
//

import SwiftUI

import SwiftUI

struct ClockView: View {
    @Environment(\.colorScheme) var colorScheme // 检测系统主题
    @State private var currentTime = CurrentTime()
    @State private var lastSecond: Int = 0

    var body: some View {
        ZStack {
            // 背景图像
            Image(colorScheme == .dark ? "BG_Dark" : "BG")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)

            // 表盘
            Image(colorScheme == .dark ? "ClockFace_Dark" : "ClockFace")
                .resizable()
                .scaledToFit()
                .frame(width: 785, height: 785) // 固定表盘的大小
                .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 5)

            // 刻度
            Image(colorScheme == .dark ? "ClockIndicator_Dark" : "ClockIndicator")
                .resizable()
                .scaledToFit()
                .frame(width: 730, height: 730)
                .offset(y: 4) // 修改 offset 使其居中
                .shadow(color: .black.opacity(0.5), radius: 2, x: 0, y: 2)

            // 时针
            Image(colorScheme == .dark ? "HOURBAR_Dark" : "HOURBAR")
                .resizable()
                .frame(width: 50, height: 433.87)
                .rotationEffect(Angle.degrees(currentTime.hoursAngle))
                .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 5)

            // 分针
            Image(colorScheme == .dark ? "MINBAR_Dark" : "MINBAR")
                .resizable()
                .frame(width: 50, height: 685.73)
                .rotationEffect(Angle.degrees(currentTime.minutesAngle))
                .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 5)

            // 秒针
            Image(colorScheme == .dark ? "REDINDICATOR_Dark" : "REDINDICATOR")
                .resizable()
                .frame(width: 383, height: 579)
                .offset(y: -1)
                .rotationEffect(Angle.degrees(currentTime.secondsAngle))
                .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 5)
                .animation(.linear(duration: 1.0), value: currentTime.secondsAngle) //smooth animation
        }
        .onAppear(perform: startClock)
    }

    func startClock() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            let calendar = Calendar.current
            let second = calendar.component(.second, from: Date())

            if second != lastSecond {
                lastSecond = second
                self.currentTime = CurrentTime()
            }
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
            .previewDevice("iPhone 12")
        ClockView()
            .previewLayout(.sizeThatFits)
            .frame(width: 800, height: 800)
            .previewDisplayName("macOS Preview")
    }
}
