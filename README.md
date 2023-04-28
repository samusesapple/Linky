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
2023.04.16 ~ 진행 중
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
* Database: Realm
* Toast-Swift
* LinkPresentation

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






