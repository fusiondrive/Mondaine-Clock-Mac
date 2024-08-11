import SwiftUI

struct ClockView: View {
    @State private var currentTime = CurrentTime()
    @State private var lastSecond: Int = 0

    var body: some View {
        ZStack {
            // Background image
            Image("BG")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)

            // Clock Face
            Image("ClockFace")
                .resizable()
                .scaledToFit()
                .frame(width: 785, height: 785) // face size
                .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 5)

            // Indicator
            Image("ClockIndicator")
                .resizable()
                .scaledToFit()
                .frame(width: 730, height: 730)
                .offset(y: 4) // make it center
                .shadow(color: .black.opacity(0.5), radius: 2, x: 0, y: 2)

            // Hour hand
            Image("HOURBAR")
                .resizable()
                .frame(width: 50, height: 433.87)
                .rotationEffect(Angle.degrees(currentTime.hoursAngle))
                .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 5)

            // Minute hand
            Image("MINBAR")
                .resizable()
                .frame(width: 50, height: 685.73)
                .rotationEffect(Angle.degrees(currentTime.minutesAngle))
                .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 5)

            // Second hand
            Image("REDINDICATOR")
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
            .previewLayout(.sizeThatFits)
            .frame(width: 1470, height: 956)
            .previewDisplayName("macOS Preview")
    }
}
