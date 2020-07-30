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

//We could be using some third-party library instead of trying to write our own view. Althought we have a couple challenges with using a third-party library.
//1. Issues - When relying on is any external code, you also inherit the flaws and baggage they come with. Sometimes its hard to predict in what way those bugs can affect our code.
//2. Performance - Other issues are testing the library, ensuring that its quality is good - memory usage, cpu usage, network, FPS etc... we can potentially save the effort of writing the code but we do have to maintain it.
//3. Lifecycle and Sunset - If the library is actively being maintained and is backed by good open source community then its probably safe to assume that it wont dissappear overnight or any major bugs/(or security falws depending on what is it that you use) would be fixed pronto.
//4. Is it fit for purpose and fit for use? - Other issue is that the often re-usable libraries come with a lot of additional features and options that we probably dont need. So we can always start lite and move to a third-party lib later as well. The point I'm trying to make is, keep it simple and silly.
//5. Lastly, I did try out a few libraries instead of using the List. But I wasn't able to use them straight away. I ran into multiple issues with various libraries.

struct FlickrPhotoListView: View {
    let photos: [[FlickrPhoto]]
    let isLoading: Bool
    let onScrolledAtBotton: () -> Void
    
    var body: some View {
        List {
            mockAlbumView
            if isLoading {
                spinnerView
            }
        }
    }

    private var mockAlbumView: some View {
        ForEach(photos, id: \.self) { array in
            FlickrPhotoListViewCell(photos: array).onAppear {
                if self.photos.last == array {
                    self.onScrolledAtBotton()
                }
            }
        }
    }
        
    private var spinnerView: some View {
        Spinner(style: .medium) //This is how we can use some of the UIKit components
        .frame(idealWidth: .infinity, maxWidth: .infinity, alignment: .center)
    }
}

struct FlickrPhotoListViewCell : View {
    var photos: [FlickrPhoto]
    
    var body: some View {
        HStack {
            ForEach(photos) { photo in
                PhotoCardView(photo: photo)
            }
        }
    }
}

//For Illustration Only - Notice the difference between the above code and below. Its cleaner and slightly more reusable.
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
