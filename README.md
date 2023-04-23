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




