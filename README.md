# WallaMarvel - Marvel Heroes App

![iOS](https://img.shields.io/badge/iOS-14.0+-blue.svg)
![Swift](https://img.shields.io/badge/Swift-5.5+-orange.svg)
![Xcode](https://img.shields.io/badge/Xcode-13.0+-blue.svg)
![Architecture](https://img.shields.io/badge/Architecture-Clean%20Architecture%20%2B%20MVVM-green.svg)

A modern iOS application showcasing Marvel superheroes using Clean Architecture, MVVM pattern, SwiftUI, and Combine framework. Built with scalable architecture, reactive programming, and advanced iOS development patterns.

## 🎯 Overview

WallaMarvel is a comprehensive iOS application that demonstrates modern iOS development practices by displaying Marvel superheroes in an intuitive, user-friendly interface. The app showcases advanced architectural patterns, reactive programming with Combine, and modern SwiftUI development.

### Key Highlights
- **Clean Architecture**: Separation of concerns across presentation, domain, and data layers
- **MVVM Pattern**: Reactive view models with SwiftUI integration
- **Coordinator Pattern**: Navigation management and flow control
- **Combine Framework**: Reactive programming for data binding and async operations
- **SwiftUI**: Modern declarative UI framework
- **Pagination**: Infinite scroll with efficient data loading
- **Search Functionality**: Real-time local search with debouncing
- **Error Handling**: Comprehensive error states and recovery mechanisms

  ## 🏗️ Architecture

The application follows **Clean Architecture** principles combined with **MVVM** pattern for optimal separation of concerns, testability, and maintainability.

### Layer Responsibilities

#### 1. **Presentation Layer**
- **SwiftUI Views**: Declarative UI components
- **ViewModels**: Business logic presentation and state management
- **Coordinators**: Navigation flow management
- **Adapters**: Bridge between UIKit and SwiftUI when needed

#### 2. **Domain Layer**
- **Use Cases**: Application-specific business rules
- **Entities**: Core business objects
- **Repository Protocols**: Data access abstractions

#### 3. **Data Layer**
- **API Client**: Network communication with Marvel API
- **Data Sources**: Data retrieval and management
- **Repository Implementations**: Concrete data access implementations
- **Data Models**: API response models and transformations

### Key Transformations

#### 1. **Navigation Evolution**
- **Before**: Direct view controller navigation
- **After**: Coordinator pattern for centralized navigation management

#### 2. **Data Flow Evolution**
- **Before**: ViewController → Presenter → API → DataModel
- **After**: View → ViewModel → UseCase → Repository → DataSource → API

#### 3. **State Management Evolution**
- **Before**: Manual state updates and delegate patterns
- **After**: Reactive state with `@Published` properties and Combine

#### 4. **UI Evolution**
- **Before**: UIKit
- **After**: SwiftUI with declarative syntax


