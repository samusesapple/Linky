# Linky
나만의 링크 저장소 앱, 링키
---
<br>

### 개발 배경
---
좋은 인사이트, 맛집 정보, 꿀팁 등을 보면 항상 나와의 채팅에 보내왔습니다. 결국 나중엔 찾기 힘들고 귀찮아 채팅창에 보지 않는 링크만 쌓이게 되는 걸 보고 영감이 떠올랐습니다. <br>
***다양한 카테고리를 자유롭게 생성하여 링크를 쉽게 정리하고 저장 및 공유*** 할 수 있는 앱이 있음 편리할 것 같아 프로젝트를 시작하게 되었습니다. 이전 틴더 클론 코딩에서 배운 내용을 적극 활용하여 프로젝트를 만들 예정입니다.
<br>
<br>

### 프로젝트 기간
---
2023.04.16 ~ 4.30 (출시 완료) <br>
앱스토어 링크 : https://apps.apple.com/kr/app/linky-%EB%A7%81%ED%82%A4/id6448656359
<br>
<br>

### 개발 환경
---
#### 디자인
* Figma : https://www.figma.com/file/q36b0YMWUcHuubdS9bcJ9p/Untitled?node-id=0-1&t=PPE0udKoYKuNCcju-0 
#### StoryBoard vs Code
* 100% 코드 (UIKit)
#### 디자인 패턴
* MVVM 패턴
#### 사용 기술 및 오픈소스 라이브러리
* Database: Realm (https://github.com/realm/realm-swift), UserDefaults (https://developer.apple.com/documentation/foundation/userdefaults)
* Toast-Swift (https://github.com/scalessec/Toast-Swift)
* JGProgressHUD (https://github.com/JonasGessner/JGProgressHUD)
* LinkPresentation (https://developer.apple.com/documentation/linkpresentation) 
<br>
<br>

### 문제 및 해결과정
---
#### 1. CollectionView - 데이터를 reload하면, 다른 셀까지 빈 셀의 UI가 반영 되는 문제
* 문제상황 : <br> 
![Simulator Screen Recording - iPhone 14 Pro - 2023-04-19 at 18 44 10](https://user-images.githubusercontent.com/126672733/233036933-b520ec05-0ca3-4ccd-a80a-f15712706c46.gif)! <br>
<br>

1. MainVC - collectionView
<img width="550" alt="image" src="https://user-images.githubusercontent.com/126672733/233037646-8f2ccf21-9e0d-43a2-9a69-d49f71085cf8.png"> 
<br>

2. Cell VC <br> 
<img width="353" alt="image" src="https://user-images.githubusercontent.com/126672733/233037382-fd7bbaa2-62b2-4e03-b0fc-0296f868c11a.png">
<img width="608" alt="image" src="https://user-images.githubusercontent.com/126672733/233037128-51b23585-feef-4ad5-8d99-4010708fa73b.png">
<br>

* 해결과정 : dashedBorder를 sublayer 추가하는 방식으로 생성했었다. 따라서 해당 버튼이 재사용 될 때마다 호출되는 함수를 이용해, 재사용 되는 시점에 sublayer 갯수와 정확한 index를 파악하기 위해 print문과 dump문을 사용하여 디버깅을 진행했다. <br>
 디버깅 결과, sublayers 배열의 마지막 배열에 추가되었으며, 추가된 경우 총 3개의 sublayer가 존재 / 추가되지 않은 경우 2개의 sublayer가 존재해야함을 확인 할 수 있었다.
<img width="439" alt="image" src="https://user-images.githubusercontent.com/126672733/235032314-932ad43b-edcb-4ea6-8116-7f12c361dbc7.png">

* 해결 : fileButton의 sublayer 갯수가 2 초과인 경우, 마지막 layer를 제거하는 조건문을 prepareForReuse 함수에 사용하여 문제를 해결했다.
<img width="603" alt="image" src="https://user-images.githubusercontent.com/126672733/235033291-10c991dc-7f44-4010-9f5b-6037a8ac68a3.png">


![Simulator Screen Recording - iPhone 14 - 2023-04-28 at 10 37 28](https://user-images.githubusercontent.com/126672733/235033705-a90ad13a-66ac-4d65-9ecf-e082a2faed9e.gif)


#### 2. LinkCell - Cell의 imageButton에 해당되는 링크의 미리보기 이미지를 세팅하는 방법
* 문제상황 : 단순 url을 통해 받아오는 이미지가 아닌, 해당 http 문서의 header에 있는 메타데이터를 가져와야하는 상황. URLSession을 통한 네트워킹은 익숙하지만 메타데이터를 긁어온 적은 없기에 새로운 배움이 될 것 같다.
<br>

* 해결과정 : 메타데이터 가져오는 법을 구글링 하여, 애플에서 제공하는 LinkPresentation이라는 프레임워크를 알게 되었다. 공식 문서를 살펴보니, 사용법도 잘 나와있었다.
<img width="762" alt="image" src="https://user-images.githubusercontent.com/126672733/234455161-a99856bf-4385-4366-b3a7-c4f1b84a7cc6.png">


<img width="680" alt="image" src="https://user-images.githubusercontent.com/126672733/234460147-d8e89d80-628e-4fd0-ad8e-bb3c3b9a238c.png">

1. LinkPresentation 프레임워크를 import 한, MetadataNetworkManager 라는 네트워킹 객체를 싱글톤으로 만들었다. <br>
2. ViewModel로부터 받을 url이 유효한지 확인 후, 유효한 url이라면 startFetchingMetadata(for: )에 해당 url을 사용하여 메타데이터를 얻어온다. <br>
3. 에러 유무를 확인 후, 에러가 있다면 함수를 종료 / 에러 없는 경우 LPLinkView에 해당 메타데이터를 바인딩 하고 completion() 파라미터에 linkView를 전달시켰다. <br>
4. 네트워킹 작업이 다 끝나면 UI를 그리는 작업을 할 예정이기 때문에, completion 블럭이 스텍 프레임을 벗어나도록 @escaping 키워드를 붙여주고 DispatchQueue 중 main 큐에 async하게 작동하도록 했다. <br> 

-> 해당 코드로 작동하니, 이미지만 표시하고 싶은 나의 니즈와는 맞지 않게 공유 시트에 띄우면 좋을 것 같은 리치한 url 메타데이터를 가져오게 되었다. 이미지만 가져오고, 한번 로딩 된 이미지는 캐싱하는 코드로 수정해보았다. 

* 해결 : 
<img width="773" alt="image" src="https://user-images.githubusercontent.com/126672733/234474003-dbf506f5-fdde-4034-bb0c-b25f013aa377.png">
 1. url을 캐싱키로 만들기 <br>
 2. 키에 해당하는 값이 있으면 (캐싱된 이미지가 있으면) completion블럭에 해당 이미지 보내기 <br>
 3. 키에 대한 값이 없는 경우 (캐싱된 이미지 없는 경우), 메타데이터의 imageProvider를 통해 UIImage메타타입으로 이미지 불러오기. <br>
 4. 불러온 image는 NSItemProviderReading? 타입이므로, image를 UIImage 타입으로 타입캐스팅 하기 <br>
 5. UIImage가 된 Image를 캐싱하기 + completion블럭에 image 전달해주기 <br>
<br>

![Simulator Screen Recording - iPhone 14 - 2023-04-26 at 14 34 49](https://user-images.githubusercontent.com/126672733/234479160-7743ace4-f35a-415c-9b1a-baf37773a5f6.gif) <br>

 번외) 살펴보니, 헤더의 타이틀 부분만 빼올 수도 있어서 유저가 제목을 지정하지 않는 경우 임시 제목을 지정해서 저장해주는 로직을 추가 구현했다. (매번 제목 지정하지 않으면 해당 링크가 어떤 것에 대한 링크인지 찾기 어려워지므로 유저 인터페이스 관점에서도 편리성에 좋을거라 판단했다..! + 하단코드 참고)
 <img width="681" alt="image" src="https://user-images.githubusercontent.com/126672733/234455951-8b4d9d8b-a581-4b79-9e80-0a3c55059957.png">
<br>

#### 3. Share Extension 구현을 통한 외부 share sheet를 통해 앱에 링크 저장하기
* 문제상황: Share Extension에는 Realm이 존재하지 않으므로, 외부 링크를 받아서 Realm에 해당 링크를 전달하는 로직 구현 필요 
<br>

* 해결 과정: Share Extension에 대해 구글링하여 관련 레퍼런스를 참고한 결과, UserDefaults에 저장을 한 후, 저장된 데이터를 Realm에 넘겨주는 방식으로 데이터를 저장하기로 했다. 
1. Extension과 기존 앱이 연동될 수 있도록 app group을 생성했으며, share sheet에서 받은 링크의 url을 저장할 키와 유저가 지정한 제목을 저장할 키, 총 2가지 키를 만들었다. <br>
<img width="453" alt="image" src="https://user-images.githubusercontent.com/126672733/235100308-7c4a2cd9-23ff-4ca9-8f75-6a4cd63c6f52.png"> <br>

2. ShareVC의 didSelectPost() 함수 안에 String타입으로 변환된 url과, contentText를 UserDefaults에 저장하는 로직을 구현하여, post 버튼이 눌리면 해당 데이터를 우선 UserDefaults에 저장하도록 했다.
<img width="977" alt="image" src="https://user-images.githubusercontent.com/126672733/235118982-3dbc6101-4072-430a-beb6-1e642a3c33f2.png">

3. UserDefaults에 저장된 URL을 Realm 데이터베이스에 옮겨줘야한다. 해당 로직을 어디에 구현할까 고민하다, 유저가 앱에 들어온 순간; SceneDelegate의 sceneDidBecomeActive() 시점에 실행하기로 했다. <br>
<img width="937" alt="image" src="https://user-images.githubusercontent.com/126672733/235108115-bd5d56a2-97d7-4c5f-8ada-264c48abc483.png">
<img width="974" alt="image" src="https://user-images.githubusercontent.com/126672733/235108642-e12e810c-668b-46b5-828f-bd5f152a7966.png">

4. UserDefaults를 이용한 상단의 로직을 테스트해보니, 1개의 키에 1개의 값만 저장할 수 있으므로 1개의 링크를 저장할 때마다 앱을 들어와야 저장이 되는 오류를 발견했다. (여러개 공유해놓으면 마지막에 공유된 링크로 키값이 변경되므로 마지막 링크만 저장됨) 해당 오류를 해결하기 위해 UserDefaults의 url을 저장하는 타입을 String이 아닌 [String]으로 변경했다. 그리고 shared extension과 앱에서도 접근해야하기 때문에 타입 저장 속성으로 만들어서 데이터 영역에 해당 배열을 올렸다. 속성감시자 get set을 사용하여 키값으로 해당 배열에 접근해 url을 세팅할 수 있도록 만들었다.
<img width="805" alt="image" src="https://user-images.githubusercontent.com/126672733/235277376-6b15c8b8-2d9e-43a0-8081-8b7e3a82e8ce.png">

5. Share Extension - 유저가 post 버튼을 누르면 UserDefaults의 urlArray 배열에 새로운 String타입 url을 append 하도록 로직을 수정했다.
<img width="815" alt="image" src="https://user-images.githubusercontent.com/126672733/235277722-e3bffac4-bf56-428d-90be-7935a53a9618.png">

6. Scene Delegate - 반복문 for문을 사용하여 배열이 있는 동안, 해당 배열을 append하도록 했다. 또한, 화면이 활성화 된 순간 네트워킹을 진행하면 viewModel에 데이터가 바로 반영되지 않는 문제점을 발견했다. 또한 url 데이터를 공유하는 작업은, 사파리나 크롬과 같은 외부 앱에서 하는 작업이므로 앱이 백그라운드에 진입할 수 밖에 없음을 고려하여 시점을 sceneWillEnterForeground()으로 변경했다.
<img width="800" alt="image" src="https://user-images.githubusercontent.com/126672733/235280539-67273488-8930-4df4-854e-99e30085258d.png">
<img width="769" alt="image" src="https://user-images.githubusercontent.com/126672733/235277993-e7931910-3e24-4d63-b310-e935e84cf01f.png">
>> Scene Delegate에 실행시킨 결과, 자동적으로 메타데이터를 통해 제목을 지어주는 로직을 구현하여 realm에 데이터를 저장하는 것에 한계가 있었다. 따라서 mainVC의 viewWIllAppear에 해당 로직을 반영시키기로 했다.
* 해결 : MainViewViewModel에 해당 로직을 만들었으며, @escaping 키워드를 활용하여 네트워킹이 완료된 후, collectionView를 업데이트 하도록 구현했다.
<img width="560" alt="image" src="https://user-images.githubusercontent.com/126672733/235332569-1180554c-867d-4913-a1d9-4f05a4958cb6.png">
<img width="783" alt="image" src="https://user-images.githubusercontent.com/126672733/235332528-9af38caa-cc7f-499e-9993-d32f3a0df5c6.png">
<br>
<br>


### 심사과정
---
* 2023.04.30 리젝 없이 심사 통과하여 출시 되었습니다.
<img width="1102" alt="image" src="https://user-images.githubusercontent.com/126672733/235353400-883b4450-dd66-4441-9170-fe858482b08f.png">






