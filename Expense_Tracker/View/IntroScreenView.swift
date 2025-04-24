//
//  IntroScreenView.swift
//  Expense Tracker
//
//  Created by Saloni Singh on 31/03/25.
//

import SwiftUI

struct IntroScreenView: View {
    // visibility status
    @AppStorage("isFirsttime") private var isFirstTime: Bool = true
    
    var body: some View {
        VStack(spacing: 20){
            Text("What's new in the\nExpense Tracker")
                .font(.largeTitle.bold())
                .multilineTextAlignment(.center)
                .padding(.top, 65)
                .padding(.bottom, 35)
            
            //points view
            VStack(alignment: .leading, spacing: 25){
                PointView(symbol: "dollarsign", title: "Transactions", subTitle: "Keep track of your earnings and expenses.")
                
                PointView(symbol: "chart.bar.fill", title: "Visual Charts", subTitle: "View your transactions using eye-catching graphic representations.")

                
                PointView(symbol: "magnifyingglass", title: "Advance Filters", subTitle: "Keep track of your earnings and expensesFind the expenses you want by advance search nd filtering.")
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 15)
            
            Spacer(minLength: 10)
            
            Button(action: {
                isFirstTime =  false
            }
                   , label: {
                Text("Continue")
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(appTint.gradient, in: .rect(cornerRadius: 12))
                    .contentShape(.rect)
            })
        }
        .padding(15)
    }
    
    //points view
    func PointView(symbol: String, title: String, subTitle: String) -> some View{
        HStack(spacing: 15){
            Image(systemName: symbol)
                .font(.largeTitle)
                .frame(width: 45)
                .overlay(gradient.mask(Image(systemName: symbol).font(.largeTitle)))
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.title)
                    .fontWeight(.semibold)
                Text(subTitle)
                    .foregroundStyle(.gray)
            }
        }
    }
}

#Preview {
    IntroScreenView()
}
