//
//  ListProfileItemComp.swift
//  LumenoAi-Test
//
//  Created by Ali Haidar on 10/17/25.
//

import SwiftUI

struct ListProfileItemComp: View {
    
    
    var imgSize: CGFloat = 80
    var imageName: ImageResource
    var name: String
    var email: String
    @State private var isExpanding: Bool = false
    //    @Binding var isExpanding: Bool
    //    @EnvironmentObject var router: Router
    
    var body: some View {
        VStack{
            HStack{
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: imgSize, height: imgSize)
                    .clipShape(Circle())
                    .shadow(radius: 5, x: 0, y: 2)
                
                
                if !isExpanding{
                    VStack(alignment: .leading, spacing: 8){
                        Text(name)
                            .bold()
                            .foregroundStyle(.primary)
                        Text("\(email)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        
                    }
                    
                    Spacer()
                }
            }
        }
        .padding(0)
        .background(
            Capsule()
                .foregroundStyle(.thinMaterial)
        )
        .shadow(radius: 2, y: 2)
        .compositingGroup()
//        .onTapGesture {
        
//        }
    }
}

#Preview {
    ListProfileItemComp(imageName: .avatarEx,
                        name: "John Doe",
                        email: "johndoe@email.com",
                        //                        isExpanding: .constant(false)
    )
}
