//
//  FormRowStaticView.swift
//  Reminders
//
//  Created by Максим Громов on 19.03.2021.
//

import SwiftUI

struct FormRowStaticView: View {
  
  var icon: String
  var firstText: String
  var secondText: String
  
  
    var body: some View {
      HStack {
        ZStack {
          RoundedRectangle(cornerRadius: 8.0, style: .continuous)
            .fill(Color.gray)
          Image(systemName: icon)
            .foregroundColor(Color.white)
        }
        .frame(width: 36, height: 36, alignment: .center)
        Text(firstText).foregroundColor(Color.gray)
        Spacer()
        Text(secondText)
      }
    }
}

struct FormRowStaticView_Previews: PreviewProvider {
    static var previews: some View {
      FormRowStaticView(icon: "gear", firstText: "Application", secondText: "Todo")
          .previewLayout(.fixed(width: 375, height: 60))
          .padding()
    }
}
