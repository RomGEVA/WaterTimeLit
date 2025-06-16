import SwiftUI

struct WaterBalanceBackground: View {
    var body: some View {
        GeometryReader { geo in
            ZStack {
                
                LinearGradient(
                    gradient: Gradient(colors: [Color(red: 0.82, green: 0.93, blue: 0.99), Color.white]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                
                WaterWaves()
                    .frame(height: geo.size.height * 0.28)
                    .opacity(0.32)
                    .offset(y: -geo.size.height * 0.04)
                WaterDrops()
                    .frame(height: geo.size.height * 0.18)
                    .opacity(0.18)
                    .offset(y: geo.size.height * 0.01)
                
                
                WaterIconsPattern(size: geo.size)
                
                
                CupTraces()
                    .frame(height: geo.size.height * 0.13)
                    .opacity(0.13)
                    .offset(y: geo.size.height * 0.44)
            }
        }
    }
}


struct WaterWaves: View {
    var body: some View {
        ZStack {
            WaveShape(yOffset: 0.18, amplitude: 18)
                .fill(Color.blue.opacity(0.18))
            WaveShape(yOffset: 0.22, amplitude: 12)
                .fill(Color.cyan.opacity(0.13))
            WaveShape(yOffset: 0.26, amplitude: 8)
                .fill(Color.teal.opacity(0.10))
        }
    }
}

struct WaveShape: Shape {
    var yOffset: CGFloat
    var amplitude: CGFloat
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.width
        let height = rect.height
        path.move(to: CGPoint(x: 0, y: height * yOffset))
        for x in stride(from: 0, through: width, by: 1) {
            let relativeX = x / width
            let sine = sin(relativeX * .pi * 2 + yOffset * 6)
            let y = height * yOffset + sine * amplitude
            path.addLine(to: CGPoint(x: x, y: y))
        }
        path.addLine(to: CGPoint(x: width, y: 0))
        path.addLine(to: CGPoint(x: 0, y: 0))
        path.closeSubpath()
        return path
    }
}


struct WaterDrops: View {
    var body: some View {
        ZStack {
            ForEach(0..<5) { i in
                DropShape()
                    .fill(Color.cyan.opacity(0.18))
                    .frame(width: 32 + CGFloat(i) * 8, height: 38 + CGFloat(i) * 7)
                    .offset(x: CGFloat(i) * 38 - 60, y: CGFloat(i % 2) * 12)
                    .rotationEffect(.degrees(Double(i) * 12))
            }
        }
    }
}


struct CupTraces: View {
    var body: some View {
        GeometryReader { geo in
            ZStack {
                ForEach(0..<3) { i in
                    Circle()
                        .stroke(Color.blue.opacity(0.13), lineWidth: 2)
                        .frame(width: 60 + CGFloat(i) * 38, height: 60 + CGFloat(i) * 38)
                        .offset(x: CGFloat(i) * 44 - 40, y: CGFloat(i) * 12)
                }
            }
        }
    }
}


struct WaterIconsPattern: View {
    let size: CGSize
    var body: some View {
        ZStack {
            
            Image(systemName: "cup.and.saucer")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 38, height: 38)
                .opacity(0.10)
                .offset(x: size.width * 0.18, y: size.height * 0.22)
            Image(systemName: "cup.and.saucer")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 28, height: 28)
                .opacity(0.13)
                .offset(x: size.width * 0.7, y: size.height * 0.38)
            
            Image(systemName: "drop.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 22, height: 22)
                .opacity(0.10)
                .offset(x: size.width * 0.62, y: size.height * 0.13)
            Image(systemName: "drop.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 18, height: 18)
                .opacity(0.13)
                .offset(x: size.width * 0.32, y: size.height * 0.7)
            
            Image(systemName: "leaf")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 28, height: 28)
                .opacity(0.10)
                .offset(x: size.width * 0.82, y: size.height * 0.82)
        }
    }
} 
