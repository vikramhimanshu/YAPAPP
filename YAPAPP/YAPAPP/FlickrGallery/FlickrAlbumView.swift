//
//  FlickrAlbumView.swift
//  YAPAPP
//
//  Created by Tantia, Himanshu on 30/7/20.
//  Copyright © 2020 Himanshu Tantia. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI
//import QGrid
//import WaterfallGrid

//This is the view that is visible to the users. Our aim should be to keep this really dumb - no calcualtions, business logic, url formations, etc etc...

struct PhotoCardView: View {
    let photo: FlickrPhoto

    var body: some View {
        VStack {
            WebImage(url: photo.photoUrl)
            .resizable() // Resizable like SwiftUI.Image, you must use this modifier or the view will use the image bitmap size
                .placeholder(Image(systemName: .photoCardViewPlaceholderImageName))
            .indicator(.activity)
            .animation(.easeInOut(duration: PhotoCardViewModel.durationForImageAnimation))
            .transition(.fade)
            .aspectRatio(contentMode: .fit)

            Text(self.photo.title)
            .lineLimit(.photoCardViewTitleTextLineLimit)
        }.frame(alignment: .center)
    }
}

struct PhotoCardViewModel {
    static var durationForImageAnimation : Double {
        return 0.5
    }
    
    @available(*, deprecated, message: "See 'extension Font' in 'FlickrAlbumViewCellModel.swift' file and use 'flickrAlbumViewCellTitleTextFont' property instead")
    static var fontForTitleText: Font {
        return .photoCardViewTitleTextFont
    }
}

//Alternative approach is to extend respective classes and models instead of using a seperate ViewModel where it makes sense. IMO this is much cleaner and readable and blends in with the language.
//Some things to think about though - Could this be easily readable for existing memebers of the team? What about new members? What if a dev from a different background is joing us?
//I dont have an answer of whats a better way. I prefer chucking all the related extensions in a file and call it ViewModel - in our case PhotoCardViewModel and use them.
//But this is a good candidate for a team vote.
extension Font {
    static var photoCardViewTitleTextFont : Font {
        return .body
    }
}
extension String {
    static var photoCardViewPlaceholderImageName: String {
        return "photo"
    }
}
extension Int {
    static var photoCardViewTitleTextLineLimit: Int {
        return 2
    }
}



/*
 I tried using a few third-party libraries for trying instead of my ListView approach, but none of them worked for me.
 For now I'm sticking with my approach for 2 reasons,
 1. Thought its dirty, it works - If I waited to perfect this I would not have achieved any better - Quick win.
 2. I could work on creating my GridView for iOS 13 and below because Apple has one for iOS 14 and above.
 The amount of regret-spend (wasted code, time and effort) is minimal and I'm able to progress with an intention to itirate and improve.
 */

/*
struct FlickrAlbumView2: View {
    let photos: [FlickrPhoto]
    let isLoading: Bool
    let onScrolledAtBotton: () -> Void
    
    var body: some View {
        WaterfallGrid(photos) { p in
            PhotoCardView(photo: p)
            .onAppear {
                if (self.photos.first == p) {
                    self.onScrolledAtBotton()
                }
            }
        }
        .gridStyle(columns: 3)
    }
}


//I chose QGrid because it had the maximum number of stars and was updated recently. In choosing the 
struct FlickrAlbumView: View {
    let photos: [FlickrPhoto]
    let isLoading: Bool
    let onScrolledAtBotton: () -> Void
    
    var body: some View {
        VStack {
            //Look at QGrid initialization below. The same can also be implemented like:
            //
            //QGrid(photos, columns: 3) { FlickrAlbumViewCell(photo: $0) }
            //
            //but I call this 'Selfish' programing. Something written in a way that only you (or few) understand. - This may be a simple example but I guess you get the point I'm trying to make.
            //Another common example is using stuff like Tuples in Swift (unless I'm biased, am I?). This could be confusing to beginers or devs with little experience at first. I'm sure use of Tuples is intended to aggrandize the code, but you can always use a Struct instead to enhance readability.
            QGrid(photos, columns: FlickrAlbumViewModel.maxNumberOfColumns) { photo in
                PhotoCardView(photo: photo)
                    .onAppear {
                        if (self.photos.first == photo) {
                            self.onScrolledAtBotton()
                        }
                    }
            }
            .background(Color(.blue))
//            if isLoading {
//                loadingIndicator
//            }
        }
    }
    
    private var loadingIndicator: some View {
        Spinner(style: .medium) //This is how we can use some of the UIKit components
        .frame(idealWidth: .infinity, maxWidth: .infinity, alignment: .center)
    }
}

struct FlickrAlbumView_Previews: PreviewProvider {
    static var previews: some View {
        FlickrAlbumView(photos: [FlickrPhoto](), isLoading: true) {
        }
    }
}

struct FlickrAlbumViewModel {
    static var maxNumberOfColumns: Int { return 3}
}
*/
