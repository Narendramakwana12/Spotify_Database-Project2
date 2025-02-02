-- Advanced SQL Project: Spotify Database

-- create table
DROP TABLE IF EXISTS spotify;
CREATE TABLE spotify (
    artist VARCHAR(255),
    track VARCHAR(255),
    album VARCHAR(255),
    album_type VARCHAR(50),
    danceability FLOAT,
    energy FLOAT,
    loudness FLOAT,
    speechiness FLOAT,
    acousticness FLOAT,
    instrumentalness FLOAT,
    liveness FLOAT,
    valence FLOAT,
    tempo FLOAT,
    duration_min FLOAT,
    title VARCHAR(255),
    channel VARCHAR(255),
    views FLOAT,
    likes BIGINT,
    comments BIGINT,
    licensed BOOLEAN,
    official_video BOOLEAN,
    stream BIGINT,
    energy_liveness FLOAT,
    most_played_on VARCHAR(50)
);

SELECT COUNT(*) FROM spotify

SELECT COUNT(DISTINCT artist) FROM spotify

SELECT MAX(duration_min)  FROM spotify
SELECT MIN(duration_min)  FROM spotify

DELETE FROM spotify
WHERE duration_min=0 


--Q1.Retrieve the names of all tracks that have more than 1 billion streams?

SELECT * FROM spotify
WHERE stream>1000000000 


--Q2.List all albums along with their respective artists?

SELECT DISTINCT album,artist FROM spotify
ORDER BY 1

--Q3.Get the total number of comments for tracks where licensed = TRUE?

SELECT SUM(comments) FROM spotify
WHERE LICENSED='true'

--Q4.Find all tracks that belong to the album type single?

SELECT * FROM spotify
WHERE album_type='single'


--Q5.Count the total number of tracks by each artist?

SELECT artist , COUNT(*) as total
FROM spotify
GROUP BY 1
ORDER BY 2 

--
SELECT * FROM spotify

--Q6.Calculate the average danceability of tracks in each album?

SELECT album,track,AVG(danceability) 
FROM spotify
GROUP BY 1,2
ORDER BY 3 DESC

--Q7.Find the top 5 tracks with the highest energy values?

SELECT track,MAX(energy)
FROM spotify
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5


--Q8.List all tracks along with their views and likes where official_video = TRUE?

SELECT track,SUM(views),SUM(likes)
FROM spotify
WHERE official_video = 'true'
GROUP BY 1
ORDER BY 2 DESC

--Q9.For each album, calculate the total views of all associated tracks?

SELECT album,track,SUM(views) FROM spotify
GROUP BY 1,2
ORDER BY 3 DESC

--Q10.Retrieve the track names that have been streamed on Spotify more than YouTube?

SELECT * FROM(
SELECT track,
 COALESCE(SUM(CASE WHEN most_played_on='Spotify' THEN stream END),0) as streamed_on_Spotify,
 COALESCE(SUM(CASE WHEN most_played_on='Youtube' THEN stream END),0) as streamed_on_Youtube
FROM spotify
GROUP BY track
) AS t1
WHERE streamed_on_Spotify > streamed_on_Youtube
AND streamed_on_Youtube <> 0


--
SELECT * FROM spotify

--Q11.Find the top 3 most-viewed tracks for each artist using window functions?
WITH ranking_artist
AS(
SELECT artist,track,SUM(views)
, DENSE_RANK() OVER(PARTITION BY artist  ORDER BY SUM(views) DESC) as rank
FROM spotify
GROUP BY 1,2
)
SELECT * FROM ranking_artist
WHERE rank<=3


--Q12.Write a query to find tracks where the liveness score is above the average?

SELECT AVG(liveness)
FROM spotify

SELECT * FROM spotify
WHERE liveness> (SELECT AVG(liveness)
FROM spotify)


--Q13.Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album?

WITH diff
AS(
SELECT album,MAX(energy) as highest,
MIN(energy) as lowest
FROM spotify
GROUP BY 1)
SELECT album, highest-lowest as difference FROM diff
ORDER BY 2 DESC