//
//  svFriendListView.swift
//  apiLesson
//
//  Created by Leonid Nifantyev on 23.11.2020.
//

import SwiftUI
import PromiseKit

struct svFriendListView: View {
    
    @ObservedObject var viewModel = svFriendListViewModel()
    
    var body: some View {
        
        List(viewModel.friendList) { friend in
            svFriendRow(friend: friend)
        }
    }
}

struct svFriendListView_Previews: PreviewProvider {
    static var previews: some View {
        svFriendListView()
    }
}


class svFriendListViewModel: ObservableObject {
    let service = FriendsService()
    @Published var friendList: [FriendInfoViewItem] = []
    
    init() {
        firstly {
            service.getFirendInfo()
        }.map { friendInfoList in
            friendInfoList.map { friend in
                FriendInfoViewItem(name: friend.firstName, imageUrlString: friend.photo50)
            }
        }.done { items in
            self.friendList = items
        }.catch { error in
            debugPrint(error.localizedDescription)
        }
    }
}
