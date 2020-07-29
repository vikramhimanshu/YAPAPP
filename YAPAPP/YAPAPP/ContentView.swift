//
//  ContentView.swift
//  YAPAPP
//
//  Created by Tantia, Himanshu on 28/7/20.
//  Copyright © 2020 Himanshu Tantia. All rights reserved.
//

import SwiftUI
import Combine

//This is called a Container View pattern - our home page or main view is FlickrPhotoListView. But we using ContentView in SceneDelegate as our initial view which inturn 'contains' the main view. Seperating the app from any of our modules. For the remainder of the app we will be using VIPER design pattern. VIPER has evolved from the Clean Architecture and is extreemly scalable and robust. Espically if working on complex apps and bigger teams.
//Amongts other advantages, it facilitates: Code Reuse, Single Responsibility Principle, Scalability, Extensibility, Maintaince, Agility (ability to change stuff quickly - espically UI), attempts to decouple View and Navigation (potentially do away with Coordinator pattern), Distributed dev teams and ability to work on multiple modules/features or multiple people working on same module/feature, Nestable - go VIPER in VIPER for extra complex modules and many more... FWIW - I have been a fan since 2016.
struct ContentView: View {
    
    @ObservedObject var presenter: FlickrPhotosSearchPresenter
    
    var body: some View {
        FlickrPhotoListView(photos: presenter.state.gridViewPhotos, isLoading: presenter.state.hasNext, onScrolledAtBotton: {
            self.presenter.getNextPageIfAvailable()
        }).onAppear {
            self.presenter.getNextPageIfAvailable()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(presenter: FlickrPhotosSearchPresenter(interactor: FlickrPhotosSearchInteractor()))
    }
}


import UIKit

struct Spinner: UIViewRepresentable {
    let style: UIActivityIndicatorView.Style

    func makeUIView(context: Context) -> UIActivityIndicatorView {
        let spinner = UIActivityIndicatorView(style: style)
        spinner.hidesWhenStopped = true
        spinner.startAnimating()
        return spinner
    }
    
    func updateUIView(_ uiView: UIActivityIndicatorView, context: Context) {}
}
