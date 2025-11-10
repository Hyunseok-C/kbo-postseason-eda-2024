## ⚾ **2024 KBO 정규시즌 데이터 시각화**

![R](https://img.shields.io/badge/R-276DC3?style=flat&logo=r&logoColor=white)
![IDE](https://img.shields.io/badge/RStudio-75AADB?logo=rstudio&logoColor=white)
![RMarkdown](https://img.shields.io/badge/RMarkdown-.Rmd-blue)

---

### 👥 팀 프로젝트
- 멤버: 최현석, 정형윤
- 과목: `2024-2` 탐색적 자료분석 및 시각화 (Exploratory Data Analysis and Visualization)
- 제출일: 2024.12.16

---

### 👤 역할 분담
- 최현석(조장): RMarkdown로 ppt 작성, R 코드 기반 시각화 전체 구현, 분석 아이디어 제시 및 결과 해석, 발표
- 정형윤: 데이터 수집, 야구 도메인 지식 제공, 분석 아이디어 제시 및 결과 해석, 발표

---

### 📊 데이터 소개
- 출처: KBO 공식 홈페이지 기록실 (2024.03.23~10.01)
- 데이터: `KBO League 2024.xlsx`
  - sheet = 1: 타자 개별 성적 (299명)
  - sheet = 2: 투수 개별 성적 (290명)
  - sheet = 3: 연도별 총 관객수 통계
- 주요 변수: 타자(AVG, OPS, R, RBI, HR 등 28개), 투수(ERA, SO, BB, IP, WHIP 등 34개)

---

### 🎯 연구 주제
1. 포스트시즌 진출 여부에 따른 팀별 총 득점과 실점 비교
2. 포스트시즌 진출 여부에 따른 팀별 타자 OPS, 투수 ERA 주요 지표 비교
3. 포스트시즌 진출 여부에 따른 팀별 득점(R)과 홈런(HR)의 상관관계 분석

---

### 🔍 분석 방법
- 데이터 전처리: readxl로 KBO 데이터를 불러오고, 결측값("-")을 0으로 치환 후 수치형 변환 등
- 시각화 도구: `ggplot2`, `RColorBrewer`, `ggrepel`, `gridExtra`
- 그래프: 막대그래프, 박스플롯, 산점도로 주요 지표 시각화

---

### 🧠 결론
- 데이터 기반 분석을 통해 팀 성적 차이를 시각적으로 확인 및 분석
- 포스트시즌 진출팀의 특징
  1. 높은 득점 효율성 및 낮은 실점 관리
  3. 균형 잡힌 OPS·ERA 지표
  4. 다양한 득점 전략 (홈런 + 타격 조합)


