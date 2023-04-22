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

<br>
<br>

### 문제 및 해결과정
---
#### 1. CollectionView - 데이터를 reload하면, 다른 셀까지 빈 셀의 UI가 반영 되는 문제
* 문제상황 : <br> 
![Simulator Screen Recording - iPhone 14 Pro - 2023-04-19 at 18 44 10](https://user-images.githubusercontent.com/126672733/233036933-b520ec05-0ca3-4ccd-a80a-f15712706c46.gif) <br>
<br>

1. MainVC - collectionView
<img width="550" alt="image" src="https://user-images.githubusercontent.com/126672733/233037646-8f2ccf21-9e0d-43a2-9a69-d49f71085cf8.png"> 
<br>

2. Cell VC <br> 
<img width="353" alt="image" src="https://user-images.githubusercontent.com/126672733/233037382-fd7bbaa2-62b2-4e03-b0fc-0296f868c11a.png">
<img width="608" alt="image" src="https://user-images.githubusercontent.com/126672733/233037128-51b23585-feef-4ad5-8d99-4010708fa73b.png">
<br>

#### 2. LinkCell - Cell의 imageButton에 해당되는 링크의 미리보기 이미지를 세팅하는 방법
* 문제상황 : 단순 url을 통해 받아오는 이미지가 아닌, 해당 http 문서의 header에 있는 메타데이터를 가져와야하는 상황. URLSession을 통한 네트워킹은 익숙하지만 메타데이터를 긁어온 적은 없기에 새로운 배움이 될 것 같다.
<br>

#### 3. LinkCell - 클린한 MVVM 패턴에 대한 고민... (Networkmanager를 통해 데이터를 CRUD하는 역할은 누구에게 주어야 할 것인가?)
* 문제상황 : Tinder클론을 바탕으로 이해했다고 생각했던 MVVM 패턴에 대해, 네트워킹의 역할은 누구에게 정해진 것인가에 대한 의문점이 생겼다. 네트워킹 하는 객체를 따로 만들긴 했지만, 해당 객체를 이용하여 데이터를 CRUD 하는 역할을 과연 View에 주는것이 맞는가 싶어 코드 리펙토링을 고려하게 되었다. View가 네트워킹을 한 결과를 갖고 ViewModel에게 요청을 할 경우, View의 코드가 비대해지기도 하고 그렇게 되면 View가 직접 Model(Entity)에 접근하게 되기에 고민을 시작하게 되었다.. (MVVM 패턴에 따르면, View와 Model은 철저히 분리되어 있어야 한다.)
<br>

* 해결 과정: Clean MVVM을 키워드로 여러 레퍼런스들을 참고했다. 일부 레퍼런스들은 Controller에서 네트워킹을 한다는 이야기도 있었지만, 현 프로젝트에서 비즈니스 모델은 링크와 폴더이고, 해당 비즈니스 모델 형태로 Realm에 데이터를 저장했다는 사실에 집중했다. <br>
 View에서 직접적으로 네트워킹하여 데이터를 CRUD 한다면, ViewModel의 역할은 불명확해지고 코드도 깔끔해지지 않을 것이라 판단되었다. 그리고 View는 수동적인 형태로 유지시켜, 외부 자극(버튼이 눌리는 둥..)이 오면 그것을 ViewModel에게 알리는 정도의 역할만 수행하는 것이 더 깔끔하다 생각했다. 따라서 ViewModel이 View가 요청하는대로 Model(Entity)로부터 데이터를 CRUD하는 중간다리 역할을 수행하도록 코드를 리펙토링했다. 
<img width="911" alt="image" src="https://user-images.githubusercontent.com/126672733/233768482-94fd9834-ffc2-467e-b059-40bfafa2746f.png">

* 해결 결과: ViewModel이 네트워킹을 하여 실제 데이터를 받고, 해당 데이터를 View에게 뿌릴 형태로 다듬어서 뿌리는 역할을 하도록 코드를 리펙토링했다.
<img width="509" alt="image" src="https://user-images.githubusercontent.com/126672733/233768927-7343e5ae-21b6-46b9-a02d-00118d7e1cef.png">


