//
//  RecentsView.swift
//  Expense Tracker
//
//  Created by Saloni Singh on 31/03/25.
//

import SwiftUI
import SwiftData

struct RecentsView: View {
    //user properties
    @AppStorage("userName") private var userName: String = "" //will be utilized when build settings view
    
    // view properties
    @State private var startDate: Date = .now.startOfMonth
    @State private var endDate: Date = .now.endOfMonth
    @State private var showFilterView: Bool = false
    @State private var selectedCategory: CategoryModel = .expense
    
    //for animation
    @Namespace private var animation
//    @Query(sort: [SortDescriptor<TransactionModel>(\.dateAdded, order: .reverse)], animation: .snappy)
//    private var transactions: [TransactionModel]
    
    var body: some View {
        GeometryReader{
            //for animation purpose
            let size = $0.size
            
            NavigationStack{
                ScrollView(.vertical){
                    LazyVStack(spacing: 10, pinnedViews: [.sectionHeaders]){
                        Section{
                            //date filter button
                            Button(action: {
                                showFilterView =  true
                            }, label: {
                                Text("\(format(date: startDate, format: "dd - MM - yy")) to \(format(date: endDate, format: "dd - MM - yy"))")
                                    .font(.caption2)
                                    .foregroundStyle(.gray)
                            })
                            .hSpacing(.leading )
                            
                            FilterTransactionView(startDate: startDate, endDate: endDate){ transactions in
                                //card view
                                CardView(
                                    income: total(transactions, category: .income),
                                    expense: total(transactions, category: .expense)
                                )
                                
                                //custom segmented control
                                CustomSegmentedControl()
                                    .padding(.bottom, 10)
                                
                                //transactionrow
                                ForEach(transactions.filter({ $0.category == selectedCategory.rawValue }), id: \.dateAdded){ transaction in
                                    TransactionRow(transaction)
                                }
                            }
                        } header: {
                            HeaderView(size)
                        }
                    }
                    .padding(15)
                }
                .background(.gray.opacity(0.15))
                .blur(radius: showFilterView ? 8 : 0)
                .disabled(showFilterView)
            }
            .overlay{
                    if showFilterView {
                        DateFilterView(start: startDate, end: endDate, onSubmit: {
                            start, end in
                            startDate = start
                            endDate = end
                            showFilterView = false
                        }, onClose: {
                            showFilterView = false
                        })
                        .transition(.move(edge: .leading))
                    }
            }
            .animation(.snappy, value: showFilterView)
        }
    }
    
    //header view
    @ViewBuilder
    func HeaderView(_ size: CGSize) -> some View{
        HStack(spacing: 10){
            VStack(alignment: .leading, spacing: 5){
                Text("Welcome!")
                    .font(.title.bold())
                
                if !userName.isEmpty{
//                    Text(userName)
//                        .font(.callout)
//                        .foregroundStyle(.gray)
                    UserProfileView()
                }
            }
            .visualEffect{ content, geometryProxy in
                content
                    .scaleEffect(headerScale(size, proxy: geometryProxy), anchor: .topLeading)
            }
            
            Spacer(minLength: 0)
            
            NavigationLink{
                TransactionView()
            } label: {
                Image(systemName: "plus")
                    .font(.title)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .frame(width: 40, height: 40)
                    .background(appTint.gradient, in: .circle)
                    .contentShape(.circle)
            }
        }
        .padding(.bottom, userName.isEmpty ? 10 : 5)
        .background {
            VStack(spacing: 0){
                Rectangle()
                    .fill(.ultraThinMaterial)
                
                Divider()

            }
            .visualEffect{content, geometryProxy in
                content
                    .opacity(headerBGOpacity(geometryProxy))
            }
            .padding(.horizontal, -15)
            .padding(.top, -(safeArea.top + 15))
        }
    }
    
    //tranctionrow
    @ViewBuilder
    func TransactionRow(_ transaction: TransactionModel) -> some View {
        NavigationLink(destination: TransactionView(editTransaction: transaction)) {
            TransactionCardView(transaction: transaction)
        }
        .buttonStyle(.plain)
    }

    func CustomSegmentedControl() -> some View {
        HStack(spacing: 0){
            ForEach(CategoryModel.allCases, id: \.rawValue){ category in
                Text(category.rawValue)
                    .hSpacing()
                    .padding(.vertical, 10)
                    .background{
                        if category == selectedCategory {
                            Capsule()
                                .fill(.background)
                                .matchedGeometryEffect(id: "ACTIVETAB", in: animation)
                        }
                    }
                    .contentShape(.capsule)
                    .onTapGesture {
                        withAnimation(.snappy){
                            selectedCategory = category
                        }
                    }
            }
        }
        .background(.gray.opacity(0.15), in: .capsule)
        .padding(.top, 5)
    }
    
    func headerBGOpacity(_ proxy: GeometryProxy) -> CGFloat {
        let minY = proxy.frame(in: .scrollView).minY + safeArea.top
        
        return minY > 0 ? 0 : (-minY / 15)
    }
    
    func headerScale(_ size: CGSize, proxy: GeometryProxy) -> CGFloat {
        let minY =  proxy.frame(in: .scrollView).minY
        let screenHeight = size.height
        
        let progress = minY / screenHeight
        let scale = (min(max(progress,0),1)) * 0.3
        
        return 1 + scale
    }
}

#Preview {
    RecentsView()
}
