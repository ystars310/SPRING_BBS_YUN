
import pandas as pd
import numpy as np
import os
from sqlalchemy import create_engine, text


engine = create_engine("mysql+pymysql://root:song@localhost:3100/music_ai")

song = pd.read_excel("./csv/or/20250616/single_album_date.xlsx")  # 노래 데이터
song = song.iloc[:,1:]
song.columns  # 데이터 컬럼 확인

# db 연결 engine 
db_info = f"mysql+pymysql://root:song@localhost:3100/music_ai_1"
engine = create_engine(db_info, connect_args={})

# db테이블 목록 확인  show tables
with engine.connect() as con:
    res=con.execute(text("show tables"))
    table = res.fetchall()

# 데이터 중 길이가 긴것이 있는지 체크하기 
long_names = song['artist_name'][song['artist_name'].str.len() > 100]
print(long_names)

# 중복 제거 ( 유니크해야 하므로 제거 )
song=song[["artist_name","artist_id"]].drop_duplicates()
song.to_sql
# 아티스트 이름 ( 가수 이름 ) 
pd.DataFrame({
    "artist_id":song.artist_id.unique(),
    "artist_name":song.artist_name.unique()}  #DB 컬럼 :song.데이터 컬럼  
    ).to_sql(
        "artist",                                       # 테이블 이름
        con=engine,
        if_exists="append",
        index=False
    )
print(song.columns)

# 데이터 중 길이가 긴것이 있는지 체크하기 
long_names = song['song_name'][song['song_name'].str.len() > 100]
print(long_names)

# 노래 링크,이름,가사 한번에 넣기 -- O
pd.DataFrame({
    "song_id":song.song_id,
    "song_name": song.song_name,
    "song_lyrics":song.lyric}  #DB 컬럼 :song.데이터 컬럼 
    ).to_sql(
        "song",                           # 테이블 이름 
        con=engine,
        if_exists="append",
        index=False
   )
print(song.columns)

# 앨범 발매일,링크 한번에 넣기 -- O
pd.DataFrame({
    "album_id":song.album_id,         # -- 중복이 될수 있지  중복있음 
    "album_years":song.album_date}  # DB 컬럼 :song.데이터 컬럼  
    ).to_sql(
        "album",                        # 테이블 이름 
        con=engine,
        if_exists="append",
        index=False
    )
print(song.columns)


genres = set()
for item in song["genre_main"].unique():
    genres.update(item.split('|'))
genre_list = sorted(genres)

# 중복 제거 ( 유니크해야 하므로 제거 )
song=song[["genre_id","genre_main"]].drop_duplicates()
song.to_sql

print(song[["genre_id", "genre_main"]].isnull().sum())
pd.DataFrame({
    "genre_id":song.genre_id.unique(),
    "genre_name":song.genre_main.unique()}  #DB 컬럼 :song.데이터 컬럼 
    ).to_sql(
        "genre",                           # 테이블 이름 
        con=engine,
        if_exists="append",
        index=False
   )
print(song.columns)









