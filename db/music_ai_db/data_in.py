
import pandas as pd
import numpy as np
import os
from sqlalchemy import create_engine, text


song = pd.read_excel("./csv/or/20250616/single_album_date.xlsx")  # 노래 데이터
song = song.iloc[:,1:]

song['genre_main'] = song['genre_main'].str.split('|')
song = song.explode('genre_main').reset_index(drop=True)
song["genre_main"].value_counts()

# genre table
genre_extract_df = song[["genre_main"]].drop_duplicates().reset_index(drop=True).reset_index()
genre_extract_df.columns = ["new_genre_id","genre_name"]
song = song.merge(genre_extract_df, left_on="genre_main",right_on="genre_name", how="left")
song[["genre_id"]] = song[["new_genre_id"]]
song = song.drop("new_genre_id",axis=1)
genre_extract_df.columns = ["genre_id","genre_name"]
# song table 
song_extract_df = song[["song_id","song_name","lyric"]].copy()
song_extract_df.columns = ["song_id","song_name","song_lyrics"]
song_extract_df = song_extract_df.drop_duplicates().reset_index(drop=True)

# artist table
artist_extract_df = song[["artist_id","artist_name"]].copy()
artist_extract_df = artist_extract_df.drop_duplicates().reset_index(drop=True)

# album table
album_extract_df = song[["album_id","album_date"]].copy()
album_extract_df.columns = ["album_id","album_years"]
album_extract_df = album_extract_df.drop_duplicates().reset_index(drop=True)

# music table
music_extract_df = song[
    ["song_id","artist_id","album_id","genre_id"]
    ].copy().drop_duplicates().reset_index(drop=True)

# karaoke table
location_df = pd.read_excel("./csv/or/20250616/karaoke_lat_long_set_float_type.xlsx") # 노래방 데이터       
location_df = location_df.iloc[1:,:]
karaoke_df = location_df[["브랜드","지점명","주소","Latitude","Longitude"]].copy()
karaoke_df = karaoke_df.drop_duplicates().reset_index(drop=True)
karaoke_df.columns = [f"karaoke_{i}" for i in ["name","store","location","lat","long"]]
###############
# insert 
db_info = f"mysql+pymysql://root:song@localhost:3100/music_ai_cjcho"
engine = create_engine(db_info, connect_args={})
genre_extract_df.to_sql(
        "genre",
        con=engine,
        if_exists="append",
        index=False
        ) 

song_extract_df.to_sql(
        "song",
        con=engine,
        if_exists="append",
        index=False
        ) 

artist_extract_df.to_sql(
        "artist",
        con=engine,
        if_exists="append",
        index=False
        ) 

album_extract_df.to_sql(
        "album",
        con=engine,
        if_exists="append",
        index=False
        ) 

music_extract_df.to_sql(
        "music",
        con=engine,
        if_exists="append",
        index=False
        )

karaoke_df.to_sql(
        "karaoke",
        con=engine,
        if_exists="append",
        index=False
        )









