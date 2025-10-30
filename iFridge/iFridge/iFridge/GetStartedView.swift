//
//  GetStartedView.swift
//  iFridge
//
//  Created by Luigi Mario Aliberti on 06/05/24.
//

import SwiftUI

struct GetStartedView: View {
    
    @AppStorage("isOnboarding") var isonboarding: Bool?
    var body: some View {
        ZStack {
            Image("getstarted")
                .resizable()
                .edgesIgnoringSafeArea(.all)
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                
                Button(action: {
                    isonboarding = false
                }){
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .frame(width: 322, height: 74)
                            .foregroundColor(frameYellow)
                        
                        Text("Get Started")
                            .fontWeight(.medium)
                            .font(.system(size: 20))
                            .foregroundColor(.black)
                            
                    }.padding(.top, 600.0)
                }
            }
        }
    }


#Preview {
    GetStartedView()
}
