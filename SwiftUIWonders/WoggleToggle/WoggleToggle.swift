//
//  WoggleToggle.swift
//  SwiftUIWonders
//
//  Created by Fateh Khan on 21/04/2024.
//

import SwiftUI

struct WoggleToggle: View {
    @State var isOn = true
    var body: some View {
        HStack {
            ZStack {
                Capsule()
                    .fill(isOn ? .green : .gray)
                HStack {
                    if isOn {
                        Spacer()
                    }
                    ZStack {
                        
                        Circle()
                            .fill(.white)
                        
                        LineSegment4(startPoint: CGPoint(
                            x: isOn ? 0.42 : 0.3,
                            y: isOn ? 0.68 : 0.3),
                                     endPoint: CGPoint(
                                        x: isOn ? 0.78 : 0.7,
                                        y: isOn ? 0.36 : 0.7))
                        .stroke(isOn ? .green : .gray, style: StrokeStyle(lineWidth: 6.0, lineCap: .round))
                        
                        
                        LineSegment4(startPoint: CGPoint(
                            x: isOn ? 0.42 : 0.7,
                            y: isOn ? 0.68 : 0.3),
                                     endPoint: CGPoint(
                                        x: isOn ? 0.25 : 0.3,
                                        y: isOn ? 0.48 : 0.7))
                        .stroke(isOn ? .green : .gray, style: StrokeStyle(lineWidth: 6.0, lineCap: .round))
                    }
                    .frame(width: 100, height: 100)
                    .padding(4)
                    
                    if !isOn {
                        Spacer()
                    }
                }
            }
            .frame(width: 200, height: 100)
        }
        .contentShape(.rect)
        .onTapGesture {
            withAnimation(.timingCurve(0.1, 0.2, 0.7, 0.8, duration: 0.48)) {
                isOn.toggle()
            }
        }
    }
}

struct LineSegment4: Shape {
    var startPoint: CGPoint
    var endPoint: CGPoint
    
    private var animatableSegment: AnimatableSegment
    
    var animatableData: AnimatableSegment {
        get { AnimatableSegment(startPoint: startPoint, endPoint: endPoint) }
        set {
            startPoint = newValue.startPoint
            endPoint = newValue.endPoint
        }
    }
    
    init(startPoint: CGPoint, endPoint: CGPoint) {
        self.startPoint = startPoint
        self.endPoint = endPoint
        self.animatableSegment = AnimatableSegment(startPoint: startPoint, endPoint: endPoint)
    }
    
    func path(in rect: CGRect) -> Path {
        let start = CGPoint(x: startPoint.x * rect.width,
                            y: startPoint.y * rect.height)
        let end = CGPoint(x: rect.width * endPoint.x,
                          y: rect.height * endPoint.y)
        var path = Path()
        path.move(to: start)
        path.addLine(to: end)
        return path
    }
}



#Preview {
    WoggleToggle()
}

struct AnimatableSegment : VectorArithmetic {
    var startPoint: CGPoint
    var endPoint: CGPoint
    
    var length: Double {
        return Double(((endPoint.x - startPoint.x) * (endPoint.x - startPoint.x)) +
                      ((endPoint.y - startPoint.y) * (endPoint.y - startPoint.y))).squareRoot()
    }
    
    var magnitudeSquared: Double {
        return length * length
    }
    
    mutating func scale(by rhs: Double) {
        self.startPoint.x.scale(by: rhs)
        self.startPoint.y.scale(by: rhs)
        self.endPoint.x.scale(by: rhs)
        self.endPoint.y.scale(by: rhs)
    }
    
    static var zero: AnimatableSegment {
        return AnimatableSegment(startPoint: CGPoint(x: 0.0, y: 0.0),
                                 endPoint: CGPoint(x: 0.0, y: 0.0))
    }
    
    static func - (lhs: AnimatableSegment, rhs: AnimatableSegment) -> AnimatableSegment {
        return AnimatableSegment(
            startPoint: CGPoint(x: lhs.startPoint.x - rhs.startPoint.x,
                                y: lhs.startPoint.y - rhs.startPoint.y),
            endPoint: CGPoint(x: lhs.endPoint.x - rhs.endPoint.x,
                              y: lhs.endPoint.y - rhs.endPoint.y))
    }
    
    static func -= (lhs: inout AnimatableSegment, rhs: AnimatableSegment) {
        lhs = lhs - rhs
    }
    
    static func + (lhs: AnimatableSegment, rhs: AnimatableSegment) -> AnimatableSegment {
        return AnimatableSegment(
            startPoint: CGPoint(x: lhs.startPoint.x + rhs.startPoint.x,
                                y: lhs.startPoint.y + rhs.startPoint.y),
            endPoint: CGPoint(x: lhs.endPoint.x + rhs.endPoint.x,
                              y: lhs.endPoint.y + rhs.endPoint.y))
    }
    
    static func += (lhs: inout AnimatableSegment, rhs: AnimatableSegment) {
        lhs = lhs + rhs
    }
}
