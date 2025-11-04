### KBO분석_기말과제_코드_최현석&정형윤
#--------------------------------------
# (1) KBO League 2024.xlsx 엑셀 파일 읽기 - 관객수
library(readxl)
filepath <- "C:\\Users\\chs02\\OneDrive\\바탕 화면\\python_vs\\_(2024)DATASCINACE\\jupyter_class\\DATA\\KBO정규시즌_2024.xlsx"
attend <- read_excel(filepath, sheet = 3)

# (2) 연도별 프로야구 총 관객 수 선그래프
library(ggplot2)
a0 <- ggplot(attend, aes(x = 연도, y = 총합))
a1 <- a0 + geom_line(color = "orange", size = 1) + 
  geom_point(color = "orange", size = 2.5) + 
  scale_y_continuous(breaks = seq(0, 13000000, 2000000), labels = scales::comma) +
  labs(title = 'KBO Baseball Audience Attendance by Year',
       x = 'Year', y = 'Number of Audience') +
  theme_bw() +
  theme(
    plot.title = element_text(face = "bold", size = 10),
    axis.title.x = element_text(size = 7),  
    axis.title.y = element_text(size = 7),
    axis.text.y = element_text(size = 6),
    axis.text.x = element_text(size = 6)
  ); a1

#----------------------------------------
## (1) KBO League 2024.xlsx 엑셀 파일 읽기 - 투수
batter <- read_excel(filepath, sheet=1)
head(batter)
dim(batter)

## (2) 자료형 변경 및 열 추가
# AVG, SLG, OBP, OPS의 열 값 중 -'를 0으로 치환
batter$AVG[batter$AVG == "-"] <- 0
batter$SLG[batter$SLG == "-"] <- 0
batter$OBP[batter$OBP == "-"] <- 0
batter$OPS[batter$OPS == "-"] <- 0
# 숫자형으로 변환
batter$AVG <- as.numeric(batter$AVG)
batter$SLG <- as.numeric(batter$SLG)
batter$OBP <- as.numeric(batter$OBP)
batter$OPS <- as.numeric(batter$OPS)

# 팀 순위 벡터
team_rank <- c("KIA" = 1, "삼성" = 2, "LG" = 3, "두산" = 4, "KT" = 5,
               "SSG" = 6, "롯데" = 7, "한화" = 8, "NC" = 9, "키움" = 10)
# 순위 열 추가
batter$rank <- team_rank[batter$팀명]

# 포스트시즌 진출여부 열 추가
batter$postseason <- ifelse(batter$rank <= 5, "Qualified", "Not Qualified")

# 팀명을 순서있는 팩터로 설정 (하위권->상위권)
batter$팀명 <- factor(batter$팀명, levels = rev(names(team_rank)))

## (3) 타자 데이터 주요 변수 기초통계정보
batter1 <- batter[,c('선수명','팀명','AVG','PA','R','H','HR','RBI','SO','OPS', 'rank', 'postseason')]
summary(batter1) 

## (4) 타자 주요변수 데이터 예시
batter1[batter1$선수명 == '김도영',]


#---------------------------------------
## (1) KBO League 2024.xlsx 엑셀 파일 읽기 - 타자
pitcher <- read_excel(filepath, sheet=2)
head(pitcher)
dim(pitcher)

## (2) 자료형 변경 및 열 추가
# ERA, WPCT, WHIP, AVG의 열 값 중 -'를 0으로 치환
pitcher$ERA[pitcher$ERA == "-"] <- 0
pitcher$WPCT[pitcher$WPCT == "-"] <- 0
pitcher$WHIP[pitcher$WHIP == "-"] <- 0
pitcher$AVG[pitcher$AVG == "-"] <- 0
# 숫자형 변환
pitcher$ERA <- as.numeric(pitcher$ERA)
pitcher$WPCT <- as.numeric(pitcher$WPCT)
pitcher$WHIP <- as.numeric(pitcher$WHIP)
pitcher$AVG <- as.numeric(pitcher$AVG)

# 순위 열 추가
pitcher$rank <- team_rank[pitcher$팀명]

# 포스트시즌 진출여부 열 추가
pitcher$postseason <- ifelse(pitcher$rank <= 5, "Qualified", "Not Qualified")

# 팀명을 순서있는 팩터로 설정 (하위권->상위권)
pitcher$팀명 <- factor(pitcher$팀명, levels = rev(names(team_rank)))  

## (3) 투수 데이터 주요 변수 기초통계정보
pitcher1 <- pitcher[,c('선수명','팀명','ERA','W','L','WPCT','IP','BB','SO','R', 'rank', 'postseason')]
summary(pitcher1) 

## (4) 투수 주요변수 데이터 예시
pitcher1[pitcher1$선수명 == '원태인',]


#-----------------------------------------------------------
### 시각화
# 연구주제1: 포스트시즌 진출여부에 따른 팀별 총 득점과 실점
# 연구주제2: 포스트시즌 진출여부에 따른 팀별 주요지표 타자 OPS과 투수 ERA
# 연구주제3: 포스트시즌 진출여부에 따른 득점과 홈런의 관계


## 주제1. 포스트시즌 진출여부에 따른 팀별 총 득점과 실점
# 1-1. 포스트시즌 진출여부에 따른 팀별 총 득점 막대그래프
library(RColorBrewer)
team_colors <- c(brewer.pal(n = 10, name = "RdBu"), 'lightcoral', '#BFEFFF')
sum_r1 <- aggregate(R ~ postseason, data = batter, FUN = sum); sum_r1
bat <- merge(sum_r1, batter, by='postseason', suffixes = c("_post", "")); bat
b1 <- ggplot(bat, mapping=aes(x = 팀명, y = R, fill = 팀명, group=팀명)) +
  geom_bar(aes(y = R_post/5, fill = ifelse(postseason == "Qualified", "red", "blue")), stat = "identity", position = "dodge", width = 1.0, alpha = 0.02) +
  geom_bar(stat = "identity", show.legend = FALSE, width=0.7) +
  scale_fill_manual(values = team_colors) +
  coord_cartesian(ylim = c(600, 880)) +
  scale_y_continuous(breaks = seq(600, 880, by = 50)) +
  geom_hline(data = sum_r1, aes(yintercept = R/5, color = postseason), 
             alpha=0.8, linetype = 2, size = 0.5, color=c('red','blue')) +
  labs(title = "Total Runs Scored by Team", 
       x = "Team", y = "Runs Scored",
       subtitle="2024 KBO League",
       caption="Korea Baseball Organization") +
  theme_light() +
  theme(legend.position = "None",
        plot.title = element_text(face = "bold", size = 10),
        axis.title.x = element_text(size = 7),  
        axis.title.y = element_text(size = 7),
        axis.text.y = element_text(size = 6),
        axis.text.x = element_text(size = 6)); b1


# 1-2. 포스트시즌 진출여부에 따른 팀별 총 실점 막대그래프
sum_r2 <- aggregate(R ~ postseason, data = pitcher, FUN = sum); sum_r2
pit <- merge(sum_r2, pitcher, by='postseason', suffixes = c("_post", "")); pit
b2 <- ggplot(pit, mapping = aes(x = 팀명, y = R, fill = 팀명, group = 팀명)) +
  geom_bar(aes(y = R_post/5, fill = ifelse(postseason == "Qualified", "red", "blue")), stat = "identity", position = "dodge", width = 1.0, alpha = 0.03) +
  geom_bar(stat = "identity", show.legend = FALSE, width=0.7) +
  scale_fill_manual(values = team_colors) +
  coord_cartesian(ylim = c(600, 880)) +
  scale_y_continuous(breaks = seq(600, 880, by = 50)) +
  geom_hline(data = sum_r2, aes(yintercept = R/5, color = postseason), 
             alpha=0.8, linetype = 2, size = 0.5, color=c('red','blue')) +
  labs(title = "Total Runs Allowed by Team", 
       x = "Team", y = "Runs Allowed",
       subtitle="2024 KBO League",
       caption="Korea Baseball Organization") +
  theme_light() +
  theme(legend.position = "None",
        plot.title = element_text(face = "bold", size = 10),
        axis.title.x = element_text(size = 7),  
        axis.title.y = element_text(size = 7),
        axis.text.y = element_text(size = 6),
        axis.text.x = element_text(size = 6)); b2

# 1-3. 1-1과 1-2 합치기
library(gridExtra)
grid.arrange(b1, b2, ncol = 2)


## 주제2. 포스트시즌 진출여부에 따른 팀별 주요지표 타자 OPS과 투수 ERA
# 2-1. 포스트시즌 진출 여부에 따른 팀별 타자 OPS 박스플롯
bsub1 <- subset(batter, PA >= summary(batter$PA)['Median']) # 타석 중앙값 89타자 이상인 데이터
mean_values1 <- aggregate(OPS ~ postseason, data = bsub1, FUN = mean); mean_values1
t0 <- ggplot(bsub1, aes(x = postseason, y = OPS, fill =팀명))
t1 <- t0 + geom_boxplot(data=bsub1, aes(x = postseason, y = OPS, fill = postseason), 
                        alpha = 0.6, width=1.0, color = NA) +
  geom_boxplot(width = 0.5) + 
  scale_fill_manual(values = team_colors) +
  geom_hline(data = mean_values1, aes(yintercept = OPS, color = postseason), 
             alpha=0.8, linetype = 2, size = 0.5, color=c('red','blue')) +
  labs(title = 'Comparison of Batters OPS', x = 'Postseason Advancement',
       subtitle="2024 KBO League",
       caption="Korea Baseball Organization") + 
  theme_light() +
  theme(legend.position = "left",
        legend.text = element_text(size = 6),
        legend.key.size = unit(0.5, "cm"),
        plot.title = element_text(face = "bold", size = 10),
        axis.title.x = element_text(size = 7),  
        axis.title.y = element_text(size = 7),
        axis.text.y = element_text(size = 6),
        axis.text.x = element_text(size = 6)) ; t1

# 2-2. 포스트시즌 진출 여부에 따른 팀별 투수 ERA 박스플롯
psub1 <- subset(pitcher, IP >= summary(pitcher$IP)['Median']) # 이닝 중앙값 32이닝 이상인 데이터
mean_values2 <- aggregate(ERA ~ postseason, data = psub1, FUN = mean); mean_values2
p0 <- ggplot(psub1, aes(x = postseason, y = ERA, fill =팀명))
p1 <- p0 + geom_boxplot(data=psub1, aes(x = postseason, y = ERA, fill = postseason), 
                        alpha = 0.6, width=1.0, color = NA) +
  geom_boxplot(width = 0.5) +
  scale_fill_manual(values = team_colors) +
  geom_hline(data = mean_values2, aes(yintercept = ERA, color = postseason), 
             alpha=0.8, linetype = 2, size = 0.5, color=c('red','blue')) +
  labs(title = 'Comparison of Pitchers ERA', x = 'Postseason Advancement',
       subtitle="2024 KBO League",
       caption="Korea Baseball Organization") +
  theme_light() +
  theme(legend.position = "right",
        legend.text = element_text(size = 6),
        legend.key.size = unit(0.5, "cm"),
        plot.title = element_text(face = "bold", size = 10),
        axis.title.x = element_text(size = 7),  
        axis.title.y = element_text(size = 7),
        axis.text.y = element_text(size = 6),
        axis.text.x = element_text(size = 6)); p1

# 2-3. 2-1과 2-2 합치기
grid.arrange(t1, p1, ncol = 2)


## 주제 3. 포스트시즌 진출여부에 따른 홈런 수와 득점의 관계
library(ggrepel)
bsub2 <- subset(batter, PA >= summary(batter$PA)['Median'] & HR >= summary(bsub1$HR)[2]) # 홈런 상위 75%이상인 데이터
mean_value3 <- aggregate(cbind(HR, R) ~ postseason, bsub1, mean); mean_value3
p2 <- ggplot(batter, aes(x = R, y = HR)) + geom_point(alpha = 0.3, color="gray50"); p2
p3 <- p2 + geom_point(alpha = 0.3, data = bsub1, mapping = aes(x = R, y = HR, color=postseason)); p3
p4 <- p3 + geom_point(data = bsub2, mapping = aes(x = R, y = HR, color=postseason)) +
  geom_smooth(method='lm', se=FALSE, data=bsub2, mapping = aes(color=postseason)) +
  geom_text_repel(data = subset(batter, HR >= 30), aes(label = 선수명), color = 'black', size=3) +
  geom_hline(data = mean_value3, aes(yintercept = HR, color = postseason), 
             alpha=0.8, linetype = 2, size = 0.5, color=c('red','blue')) +
  geom_vline(data = mean_value3, aes(xintercept = R, color = postseason), 
             alpha=0.8, linetype = 2, size = 0.5, color=c('red','blue')) +
  labs(title = "Runs and Home Runs by Postseason Advancement", 
       x = "Runs", y = "Home Runs",
       subtitle="2024 KBO League",
       caption="Korea Baseball Organization") +
  theme_light() +
  theme(legend.position = "right",
        legend.text = element_text(size = 6),
        legend.key.size = unit(0.5, "cm"),
        plot.title = element_text(face = "bold", size = 10),
        axis.title.x = element_text(size = 7),  
        axis.title.y = element_text(size = 7),
        axis.text.y = element_text(size = 6),
        axis.text.x = element_text(size = 6)); p4

# 타자의 중앙값 이상의 기초통계정보
summary(bsub1$R[bsub1$postseason == 'Qualified'])
summary(bsub1$R[bsub1$postseason == 'Not Qualified'])
summary(bsub1$HR[bsub1$postseason == 'Qualified'])
summary(bsub1$HR[bsub1$postseason == 'Not Qualified'])

# 타자의 중앙값 이상의 상관계수
cor(bsub1$R, bsub1$HR)
cor(bsub1[bsub1$postseason == 'Qualified',c("R","HR")],) # 포스트 진출팀
cor(bsub1[bsub1$postseason == 'Not Qualified',c("R","HR")],) # 포스트 비진출팀



