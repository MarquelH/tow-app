//
//  RequestListView.swift
//  MikesApp
//
//  Created by Marquel Hendricks on 5/19/22.
//

import SwiftUI

struct RequestListView: View {
    @State private var selectedStateIndex = 0
    @State private var requestList = [TowRequest]()
    @State private var showingChatView = false
    private var requestTypeHash = [0:"Pending", 1:"Accepted", 2:"Rejected", 3:"Completed"]
    private var requestListViewModel: RequestListViewModel
    
    @Binding var loggedInStatus: Int
    @ObservedObject var homeViewModel: HomeViewModel
    
    init(loggedInStatus: Binding<Int>, homeViewModel: HomeViewModel) {
        self.requestListViewModel = RequestListViewModel()
        _loggedInStatus = loggedInStatus
        self.homeViewModel = homeViewModel
    }
    
    var body: some View {
        VStack {
            MikesHeaderView(loggedInStatus: $loggedInStatus, homeViewModel: self.homeViewModel)
                .padding()
                .background(Color.white)
            
            Picker("Request State",
                    selection: $selectedStateIndex,
                    content: {
                            Text("Pending").tag(0)
                            Text("Accepted").tag(1)
                            Text("Rejected").tag(2)
                            Text("Completed").tag(3)
                    })
                .pickerStyle(SegmentedPickerStyle())
                .foregroundColor(Color.red)
                .padding()
                .onChange(of: selectedStateIndex) { tag in
                    print("ONCHANGE REQUEST LIST: \(self.requestList)")
                    requestListViewModel.fetchRequests(requestType: requestTypeHash[tag]!) { towRequestList in
                        if !self.requestList.isEmpty {
                            withAnimation {
                                self.requestList = towRequestList
                            }
                        } else {
                            //animation looks weird from empty to non-empty list
                            self.requestList = towRequestList
                        }
                    }
                }
            Divider()
            ScrollView {
                if requestList.isEmpty {
                    Text("No tow requests yet!")
                        .font(.headline)
                        .padding()
                        .frame(alignment: .center)
                } else {
                    ForEach(requestList, id: \.self) { towRequest in
                        VStack {
                            HStack(spacing: 16) {
                                Image(systemName: "person.fill")
                                    .font(.system(size: 32))
                                    .padding()
                                    .overlay(RoundedRectangle(cornerRadius: 32)
                                                .stroke(Color.black, lineWidth: 1)
                                    )
                                
                                VStack(alignment: .leading) {
                                    Text("\(towRequest.customerFirstName) \(towRequest.customerLastName.first!.description)")
                                        .font(.system(size: 14, weight: .bold))
                                    
                                    Text("\(towRequest.sourceName) -> \(towRequest.destinationName)")
                                        .font(.system(size: 14))
                                        .foregroundColor(Color(.lightGray))
                                }
                                Spacer()
                                Text("22d")
                                    .font(.system(size: 14, weight: .semibold))
                            }
                            .onTapGesture {
                                //Go into chat view & load up bubbles based on towRequest
                                showingChatView.toggle()
                                print("Entry tapped")
                                print(towRequest)
                            }
                            .sheet(isPresented: $showingChatView) {
                                MikesChatView(towRequest: towRequest, requestListViewModel: requestListViewModel, selectedStateIndex: $selectedStateIndex)
                            }
                            .padding(.top)
                            Divider()
                                .padding(.vertical, 8)
                        }.padding(.horizontal)
                    }
                }
            }
        }
        .onAppear {
            requestListViewModel.fetchRequests(requestType: requestTypeHash[selectedStateIndex]!) { towRequestList in
                print("ONAPPEAR REQUESTLIST: \(towRequestList)")
                self.requestList = towRequestList
            }
        }
    }
}
