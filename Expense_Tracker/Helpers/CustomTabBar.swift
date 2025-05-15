//
//  CustomTabBar.swift
//  Expense_Tracker
//
//  Created by Saloni Singh on 14/05/25.
//

import SwiftUI

struct CustomTabBar: View {
    @Binding var tabSelection: Int
    var animation: Namespace.ID
    
    @State private var midPoint: CGFloat = 1.0
    
    private let screenWidth = UIApplication.shared.screenWidth
    private var tabWidth: CGFloat {
        return screenWidth/5
    }
    
    var body: some View {
        let iconH: CGFloat = screenWidth * (180/1000)
        ZStack{
            BeziperCurveBelowPath(midPoint: midPoint)
                .foregroundStyle(.gray.opacity(0.15))
            
            HStack{
                ForEach(0..<TabModel.allCases.count, id: \.self){ index in
                    let tab = TabModel.allCases[index]
                    let isCurrent = tabSelection == index + 1
                    
                    Button{
                        withAnimation(.spring(response: 0.6, dampingFraction: 0.7,blendDuration: 0.7)){
                            tabSelection = index + 1
                            midPoint = tabWidth * (-CGFloat(tabSelection-3))
                        }
                    } label: {
                        VStack(spacing: 2){
                            Image(systemName: tab.systemImage)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .aspectRatio(
                                    isCurrent ? 0.5 : 0.7,
                                    contentMode: .fit
                                )
                                .foregroundStyle(isCurrent ? .white : appTint)
                                .frame(
                                    width: isCurrent ? iconH : 35,
                                    height: isCurrent ? iconH : 35
                                )
                                .background{
                                    if isCurrent{
                                        Circle()
                                            .fill(appTint.gradient)
                                            .matchedGeometryEffect(id: "CircleAnimation", in: animation)
                                    }
                                }
                                .offset(y: isCurrent ? -iconH/2 : 0)
                            
                            if !isCurrent{
                                Text(tab.rawValue)
                                    .font(.caption)
                                    .fontDesign(.rounded)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(isCurrent ? .white : appTint)
                        .offset(y: !isCurrent ? -5 : 0)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .frame(maxHeight: iconH)
        .onAppear {
            //tabWidth = screenWidth/5
            midPoint = tabWidth * (-CGFloat(1-3))
        }
    }
}


struct BeziperCurveBelowPath: Shape {
    
    var midPoint: CGFloat
    
    var animatableData: CGFloat {
        get { return midPoint }
        set { midPoint = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        return Path { path in
            let maxW: CGFloat = 1000.0
            let maxH: CGFloat = 200.0
            
            let tabW = rect.width
            let tabH = tabW * (maxH/maxW)
            
            path.move(
                to: CGPoint(x: tabW*(688.57/maxW)-midPoint, y: 0.0)
            )
            path.addCurve(
                to: CGPoint(x: tabW*(602.09/maxW)-midPoint, y: tabH*(53.06/maxH)),
                control1: CGPoint(x: tabW*(652.05/maxW)-midPoint, y: 0.0),
                control2: CGPoint(x: tabW*(618.97/maxW)-midPoint, y: tabH*(20.68/maxH))
            )
            path.addCurve(
                to: CGPoint(x: tabW*(580.5/maxW)-midPoint, y: tabH*(82.13/maxH)),
                control1: CGPoint(x: tabW*(596.56/maxW)-midPoint, y: tabH*(63.68/maxH)),
                control2: CGPoint(x: tabW*(589.31/maxW)-midPoint, y: tabH*(73.48/maxH))
            )
            path.addCurve(
                to: CGPoint(x: tabW*(501.13/maxW)-midPoint, y: tabH*(114.99/maxH)),
                control1: CGPoint(x: tabW*(559.34/maxW)-midPoint, y: tabH*(102.88/maxH)),
                control2: CGPoint(x: tabW*(530.77/maxW)-midPoint, y: tabH*(114.71/maxH))
            )
            path.addCurve(
                to: CGPoint(x: tabW*(418.68/maxW)-midPoint, y: tabH*(81.32/maxH)),
                control1: CGPoint(x: tabW*(469.99/maxW)-midPoint, y: tabH*(115.29/maxH)),
                control2: CGPoint(x: tabW*(440.67/maxW)-midPoint, y: tabH*(103.31/maxH))
            )
            path.addCurve(
                to: CGPoint(x: tabW*(397.52/maxW)-midPoint, y: tabH*(52.3/maxH)),
                control1: CGPoint(x: tabW*(410.03/maxW)-midPoint, y: tabH*(72.67/maxH)),
                control2: CGPoint(x: tabW*(402.93/maxW)-midPoint, y: tabH*(62.88/maxH))
            )
            path.addCurve(
                to: CGPoint(x: tabW*(311.44/maxW)-midPoint, y: 0.0),
                control1: CGPoint(x: tabW*(381.02/maxW)-midPoint, y: tabH*(20.07/maxH)),
                control2: CGPoint(x: tabW*(347.64/maxW)-midPoint, y: 0.0)
            )
            path.addLine(
                to: CGPoint(x: 0.0, y: 0.0)
            )
            path.addLine(
                to: CGPoint(x: 0.0, y: tabH*(200/maxH))
            )
            path.addLine(
                to: CGPoint(x: tabW*(1000/maxW), y: tabH*(200/maxH))
            )
            path.addLine(
                to: CGPoint(x: tabW*(1000/maxW), y: 0.0)
            )
            path.addLine(
                to: CGPoint(x: tabW*(688.57/maxW), y: 0.0)
            )
            path.closeSubpath()
        }
    }
}

extension UIApplication {
    var keyWindow: UIWindow {
        UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .flatMap({ $0.windows })
            .first(where: { $0.isKeyWindow })
        ??
        UIWindow()
    }
    
    var screenWidth: CGFloat {
        UIApplication.shared.keyWindow.bounds.size.width
    }
    
    var screenHeigth: CGFloat {
        UIApplication.shared.keyWindow.bounds.size.height
    }
}

