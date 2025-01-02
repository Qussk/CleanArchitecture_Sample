# CleanArchitecture_Sample


이 레포지토리는 **Clean Architecture(클린 아키텍처)**를 이용해 구현된 iOS 샘플 프로젝트입니다. 본 프로젝트는 Clean Architecture의 핵심 개념인 추상화와 의존성 역전에 중점을 두어 구현되었습니다.


## 🛠️ 주요 기능

- **아키텍처**: MVVM (Model-View-ViewModel)
- **리액티브 프로그래밍**: RxSwift, RxCocoa
- **네트워크 계층**: Alamofire
- **이미지 로딩**: Kingfisher
- **UI 레이아웃**: SnapKit


## 📦 사용된 라이브러리

RxSwift: 반응형 프로그래밍을 위한 라이브러리로, 데이터 스트림과 이벤트를 처리합니다.
RxCocoa: RxSwift를 UIKit과 연결하기 위한 확장.
Alamofire: 경량화된 HTTP 네트워크 요청 라이브러리.
Kingfisher: 효율적인 이미지 다운로드 및 캐싱을 지원하는 라이브러리.
SnapKit: 코드 기반 제약 조건을 간결하게 작성할 수 있는 UI 레이아웃 라이브러리.


## API

GitHub_API : <https://docs.github.com/ko/rest/search/search?apiVersion=2022-11-28#search-users>


## 🎯 프로젝트 목적

1. **프로토콜을 활용한 추상화**  
   각 계층이 구체적인 구현체가 아닌 **프로토콜을 통한 추상화**된 객체에 의존하도록 구현했습니다. 이를 통해 유연하고 테스트 가능한 구조를 만들 수 있습니다.

2. **의존성 역전(DI, Dependency Injection)**  
   **의존성 역전 원칙(DIP)**을 구현하여, 계층 간의 결합도를 낮추고 코드의 확장성과 유지보수성을 높였습니다.

3. **가독성과 모듈화**  
   Clean Architecture 원칙을 준수하여 이해하기 쉽고 테스트 가능하며 유지보수하기 좋은 코드를 작성하는 데 중점을 두었습니다.

---


## 📚 프로젝트 개요

### 클린 아키텍처 다이어그램

    ![클린아키텍처의 구조 3 영역](https://miro.medium.com/v2/resize:fit:640/format:webp/1*wvjjjXBuMfrxd7JxL8L9Ww.png)

```text
       ┌───────────────┐
       │   Entities    │
       └───────────────┘
               ▲  
               │  
       ┌───────────────┐
       │   Use Cases   │
       └───────────────┘
               ▲
               │
       ┌───────────────┐
       │   ViewModel   │
       └───────────────┘
               ▲
               │
       ┌───────────────┐
       │     View      │
       └───────────────┘

```
*View에서 Entities로 갈수록 고수준 컴포넌트. View가 가장 변경이 많아 저수준 컴포넌트입니다.*
*화살표는 의존성 방향을 나타내며, 아키텍처의 외곽 계층이 내부 계층에 의존해야합니다.*

> 🔑 핵심 원칙: 안쪽 계층은 바깥쪽 계층에 대해 전혀 모른다.
> > 의존성은 항상 안쪽(Entities)으로 향한다.
> > 외곽 계층(View, Controller, Data 등)은 내부 계층(Use Cases, Entities)에 의존할 수 있지만, 반대는 불가능하다.



### 계층 및 역할
Entities: 비즈니스 모델의 핵심 데이터 구조로, UI 및 인프라와 독립적입니다.

Use Cases: 비즈니스 로직을 포함하며, 리포지토리와 ViewModel 간의 데이터 흐름을 조정합니다.

ViewModel: 프레젠테이션 로직을 처리하고 RxCocoa/RxSwift를 통해 UI와 데이터를 바인딩합니다.

View: 데이터를 보여주고 사용자와 상호작용을 처리하며, 완전히 수동적(passive)입니다.


### 설계 원칙
프로토콜 지향 프로그래밍: 각 계층은 구체적인 구현이 아닌 프로토콜을 통해 상호작용합니다.

의존성 주입(DI): 생성자를 통해 DIP를 구현합니다.

리액티브 스트림: RxSwift와 RxCocoa를 활용하여 비동기 작업과 UI 업데이트를 원활히 처리합니다.


### 폴더 구조

    ![클린아키텍처의 폴더 구조](https://github.com/kudoleh/iOS-Clean-Architecture-MVVM/raw/master/README_FILES/CleanArchitecture+MVVM.png?raw=true)

    
```text
CleanArchitectureSample
├── Presentation
│   ├── Views
│   ├── ViewModels
├── Domain
│   ├── UseCases
│   ├── Entities
├── Data
│   ├── Repositories
│   ├── Network
└── Resources
```
Presentation: UI 및 ViewModel 관련 컴포넌트.
Domain: 핵심 비즈니스 로직, 유스케이스 및 엔티티 포함.
Data: 데이터 가져오기 및 저장 처리. 리포지토리와 네트워크 계층 포함.
Resources: 애셋, 설정 파일 및 기타 유틸리티.


#### CleanArchitecture_Sample 전체 Tree. 
```text
.
├── CleanArchitecture_Sample
│   ├── CleanArchitecture_Sample
│   │   ├── AppDelegate.swift
│   │   ├── Assets.xcassets
│   │   │   ├── AccentColor.colorset
│   │   │   │   └── Contents.json
│   │   │   ├── AppIcon.appiconset
│   │   │   │   └── Contents.json
│   │   │   └── Contents.json
│   │   ├── CleanArchitecture_Sample.xcdatamodeld
│   │   │   └── CleanArchitecture_Sample.xcdatamodel
│   │   │       └── contents
│   │   ├── Data
│   │   │   ├── CoreData
│   │   │   │   └── UserCoreData.swift
│   │   │   ├── Network
│   │   │   │   ├── NetworkManager.swift
│   │   │   │   ├── UserNetwork.swift
│   │   │   │   └── UserSession.swift
│   │   │   └── Repository
│   │   │       └── UserRepository.swift
│   │   ├── Domain
│   │   │   ├── Entity
│   │   │   │   ├── CoreDataError.swift
│   │   │   │   ├── NetworkError.swift
│   │   │   │   └── UserListItem.swift
│   │   │   ├── RepositoryProtocol
│   │   │   │   └── UserRepositoryProtocol.swift
│   │   │   └── Usecase
│   │   │       └── UserListUsecase.swift
│   │   ├── Info.plist
│   │   ├── Presentation
│   │   │   ├── View
│   │   │   │   ├── HeaderTableViewCell.swift
│   │   │   │   ├── TabButtonView.swift
│   │   │   │   └── UserTableViewCell.swift
│   │   │   ├── ViewController
│   │   │   │   └── UserListViewController.swift
│   │   │   └── ViewModel
│   │   │       └── UserListViewModel.swift
│   │   └── SceneDelegate.swift
│   ├── CleanArchitecture_Sample.xcodeproj
│   │   ├── project.pbxproj
│   │   ├── project.xcworkspace
│   │   │   ├── contents.xcworkspacedata
│   │   │   ├── xcshareddata
│   │   │   │   ├── IDEWorkspaceChecks.plist
│   │   │   │   └── swiftpm
│   │   │   │       ├── Package.resolved
│   │   │   │       └── configuration
│   │   │   └── xcuserdata
│   │   │       └── byeon-yunna.xcuserdatad
│   │   │           └── UserInterfaceState.xcuserstate
│   │   └── xcuserdata
│   │       └── byeon-yunna.xcuserdatad
│   │           ├── xcdebugger
│   │           │   └── Breakpoints_v2.xcbkptlist
│   │           └── xcschemes
│   │               └── xcschememanagement.plist
│   ├── CleanArchitecture_SampleTests
│   │   ├── CleanArchitecture_SampleTests.swift
│   │   ├── Mock
│   │   │   └── MockUserRepository.swift
│   │   └── UserUsecaseTests.swift
│   └── CleanArchitecture_SampleUITests
│       ├── CleanArchitecture_SampleUITests.swift
│       └── CleanArchitecture_SampleUITestsLaunchTests.swift
└── README.md

```

        











1. 테스트코드(XCTest)작성
