//
//  ContentView.swift
//  Pinch App
//
//  Created by Yusril on 03/02/23.
//

import SwiftUI

struct ContentView: View {
    //MARK: - PROPERTY
    @State private var isAnimated: Bool = false
    @State private var imageScaled: CGFloat = 1
    @State private var imageOffset: CGSize = .zero
    
    //MARK: - FUNCTION
    
    func ResetImageState() {
        return withAnimation(.spring()) {
            imageScaled = 1
            imageOffset = .zero
        }
    }
    
    //MARK: - CONTENT
    
    var body: some View {
        VStack {
            NavigationView {
                ZStack {
                    Color.clear
                    
                    //MARK: Page Image
                    Image("magazine-front-cover")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(10)
                        .padding()
                        .shadow(color: .black.opacity(0.2), radius: 12, x: 2, y: 2)
                        .opacity(isAnimated ? 1 : 0)
                        .offset(x: imageOffset.width, y: imageOffset.height)
                        .scaleEffect(imageScaled)
                    //MARK: 1. tap gesture
                        .onTapGesture(count: 2, perform: {
                            if imageScaled == 1 {
                                withAnimation(.spring()) {
                                    imageScaled = 5
                                }
                            } else {
                                ResetImageState()
                            }
                        })
                    //MARK: 2. Gesture
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    withAnimation(.linear(duration: 1)) {
                                        imageOffset = value.translation
                                    }
                                }
                                .onEnded { _ in
                                    if imageScaled <= 1 {
                                        ResetImageState()
                                    }
                                }
                        )
                    
                }//: ZStack
                .navigationTitle("Pinch and Zoom")
                .navigationBarTitleDisplayMode(.inline)
                .onAppear(perform: {
                    withAnimation(.linear(duration: 1)) {
                        isAnimated = true
                    }
                })
                //MARK: Info Panel
                .overlay(
                    InfoPanelView(scale: imageScaled, offset: imageOffset)
                        .padding(.horizontal)
                        .padding(.top, 30)
                    , alignment: .top
                )
                
            }//END: Navigation
            .navigationViewStyle(.stack)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
