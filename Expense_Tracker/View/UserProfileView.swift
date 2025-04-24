//
//  UserProfileView.swift
//  Expense Tracker
//
//  Created by Saloni Singh on 02/04/25.
//

import SwiftUI

struct UserProfileView: View {
    @AppStorage("userName") private var userName: String = ""
    @State private var image = UIImage()
    @State private var showSheet: Bool = false
    
    var body: some View {
        VStack(spacing: 10){
            ZStack{
                if image.size.width == 0 { // Check if no image is set
                    Image(systemName: "person.circle.fill") // Placeholder image
                        .resizable()
                        .foregroundColor(.gray)
                        .frame(width: 70, height: 70)
                        .background(Color.black.opacity(0.2))
                        .clipShape(Circle())
                        .padding(8)
                }
                else{
                    Image(uiImage: self.image)
                        .resizable()
                        .cornerRadius(50)
                        .padding(.all, 4)
                        .frame(width: 70, height: 70)
                        .background(Color.black.opacity(0.2))
                        .aspectRatio(contentMode: .fill)
                        .clipShape(Circle())
                        .padding(8)
                }
                
                Image(systemName: "pencil")
                    .padding(5)
                    .font(.headline)
                    .bold()
                    .background(appTint.gradient)
                    .cornerRadius(50)
                    .foregroundColor(.white)
                    .onTapGesture {
                        showSheet = true
                    }
                    .sheet(isPresented: $showSheet) {
                        ImagePicker(sourceType: .photoLibrary, selectedImage: self.$image)
                    }
                    .padding(.top,60)
                    .padding(.leading,50)
            }
            Text("\(userName)")
                .font(.caption)
                .bold()
                .foregroundStyle(.gray)
        }
    }
}

#Preview {
    NavigationStack{
        UserProfileView()
    }
}
