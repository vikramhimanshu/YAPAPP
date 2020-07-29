//
//  FlickrPhotoAlbumView.swift
//  YAPAPP
//
//  Created by Tantia, Himanshu on 28/7/20.
//  Copyright © 2020 Himanshu Tantia. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI
import Combine

//This is the view that is visible to the users. Our aim should be to keep this really dumb - no calcualtions, business logic, url formations, etc etc...

struct FlickrPhotoListView: View {
    let photos: [[FlickrPhoto]]
    let isLoading: Bool
    let onScrolledAtBotton: () -> Void
    
    var body: some View {
        List {
            photosList
            if isLoading {
                loadingIndicator
            }
        }
    }

    private var photosList: some View {
        ForEach(photos, id: \.self) { array in
            ListAlbumViewItem(photos: array).onAppear {
                if self.photos.last == array {
                    self.onScrolledAtBotton()
                }
            }
        }
    }
        
    private var loadingIndicator: some View {
        Spinner(style: .medium) //This is how we can use some of the UIKit components
        .frame(idealWidth: .infinity, maxWidth: .infinity, alignment: .center)
    }
}

//struct FlickrPhotoAlbumView_Previews: PreviewProvider {
//    static var previews: some View {
//        FlickrPhotoAlbumView(presenter: FlickrPhotosSearchPresenter(interactor: FlickrPhotosSearchInteractor()))
//    }
//}

struct ListAlbumViewItem : View {
    var photos: [FlickrPhoto]
    var availableWidth : CGFloat { //This calculation doesn't belong here as well
        return UIScreen.main.bounds.width/3
    }
    #warning("use 'photoUrl' property of FlickrPhoto")
    var body: some View {
        HStack {
            ForEach(photos) { photo in
                VStack {
                    Text(photo.title).font(.body) //Potentially use an getter var and call it displayTitle - This way if you need to change that we can handle that in the Entity extension instead of touching anything else.
                    .lineLimit(3) //Business logic - Can we change the number of lines?
                    WebImage(url: URL(string: "http://farm\(photo.farm).static.flickr.com/\(photo.server)/\(photo.id)_\(photo.secret).jpg")) /*We can leverage the power of extentions and move this to the FlickrPhoto Entity - this is here on purpose*/
                    .resizable() // Resizable like SwiftUI.Image, you must use this modifier or the view will use the image bitmap size
                    .placeholder(Image(systemName: "photo")) // Placeholder Image - Should this come from a ViewModel? Well its a compoenent of the View as such, so looks alright. But if the business/branding wants the image chnaged? Its business logic, so probably doesnt belong here.
                    .indicator(.activity)
                    .animation(.easeInOut(duration: 0.5)) //Business logic
                    .transition(.fade)
//                    .scaledToFit()
                    .aspectRatio(contentMode: .fit)
                }
            }
        }.frame(idealWidth: UIScreen.main.bounds.width, maxHeight: availableWidth)
    }
}
