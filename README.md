# YAPAPP


MVC, or Model-View-Controller: This is quite old and was extremely popular until 2010s. In this pattern the Controller modifies the View, accepts user input and interacts directly with the Model. The Controller is extremely heavy with view logic, business logic, navigations etc.

MVVM, or Model-View-ViewModel: This is a popular architecture that separates the business logic and view logic via a ViewModel. The big difference between MVVM and MVC is a view model. Unlike a view controller, ViewModel only has a one-way reference to the view and to the model. MVVM is actually a better fit for SwiftUI than VIPER.

VIPER goes further by separating the view logic from the data model logic. Only the presenter talks to the view, and only the interactor talks to the model (entity). The presenter and interactor coordinate with each other. The Presenter handles the display and user actions; The Interactor is concerned with manipulating the data and The Router handles the other screens and Presenter and Router together handle the navigation.

