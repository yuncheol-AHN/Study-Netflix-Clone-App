Study Netflix Clone🍿
===================

👨🏻‍💻 해당 프로젝트를 통해 학습하고, 배운것들<br/>
https://pleasant-gasoline-2d7.notion.site/Netflix-Clone-187cafc9c70a4d74aa8778d530e47d8b<br/>

----
Why?
----
- 해당 프로젝트를 통해 일반적인 앱의 구성을 파악하기 위해(MVC, MVVM 등)
- 해당 프로젝트를 통해 앱 구현에 필요한 기초지식을 학습하기 위해

<br/>

What?
-----

### Home View
- 카테고리 별(Trending Movies, Trending Tvs ...) 포스터 구성
- 포스터 터치 시 Detail View로 이동

<img src = "https://user-images.githubusercontent.com/70050038/228214170-d4d86397-8f89-441a-958e-df65453483d2.gif" width="250" height="500" />

### ComingSoon View
- 개봉 예정작들을 테이블로 구성
- 셀 터치 시 Detail View로 이동

<img src = "https://user-images.githubusercontent.com/70050038/228219816-6842ed7d-c2ca-4a2d-8106-669915191961.gif" width="250" height="500" />

### Search View
- 영화검색 시 관련 영화 출력
- 셀 터치 시 Detail View로 이동 

<img src = "https://user-images.githubusercontent.com/70050038/228221860-99c81d5e-d053-4522-a115-93146bf0dc6d.gif" width="250" height="500" />

### Download View
- 영화 다운로드 시 다운로드 탭에 해당 영화 추가

<img src = "https://user-images.githubusercontent.com/70050038/228272118-dacb5d8b-a080-47dc-a379-850e69e32e80.gif" width="250" height="500" />

<br/>

How?
----

|내용|기술|
|-------|-------|
의존성 라이브러리|CocoaPods
HTTP 통신|URLSession -> Alamofire
영화 정보 |TMDB API
포스터 이미지|SDWebImage API
다운로드된 데이터|Core Data

Home View
- Table View(Header, Body cell(: Collection View))를 사용해 포스터 구성
- URLSession을 통해 TMDB로부터 영화 데이터를 가져와 카테고리별로 화면에 보여줌
- Navigation Controller, Delegate를 이용해 Detail View로의 이동 구현

<br/>

Upcoming View
- Table View를 사용해 포스터 구성
- Table View의 셀은 커스텀하여 사용
- Navigation Controller, Delegate를 이용해 Detail View로의 이동 구현

<br/>

Search View
- SearchView Controller를 사용해 검색 기능 구현
- 영화 포스터는 Collection View로 구현
- 검색 시 영화 정보를 가져오는 건 TMDB API 사용

<br/>

Download View
- CoreData를 통해 다운로드한 데이터 저장
- 실제 영상 데이터 X -> 영화 제목, 영화 설명, 포스터 URL 등등에 관한 정보
