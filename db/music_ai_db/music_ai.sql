
create database music_ai_1;

-- DROP DATABASE music_ai_1;
use music_ai_1;  -- 생성한 DB 사용하기

-- 1.회원관리
CREATE TABLE login (
    login_id BIGINT AUTO_INCREMENT PRIMARY KEY,              -- 회원 PRIMARY KEY,
    id varchar(50) UNIQUE NOT NULL,                          -- 회원 아이디 
    password varchar(200) NOT NULL                           -- 회원 패스워드

);

select * from login;

-- 2.유저관리
CREATE TABLE user (
    user_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    email varchar (100) UNIQUE NOT NULL,                    -- 회원 이메일
    gender varchar(30) NOT NULL,                            -- 회원 성별
    location varchar(200) NOT NULL,                         -- 지역
    mbti varchar(30) NOT NULL,                              -- 회원 성격(mbti)
    age int NOT NULL,                                       -- 회원 나이
    member_create datetime default current_timestamp,       -- 회원 가입 시점

    login_id BIGINT NOT NULL,
    FOREIGN KEY (login_id) REFERENCES login(login_id) ON DELETE CASCADE
);

select * from user;

-- 3.회원 검색 관련 이용 패턴 
CREATE TABLE search (                                       -- 테이블명 search
    search_id BIGINT AUTO_INCREMENT PRIMARY KEY,            -- 검색 PRIMARY KEY,
    search_lyrics varchar (500),                            -- 웹 검색 리스트  null                                  

    karaoke_id BIGINT,                                      -- 
    FOREIGN KEY (karaoke_id) REFERENCES karaoke(karaoke_id) ON DELETE CASCADE

);

select * from search;

-- 4.회원관리, 검색, 링크 추적 관련한 것들 정보의 중간 테이블
CREATE TABLE user_mg (
    login_id BIGINT NOT NULL,
    search_id BIGINT NOT NULL, 
    action_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,   -- 별도 테이블이 필요하지만 먼저 login 에서 관리 
   
    PRIMARY KEY (login_id, search_id),
    FOREIGN KEY (login_id) REFERENCES login(login_id) ON DELETE CASCADE,
    FOREIGN KEY (search_id) REFERENCES search(search_id) ON DELETE CASCADE

);
select * from user_mg;

--  노래, 아티스트, 장르, 국가, 성별, 그룹/싱글 앨범, 태그, 


-- 5.노래 목록 ( 노래 명 기준으로 등록 )        -- 장르를 기준으로 하면 필요있는지 확인 --
CREATE TABLE song (                                         -- 테이블명 song
    song_id BIGINT PRIMARY KEY,                             -- 노래 id,
    song_name varchar (225) NOT NULL,                       -- 곡 명 ( 실제 곡명길이가 최대 220 짜리도 있어서 최종 수정 )
    song_lyrics text,                                       -- 해당 노래 가사 
    songid varchar (30) NOT NULL                             -- 곡 해당정보 링크
   
   -- https://www.melon.com/song/detail.htm?songId=
);

ALTER TABLE song AUTO_INCREMENT = 1;
select * from song;
DELETE FROM song;



-- 6. 아티스트 ( 아트스트 명 기준으로 등록 )       -- 장르를 기준으로 하면 필요있는지 확인 --
CREATE TABLE artist (                                       -- 테이블명 artist
    artist_id BIGINT AUTO_INCREMENT PRIMARY KEY,             -- 아티스트 id,
    artist_name varchar (200) NOT NULL                       -- 아티스트명 (동명이인 존재가능 유니크 아님)
                                                             -- ( 실제 이름 길이가 최대 110 짜리도 있어서 최종 수정 )
);   

ALTER TABLE artist AUTO_INCREMENT = 1;
select * from artist; 
DELETE FROM artist;                                      

-- 7. 장르 대분류 ( 장르별 )     -- 장르를 기준으로 하면 필요있는지 확인 --                      
CREATE TABLE genre (                                   
    genre_id BIGINT AUTO_INCREMENT PRIMARY KEY,                -- 장르 id
    -- genre_nb int NOT NULL,                                  -- 장르 세분화시킬때 사용
    genre_name varchar(50) NOT NULL,                           -- 장르 이름들 OST,DANCE,BALLAD등등
    -- genre_menu_id BIGINT DEFAULT NULL                       -- 장르 세분화시킬때 사용

);

ALTER TABLE genre AUTO_INCREMENT = 1;
select * from genre;
DELETE FROM genre;

-- 8. 앨범 발매일  ( 앨범발매일 기준으로 년도별 기준으로 등록 )       -- 장르를 기준으로 하면 필요있는지 확인 --
CREATE TABLE album (                                           -- 테이블명 album              
    album_id BIGINT AUTO_INCREMENT PRIMARY KEY,                -- 아티스트 id,
    album_years varchar(20) NOT NULL,                          -- 앨범 년도 
    albumid varchar(30) NOT NULL                               -- 앨범 해당정보 링크 
    
    -- https://www.melon.com/album/detail.htm?albumId=
);


select * from album;
-- DELETE FROM album;

-- 9. 음악관련 연관된 중간 테이블   
CREATE TABLE music (
    song_id BIGINT NOT NULL,
    artist_id BIGINT NOT NULL,
    album_id BIGINT NOT NULL,
    genre_id BIGINT NOT NULL,

    PRIMARY KEY (song_id, artist_id, album_id, genre_id),
    FOREIGN KEY (song_id) REFERENCES song(song_id) ON DELETE CASCADE,
	FOREIGN KEY (artist_id) REFERENCES artist(artist_id) ON DELETE CASCADE,
    FOREIGN KEY (album_id) REFERENCES album(album_id) ON DELETE CASCADE,
	FOREIGN KEY (genre_id) REFERENCES genre(genre_id) ON DELETE CASCADE
);

select * from music;

-- 10. 노래연습장 정보 이용관련 ( )             
CREATE TABLE karaoke (                                         -- 테이블명 karaoke   
    karaoke_id BIGINT AUTO_INCREMENT PRIMARY KEY,              -- 노래연습장 id,
    karaoke_name varchar(30),			                             -- 노래연습장 브랜드명 
    karaoke_store varchar(30) NOT NULL,                        -- 점포 이름 
    karaoke_location varchar(300) NOT NULL,                    -- 점포 위치 서울 영등포구 영등포로 12-12 1층
    karaoke_lat double NOT NULL,          					-- 위도 위치 기반 
    karaoke_long double NOT NULL,            				-- 경도 위치 기반

    login_id BIGINT,
    FOREIGN KEY (login_id) REFERENCES login(login_id) ON DELETE CASCADE 
);



select count(*) from song;
select count(*) from artist;
select count(*) from album;
select count(*) from genre;
select count(*) from karaoke;



