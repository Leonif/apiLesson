//
//  svFriendRow.swift
//  apiLesson
//
//  Created by Leonid Nifantyev on 23.11.2020.
//

import SwiftUI
import KingfisherSwiftUI

struct svFriendRow: View {
    
    let friend: FriendInfoViewItem
    
    var body: some View {
        
        HStack {
            KFImage(URL(string: friend.imageUrlString))
                .resizable()
                .frame(width: 40, height: 40)
                .cornerRadius(20)
            Text(friend.name)
        }
    }
}

struct svFriendRow_Previews: PreviewProvider {
    static var previews: some View {
        svFriendRow(friend: FriendInfoViewItem.mock)
    }
}
