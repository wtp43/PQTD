//
//  TimerView.swift
//  PQTD
//
//  Created by William Tang on 2023-01-15.
//

import SwiftUI
import UserNotifications

//LinearGradient(gradient: Gradient(colors: [Color.accentColor, Color("TimerColor")])
//startPoint: .topLeading,
//endPoint: .bottomTrailing),

struct TimerView: View {
    @EnvironmentObject var listViewModel: IPQViewModel
    @EnvironmentObject var categoryViewModel: CategoryViewModel

    @State var curItemID: String = "1"
    @State var nextItemID: String = "1"
    @State var counter: Int = 0
    @State var timerRunning: Bool = false

    
    let timer = Timer.publish(every: 1.0, on: .main, in: .common).autoconnect()
    
    var body: some View {
        NavigationView {
            VStack (alignment: .leading){
                //Timer Stack
                ZStack {
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color.white)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)

                    Circle()
                        .trim(from: 0, to: 1)
                        .stroke(Color.black.opacity(0.04), style: StrokeStyle(lineWidth: 14, lineCap: .round))
                        .frame(width: 200, height: 200)
                    Circle()
                        .trim(from: 0, to: 1)
                        .stroke(Color.blue, style: StrokeStyle(lineWidth: 2, lineCap: .round))
                        .frame(width: 170, height: 170)
                    
                    Circle()
                        .trim(from: 0, to: CGFloat(counter)/CGFloat(listViewModel.getItem(itemID: curItemID).remainingTime))
                        .stroke(Color.accentColor, style: StrokeStyle(lineWidth: 14, lineCap: .round))
                        .frame(width: 200, height: 200)
                        .rotationEffect(.degrees(-90))
                    
                    
                    Image(systemName: timerRunning ? "pause.fill" : "play.fill")
                        .scaleEffect(2)
                        .onTapGesture {
                            self.timerRunning.toggle()
                        }
                    VStack{
                        HStack {
                            VStack {
                                Text(listViewModel.getItem(itemID: curItemID).getFormattedTime(totalSeconds: listViewModel.getItem(itemID: curItemID).remainingTime))
                                    .font(.system(size:24))
                                    .foregroundColor(Color.black.opacity(0.7))
                                    .padding(.horizontal, 15)
                                    .padding(.top, 10)
                                Text("Duration")
                                    .font(.system(size:14))
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.black)
                            }
                            Spacer()
                        }
                        Spacer()
                        HStack {
                            Spacer()
                            Image(systemName: "arrow.counterclockwise.circle.fill")
                                .scaleEffect(2)
                                .onTapGesture {
                                    self.timerRunning = false
                                    listViewModel.getItem(itemID: curItemID).decrementRemainingTime(time: -counter)
                                    listViewModel.getItem(itemID: curItemID).incrementElapsedTime(time: -counter)
                                    self.counter = 0
                                    
                                }
                                .padding(.horizontal, 30)
                                .padding(.bottom, 30)
                                .scaleEffect(1.2)


                            
                        }
                    }
                }
                .frame(minWidth: 0, maxWidth:.infinity, maxHeight: 250)
                    .foregroundColor(Color.blue)
                    .padding(.horizontal, 20)
                    .cornerRadius(10)

                
                Text("Current Task")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.horizontal)
                    .padding(.top)

               
                ListRowView(item: listViewModel.getItem(itemID:curItemID),
                            category: categoryViewModel.getCategory(categoryID: listViewModel.getItem(itemID:curItemID).categoryID))
    
                Text("Next Task")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.horizontal)
                    .padding(.top)

                ListRowView(item: listViewModel.getItem(itemID:curItemID),
                            category: categoryViewModel.getCategory(categoryID: listViewModel.getItem(itemID:curItemID).categoryID))
                
                Spacer()

            }
            .onAppear(perform: {
                self.curItemID = listViewModel.getFirstItem().id
               // self.nextItemID = 0
            })
            .onReceive(timer, perform: { value in
                if listViewModel.getItem(itemID:curItemID).isCompleted {
                    timer.upstream.connect().cancel()
                    self.timerRunning = false
                }
                if timerRunning {
                    self.counter += 1
                    updateItemModelTime(itemID: curItemID)
                }
            })
            .navigationTitle(Text("Timer"))
            .background(Color.black.opacity(0.03))
        }
    }
    
    func updateItemModelTime(itemID: String) {
        listViewModel.decrementItemRemainingTime(
            item:listViewModel.getItem(itemID:curItemID),
            time:1)
        listViewModel.incrementItemElapsedTime(
            item:listViewModel.getItem(itemID:curItemID),
            time:1)
    }
    
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView()
            .environmentObject(IPQViewModel())
            .environmentObject(CategoryViewModel())

    }
}
