//
//  FlickrPhotosSearchPresenter.swift
//  YAPAPP
//
//  Created by Tantia, Himanshu on 28/7/20.
//  Copyright © 2020 Himanshu Tantia. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

//Presenter is the one that interacts with the View and fecilates navigation by using Router (this componenet is missing here because there is no navigation). All our state chnages & maintenance, business logic happens here.
//We can add in a additional ViewModel if there is a need for certain aspects of UI and business logic (specific date formats, number formats, decorations etc...) of the View should we need to. ViewModel would be accessible by both Presenter and View.
class FlickrPhotosSearchPresenter : ObservableObject {
    
    struct State {
        let photos: [FlickrPhoto]
        let gridViewPhotos: [[FlickrPhoto]]
        let page: Int
        let hasNext: Bool
    }
    
    private let interactor: FlickrPhotosSearchInteractor
    
    //We would have used a router for any navigation - say clicking a photo takes us to a detail screen. That logic would not reside in the view/ViewController. We would ask the Router to give us the detail view/ViewController and Presenter would then present that ont he View - again View is dumb and can remain oblivient to these complexities. Changing navigation is now easier than ever and similarly changing the view is as well. Imgaing doing that if everything is connected in StoryBoards or in ViewController. Changing something like an action from Navigation BarButtonItem to say a FloatingButton on the view could take a couple days - dont forget testing.
    //private let router: FlickrPhotosSearchRouter
    
    @Published var searchResult: FlickrPhotosSearchResult?
    @Published private(set) var state = State(photos: [], gridViewPhotos: [[FlickrPhoto]()], page: 1, hasNext: true)
    
    private var cancellable : Set<AnyCancellable> = Set()
    
    init(interactor: FlickrPhotosSearchInteractor) {
        self.interactor = interactor
    }
    
    func getNextPageIfAvailable() {
        guard state.hasNext else { return }
        
        interactor.getPhotosFromFlickr(forSearchText: "kittens", page: state.page)
        .sink(receiveCompletion: onReceive, receiveValue: onReceive)
        .store(in: &cancellable)
    }
    
    private func onReceive(_ completion: Subscribers.Completion<Error>) {
        switch completion {
        case .finished:
            break
        case .failure(let error):
            print(error)
            state = State(photos: state.photos, gridViewPhotos: [[FlickrPhoto]()], page: state.page, hasNext: false)
        }
    }
    
    private func onReceive(_ batch: FlickrPhotosSearchResult) {
        let oldValue = self.state
        let gridViewPhotos: [[FlickrPhoto]] = transformPhotosArrayFor3ColumnGridView(using: batch.photo)
        let newValue = State(photos: oldValue.photos + batch.photo, gridViewPhotos: oldValue.gridViewPhotos + gridViewPhotos, page: oldValue.page + 1, hasNext: batch.page != batch.pages)
        self.state = newValue
    }
    
    //MARK:- Code Smell
    //This implementation has 2 issues. First issue is that this should not exist in the first place. Our view should be created in a way that it works with the format that is available. If we are having to change the data format, its probably a good point for us to stop and evaluate our options.
    //In the current scenario we are burning CPU cycles for no reason and setting ourselves up for failure because we can potentially run into race conditions as well.
    //The second issue with the implementation is a bug where we are loosing data where we break the for-loop. This hack has been placed because the API seems to be inconsistent. Now since that is beyond our control we definately need some workaround, but in that trade off we can't be loosing data.
    #warning("This needs to be refactored. Solution: Change the View -- This is a good way to remind ourselves of 'I'll get back later..' tasks and any potential code deprecation")
    //We can use #warnings for backward compatibility, keeping track of temporary code, old APIs, - with custom warning messages its easy to clean up stuff when they're no longer needed:
    private func transformPhotosArrayFor3ColumnGridView(using photo: [FlickrPhoto]) -> [[FlickrPhoto]] {
        var temp = Array(photo)
        var result: [[FlickrPhoto]] = [[FlickrPhoto]()]
        
        for _ in temp {
            var a: [FlickrPhoto] = []
            for _ in 0..<3 {
                a.append(temp.removeFirst())
            }
            result.append(a)
            if temp.count < 3 {
                break
            }
        }
        return result
    }
    
    //This is how we can perform code migrations and updates espically if the project is huge and distributed across geographies (or even otherwise).
    @available(*, deprecated, message: "Use 'func getNextPageIfAvailable()' instead. See wiki/MigratingToSwiftUI")
    func getPhotos(forSearchText text: String) {
        guard state.hasNext else { return }
        
        interactor.getPhotos(forSearchText: text, page: state.page) { result in
            switch result {
            case .success(let searchResult):
                let oldValue = self.state
                let gridViewPhotos: [[FlickrPhoto]] = self.transformPhotosArrayFor3ColumnGridView(using: searchResult.photo)
                let newValue = State(photos: oldValue.photos + searchResult.photo, gridViewPhotos: oldValue.gridViewPhotos + gridViewPhotos, page: oldValue.page + 1, hasNext: searchResult.page != searchResult.pages)
                self.state = newValue
                DispatchQueue.main.async {
                    self.searchResult = searchResult
                    self.state = newValue
                }
            case .failure(let error):
                self.state = State(photos: self.state.photos, gridViewPhotos: [[FlickrPhoto]()], page: self.state.page, hasNext: false)
                print(error)
            }
        }
    }
}
