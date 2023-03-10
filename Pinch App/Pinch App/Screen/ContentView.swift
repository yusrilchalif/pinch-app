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
    @State private var isDrawOpen: Bool = false
    
    let pages: [Page] = pagesData
    @State private var pageIndex: Int = 1
    
    //MARK: - FUNCTION
    
    func ResetImageState() {
        return withAnimation(.spring()) {
            imageScaled = 1
            imageOffset = .zero
        }
    }
    
    func CurrentPage() -> String {
        return pages[pageIndex - 1].imageName
    }
    
    //MARK: - CONTENT
    
    var body: some View {
        VStack {
            NavigationView {
                ZStack {
                    Color.clear
                    
                    //MARK: Page Image
                    Image(CurrentPage())
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
                                    PlayAudio(sound: "click", type: "wav")
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
                    //MARK: 3. Magnification
                        .gesture(
                            MagnificationGesture()
                                .onChanged { value in
                                    withAnimation(.linear(duration: 1)) {
                                        if imageScaled >= 1 && imageScaled <= 5 {
                                            imageScaled = value
                                        } else if imageScaled > 5 {
                                            imageScaled = 5
                                        }
                                    }
                            }
                                .onEnded { _ in
                                    if imageScaled > 5 {
                                        imageScaled = 5
                                    } else if imageScaled <= 1 {
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
                        .padding(.top, 10)
                    , alignment: .top
                )
                //MARK: Control UI
                .overlay(
                    Group {
                        HStack {
                            //Scale down
                            Button {
                                withAnimation(.spring()) {
                                    PlayAudio(sound: "click", type: "wav")
                                    if imageScaled > 1 {
                                        imageScaled -= 1
                                        
                                        if imageScaled <= 1 {
                                            ResetImageState()
                                        }
                                    }
                                }
                            } label: {
                                ControlImageView(icon: "minus.magnifyingglass")
                            }
                            
                            //Reset
                            Button {
                                PlayAudio(sound: "click", type: "wav")
                                ResetImageState()
                            } label: {
                                ControlImageView(icon: "arrow.up.left.and.down.right.magnifyingglass")
                            }
                            
                            //Scele up
                            Button {
                                withAnimation(.spring()) {
                                    PlayAudio(sound: "click", type: "wav")
                                    if imageScaled < 5 {
                                        imageScaled += 1
                                        
                                        if imageScaled > 5 {
                                            imageScaled = 5
                                        }
                                    }
                                }
                            } label: {
                                ControlImageView(icon: "plus.magnifyingglass")
                            }
                        }
                        
                        .padding(EdgeInsets(top: 20, leading: 12, bottom: 20, trailing: 12))
                        .background(.ultraThinMaterial)
                        .cornerRadius(12)
                        .opacity(isAnimated ? 1 : 0)
                    }
                        .padding(.bottom, 30),
                        alignment: .bottom
                )
                //MARK: Drawer
                .overlay (
                    HStack(spacing: 12) {
                        //MARK: Drawer Handle
                        
                        Image(systemName: isDrawOpen ? "chevron.compact.right" : "chevron.compact.left")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 40)
                            .foregroundStyle(.secondary)
                            .onTapGesture(perform: {
                                withAnimation(.easeOut) {
                                    PlayAudio(sound: "click", type: "wav")
                                    isDrawOpen.toggle()
                                }
                            })
                        //MARK: Thumbnail
                        ForEach(pages) { item in
                            Image(item.thumbnailName)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80)
                                .cornerRadius(8)
                                .shadow(radius: 4)
                                .opacity(isDrawOpen ? 1 : 0)
                                .animation(.easeOut(duration: 0.5), value: isDrawOpen)
                                .onTapGesture(perform: {
                                    PlayAudio(sound: "click", type: "wav")
                                    isAnimated = true
                                    pageIndex = item.id
                                })
                        }
                        
                        Spacer()
                    }//END: Drawer
                        .padding(EdgeInsets(top: 16, leading: 8, bottom: 16, trailing: 8))
                        .background(.ultraThinMaterial)
                        .cornerRadius(12)
                        .opacity(isAnimated ? 1 : 0)
                        .frame(width: 260)
                        .padding(.top, UIScreen.main.bounds.height / 12)
                        .offset(x: isDrawOpen ? 20 : 215)
                    , alignment: .topTrailing
                    
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
