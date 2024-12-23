# CleanArchitecture_Sample



### Spec
 Xcode : MVVM
 
 Lib: RxSwift, RxCocoa, Kingfisher, SnapKit

### API: 
GitHub_API : <https://docs.github.com/ko/rest/search/search?apiVersion=2022-11-28#search-users>

---
### 목표 
Clean Architecture 샘플 만들기.

1. protocol을 통해 추상화된 객체끼리 의존하도록 만드는 게 핵심.

1. DI(의존성 역전)를 통해 구현됨.

    ![클린아키텍처의 구조 3 영역](https://miro.medium.com/v2/resize:fit:640/format:webp/1*wvjjjXBuMfrxd7JxL8L9Ww.png)

   **1.Presentation Layer(Domain Layer를 의존) 
        1.ViewModel(Eventes,Business logic..)
        
   
   **2.Domain Layer
        1.Entities
        1.UseCases
        1.Repository
   
   **3.Data Layer(Dimain Layer를 의존)
        1.Repositories Implementation(구체타입)
        1.API(Network)
        1.Persistence DB
        
        
*(1에서 3으로 갈수록 고수준 컴포넌트. 1이 가장 변경이 많음(저수준) 3으로 갈수록 변경점 적음.)*

1. 테스트코드(XCTest)작성
