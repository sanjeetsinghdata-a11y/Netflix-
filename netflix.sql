use TraningYa
go


SELECT * FROM netflix1


--- find the total shows ---

SELECT [type],count(*) as total_shows  FROM netflix1
GROUP BY [type]


-- Find the percentage contribution of each show type
SELECT
    [type],
    COUNT(*) AS total_shows,
    CAST(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM netflix1)
         AS DECIMAL(5,2)) AS contribution_percentage
FROM netflix1 GROUP BY [type]




use TraningYa
go

-- Q1. Display all records from the Netflix table.


SELECT *FROM netflix1

-- Q2. Find the total number of shows in the dataset.

SELECT type, COUNT(*) AS TOTAL_SHOWS FROM netflix1
WHERE TYPE='TV SHOW'
GROUP BY TYPE

-- Q3. Find the number of Movies and TV Shows separately.
select type ,count(*) as totalshows from netflix1
group by type


-- Q4. Find all shows released in 2021.

select type,release_year from netflix1
where release_year=2021
group by type,release_year

-- Q5. Display the titles of all Movies.
select type,title  from netflix1
where type='Movie'
group by type,title


-- Q6. Find shows with a rating of 'TV-MA'.

select type ,rating from netflix1
where rating  ='TV-MA'
group by type,rating


-- Q7. Find shows produced in India.

select country,type,rating from netflix1
where country='india'
group by country,type,rating

-- Q8. Find shows whose titles start with the letter 'A'.
select title from netflix1
where title like 'A%'


-- Q9. Find shows added to Netflix on a particular date.



SELECT *
FROM netflix1
WHERE CAST(date_added AS DATE) = '2021-07-01';


-- Q10. Display distinct countries present in the dataset.
select distinct country from netflix1
group by country



-- Q11. Count the number of shows for each type.


select type,COUNT(distinct show_id) as totalshows from netflix1
group by type

-- Q12. Calculate the percentage contribution of each show type
-- to the total number of records.

select type,count(*) as totalshows,cast(count(*)*100.0/(
select COUNT(*) from netflix1) as decimal(5,2))  as showscontribution
from netflix1
group by type

-- Q13. Find the top 10 countries with the most shows.

select top 10 country,type ,count( show_id) as totalshows from netflix1
group by country,type
order by totalshows desc  


-- Q14. Find the number of Movies released in each year.

select type,release_year,count(distinct show_id) as totalshows from netflix1
where type='Movie'
group by type,release_year
order by totalshows desc



-- Q15. Find the number of TV Shows released in each year.

select release_year, type,count(*) as total_Released_movie from netflix1
where type='TV Show'
group by release_year,type
order by release_year desc


-- Q16. Find the average release year of all shows.
 
	select AVG(release_year*1.0) as avgreleased_yeae from netflix1

	 

-- Q17. Find the most common content rating.

-- Q17. Find the most common content rating

SELECT TOP 1
    rating,
    COUNT(*) AS total_shows
FROM netflix1
WHERE rating IS NOT NULL
GROUP BY rating
ORDER BY COUNT(*) DESC;


-- Q18. Find the number of shows for each rating.

select rating,count(*) as totalshows from netflix1
group by rating
order by count(*) desc


-- Q19. Find countries that have more than 100 shows.
select country,COUNT(distinct show_id) as total_shows from netflix1
group by country
having COUNT(*)>100
order by total_shows desc

-- Q20. Find years in which Netflix added more than 200 shows.


SELECT
    YEAR(CAST(date_added AS DATE)) AS added_year,
    COUNT(*) AS total_shows
FROM netflix1
WHERE date_added IS NOT NULL
GROUP BY YEAR(CAST(date_added AS DATE))
HAVING COUNT(*) > 200
ORDER BY added_year;


-- Q11. Count the number of shows for each type.

select type,count(*) as total_shows from netflix1
group by  type
order by total_shows desc



-- Q12. Calculate the percentage contribution of each show type
-- to the total number of records.

select type,count(*) as total_shows , cast(count(*)*100.0/(
select count(*) from netflix1) as decimal(5,2)) as  Contribution from netflix1
group by type

-- Q13. Find the top 10 countries with the most shows.
select top 10  country, count(*) as total_shows from netflix1
group by country
order by total_shows desc
 


-- Q22. Find the number of shows added in each month.

select
year(CAST(date_added as date)) as added_year,
month(CAST(date_added as date)) as added_month,count(*) as total_added_shows from netflix1
group by month(CAST(date_added as date)) ,year(CAST(date_added as date))
order by added_year,added_month, total_added_shows 



-- Q23. Find the year with the highest number of Netflix additions.

select top 1 YEAR(cast(date_added  as date)) added_year,count(*) as highest_addition from netflix1
group by  YEAR(cast(date_added  as date)) 
order by  highest_addition desc



-- Q24. Find shows added during the last five years available in the dataset.

with Latest_year as (
		select max(year(cast(date_added as date))) as max_year
		from netflix1
		where date_added is not null
	)
	select *from netflix1
	where YEAR(cast	(date_added as date))>=(
			select max_year - 4 from Latest_year
		)
		and YEAR(cast(date_added as date))<=(
		select max_year from Latest_year)
	order by CAST(date_added as date) desc



-- Q25. Find the oldest and newest release years.
SELECT
    MIN(release_year) AS oldest_release_year,
    MAX(release_year) AS newest_release_year
FROM netflix1;

-- Q26. Find the number of years between a show's release year and its addition to Netflix.

select title, 
		release_year,
		year(cast(date_added as date)) as added_year,
		YEAR(cast(date_added as date)) -release_year as year_diff
		from netflix1
		where release_year is not null
		and date_added is not null
		order by year_diff desc



		-- Q26. Find the number of years between a show's release year and its addition to Netflix

SELECT
    title,
    release_year,
    YEAR(CAST(date_added AS DATE)) AS added_year,
    YEAR(CAST(date_added AS DATE)) - release_year AS diff_year
FROM netflix1
WHERE date_added IS NOT NULL
  AND release_year IS NOT NULL
ORDER BY diff_year DESC;

 
 

-- Q27. Find Movies with a duration greater than 120 minutes.

select type,title, duration from netflix1
where type='Movie'
and TRY_CAST(replace(duration ,'min','') as int)>=120
order by TRY_CAST(replace(duration ,'min','') as int) desc

 

-- Q28. Find TV Shows with more than five seasons.
 

SELECT
    title,
    duration
FROM netflix1
WHERE type = 'TV Show'
  AND TRY_CAST(REPLACE(duration, ' Seasons', '') AS INT) > 5
ORDER BY TRY_CAST(REPLACE(duration, ' Seasons', '') AS INT) DESC;


-- Q29. Calculate the average Movie duration in minutes.
select type,avg(TRY_cast(replace(duration ,'min','')as int)) as avgmovie_duration from netflix1
where type='Movie'
group by type


--- Q30. Find the year-over-year change in the number of shows added

WITH ct1 AS (
    SELECT
        YEAR(CAST(date_added AS DATE)) AS added_year,
        COUNT(DISTINCT show_id) AS totalshows
    FROM netflix1
    WHERE date_added IS NOT NULL
    GROUP BY YEAR(CAST(date_added AS DATE))
),
ct2 AS (
    SELECT
        *,
        LAG(totalshows) OVER (ORDER BY added_year) AS prevyear
    FROM ct1
)
SELECT
    added_year,
    totalshows,
    prevyear,
    totalshows - prevyear AS yoy_change,
         round(
        (totalshows - prevyear) * 100.0 / NULLIF(prevyear, 0),
       2
    ) AS yoy_percentage
FROM ct2
WHERE prevyear IS NOT NULL
ORDER BY added_year;


 

-- Q31. Find records where the director is missing or marked 'Not Given'.

SELECT *
FROM netflix1
WHERE director IS NULL
   OR LTRIM(RTRIM(director))='not given'

-- Q32. Find records where the country is missing or marked 'Not Given'.

SELECT *
FROM netflix1
WHERE country IS NULL
   OR LTRIM(RTRIM(country)) = 'Not Given';

-- Q33. Find records with missing ratings.


SELECT *
FROM netflix1
WHERE rating IS NULL
   OR LTRIM(RTRIM(rating)) = '';

-- Q34. Find duplicate show_id values.

SELECT *
FROM netflix1
WHERE show_id IN (
    SELECT show_id
    FROM netflix1
    GROUP BY show_id
    HAVING COUNT(*) > 1
)
ORDER BY show_id;

-- Q35. Find duplicate titles in the dataset.
 
 		select title,count(*) as total_title from netflix1
		group by title 
		having count(*)>1
		 


-- Q36. Find records where date_added is NULL.
select *from netflix1
where date_added is null
or LTRIM(LTRIM(date_added))='not given'

-- Q37. Count missing or 'Not Given' values in each relevant column.

-- Q37. Count missing or 'Not Given' values in each relevant column

SELECT
    SUM(CASE
        WHEN director IS NULL
          OR LTRIM(RTRIM(director)) = ''
          OR LTRIM(RTRIM(director)) = 'Not Given'
        THEN 1 ELSE 0
    END) AS missing_director,

    SUM(CASE
        WHEN country IS NULL
          OR LTRIM(RTRIM(country)) = ''
          OR LTRIM(RTRIM(country)) = 'Not Given'
        THEN 1 ELSE 0
    END) AS missing_country,

    SUM(CASE
        WHEN rating IS NULL
          OR LTRIM(RTRIM(rating)) = ''
          OR LTRIM(RTRIM(rating)) = 'Not Given'
        THEN 1 ELSE 0
    END) AS missing_rating,

    SUM(CASE
        WHEN date_added IS NULL
          OR LTRIM(RTRIM(date_added)) = ''
        THEN 1 ELSE 0
    END) AS missing_date_added,

    SUM(CASE
        WHEN duration IS NULL
          OR LTRIM(RTRIM(duration)) = ''
        THEN 1 ELSE 0
    END) AS missing_duration

FROM netflix1;

-- Q38. Find records where duration is missing.

select *from netflix1
where LTRIM(ltrim(duration))=''

-- Q39. Find titles that have leading or trailing spaces.

SELECT title
FROM netflix1
WHERE title <> LTRIM(RTRIM(title));

-- Q40. Find records where release_year is outside a reasonable range.

SELECT *
FROM netflix1
WHERE release_year < 1900
   OR release_year > YEAR(GETDATE())
   OR release_year IS NULL;



-- Q41. Find the top 10 directors with the most Movies and TV Shows.

-

WITH ct1 AS (
    SELECT
        director,
        COUNT(DISTINCT show_id) AS total_shows
    FROM netflix1
    WHERE director IS NOT NULL
      AND LTRIM(RTRIM(director)) <> ''
      AND UPPER(LTRIM(RTRIM(director))) <> 'NOT GIVEN'
    GROUP BY director
),
ct2 AS (
    SELECT
        director,
        total_shows,
        ROW_NUMBER() OVER (
            ORDER BY total_shows DESC
        ) AS rk
    FROM ct1
)
SELECT
    director,
    total_shows,
    rk
FROM ct2
WHERE rk <= 10
ORDER BY rk;



-- Q42. Find the top 10 countries with the most Movies.


WITH ct1 AS (
    SELECT
        country,
        COUNT(DISTINCT show_id) AS total_shows
    FROM netflix1
    WHERE type = 'Movie'
      AND country IS NOT NULL
      AND LTRIM(RTRIM(country)) <> ''
      AND LTRIM(RTRIM(country)) <> 'Not Given'
    GROUP BY country
),
ct2 AS (
    SELECT
        country,
        total_shows,
        ROW_NUMBER() OVER (
            ORDER BY total_shows DESC
        ) AS rk
    FROM ct1
)
SELECT *
FROM ct2
WHERE rk <= 10
ORDER BY rk;



-- -- Q43. Find the top 10 countries with the most TV Shows

WITH ct1 AS (
    SELECT
        country,
        COUNT(DISTINCT show_id) AS total_shows
    FROM netflix1
    WHERE type = 'TV Show'
      AND country IS NOT NULL
      AND LTRIM(RTRIM(country)) <> ''
      AND LTRIM(RTRIM(country)) <> 'Not Given'
    GROUP BY country
),
ct2 AS (
    SELECT
        country,
        total_shows,
        ROW_NUMBER() OVER (
            ORDER BY total_shows DESC
        ) AS rk
    FROM ct1
)
SELECT *
FROM ct2
WHERE rk <= 10
ORDER BY rk;

-- Q44. Find the most common content genre in listed_in.

select listed_in,COUNT(*) as total_genre from netflix1
group by  listed_in
 order by total_genre desc



-- Q44. Find the most common content genre in listed_in
 
with ct1 as (
		SELECT
        LTRIM(RTRIM(value)) AS genre
    FROM netflix1
    CROSS APPLY STRING_SPLIT(listed_in, ',')
    WHERE listed_in IS NOT NULL
),
countgenre as (
		select 
		genre ,count(*) as totalgenre 
		from ct1
		group by genre
)
select top 1 * from countgenre
order by totalgenre desc


-- Q45. Find the number of shows for each rating and type.

select distinct rating,COUNT(type) as total_shows from netflix1
group by rating
order by total_shows desc

-- Q46. Find countries where Movies outnumber TV Shows.

with ct1 as (
			select country,type,count(*) as totalshow from netflix1
			group by country,type
),
ct2 as (
			
			select * from ct1
			where type='Movie'
),
ct3 as (
		select * from ct1
		where type='TV Show'

)

select 
c2.country,
c2.totalshow,
c2.type,
c3.country,
c3.totalshow,
c3.type
from ct2 as c2
join ct3 as c3
on c2.country=c3.country
where c2.totalshow>c3.totalshow
order by c2.totalshow desc



--- by  another method using cte 

with ct1 as (
			select 
			country,
			sum(
			case when type='Movie' then 1 else 0 end) as total_movie,
			sum(case when type='TV Show' then 1 else 0 end) as total_show
			from netflix1
			where country  is not null
			and LTRIM(RTRIM(country)) <> ''
			and UPPER(ltrim(rtrim(country)))  <> 'not given'
			group by country
		)
select country,
total_movie,
total_show
from ct1
where total_movie>total_show
order by total_movie desc ,country


-- Q47. Find countries where TV Shows outnumber Movies.
with ct1 as (
			select 
			country,
			sum(
			case when type='Movie' then 1 else 0 end) as total_movie,
			sum(case when type='TV Show' then 1 else 0 end) as total_show
			from netflix1
			where country  is not null
			and LTRIM(RTRIM(country)) <> ''
			and UPPER(ltrim(rtrim(country)))  <> 'not given'
			group by country
		)
select country,
total_movie,
total_show
from ct1
where total_movie<total_show
order by total_movie desc ,country



-- Q48. Find directors who have directed more than 10 titles.

select director,COUNT(distinct title) as total_Title  from netflix1
group by director
having count(*)>=10

-- Q49. Find ratings that appear across both Movies and TV Shows.

  
SELECT DISTINCT
movie.rating,
movie.[type],
shows.rating,
shows.[type]
from netflix1 as movie
INNER JOIN netflix1 as shows
ON movie.rating=shows.rating
where movie.[type]='Movie'
and shows.[type]='TV Show'
and movie.rating is NOT NULL
ORDER BY movie.rating




 

-- Q50. Find the percentage of Movies and TV Shows for each country.




-- Q50. Find the percentage of Movies and TV Shows for each country


WITH ct1 as (

            SELECT country,
            sum(CASE 
                WHEN [type]='Movie' THEN  1
                ELSE  0
            END) as total_movie,
            sum(CASE 
                WHEN [type]='TV Show' THEN  1
                ELSE 0 
            END)as total_show,
            count(*) as total_content
            FROM  netflix1
            where country is not NULL
            and ltrim(rtrim(country))<>''
            and upper(ltrim(rtrim(country)))<>'not given'
            GROUP BY country
)
SELECT 
country,
total_movie,
total_show,
total_content,
    round(total_movie*100.0 ,2)/nullif(total_content,0) as Movie_Contribution,

    round(total_show*100.0,2) /nullif(total_content,0) as Show_Contribution
FROM ct1
ORDER by total_content DESC


-- Q51. Find shows released after the average release year.


SELECT
    title,
    release_year
FROM netflix1
WHERE release_year > (
    SELECT AVG(release_year * 1.0)
    FROM netflix1
)
ORDER BY release_year;


-- Q52. Find countries with more shows than the average number of shows per country.

SELECT country,count(show_id) as total_show from netflix1 
GROUP BY country
HAVING count(*)>(    
        SELECT avg(total_show) as avgshow FROM (
            SELECT count(show_id) as total_show FROM netflix1
            GROUP BY country
        )as x
    
)

-- Q53. Find directors who have directed more titles than the average director.

-- Q53. Find directors who have directed more titles than the average director

WITH DirectorCounts AS (
    SELECT
        director,
        COUNT(DISTINCT show_id) AS total_titles
    FROM netflix1
    WHERE director IS NOT NULL
      AND LTRIM(RTRIM(director)) <> ''
      AND UPPER(LTRIM(RTRIM(director))) <> 'NOT GIVEN'
    GROUP BY director
)
SELECT
    director,
    total_titles
FROM DirectorCounts
WHERE total_titles > (
    SELECT AVG(total_titles * 1.0)
    FROM DirectorCounts
)
ORDER BY total_titles DESC;

-- Q54. Find shows whose release year is greater than the average release year
-- of their respective type.



SELECT
    type,
    title,
    release_year
FROM netflix1 AS n
WHERE release_year > (
    SELECT AVG(release_year * 1.0)
    FROM netflix1
    WHERE type = n.type
)
ORDER BY type, release_year;


-- Q55. Find the country with the highest number of Movies.


WITH ct1 as (

            SELECT country,count(*) as total_movie FROM netflix1
            WHERE type='Movie'
            GROUP BY country
)
SELECT top 1* FROM ct1
ORDER BY total_movie DESC



-- Q56. Find the second-highest country by total number of shows.





WITH ct1 as (

        SELECT country,COUNT(show_id) as total_movie FROM netflix1
        WHERE type='Movie'
        GROUP BY country
),
ct2 as (

        SELECT *,
        row_number() OVER(ORDER BY total_movie DESC) as rk FROM ct1
)
SELECT * FROM ct2
where rk=2



-- Q57. Find the third most common rating.


with ct1 as (

        SELECT rating,count(*) as total_rating FROM netflix1
        GROUP BY rating
        
),
ct2 as (

        SELECT *,
        ROW_NUMBER() OVER(ORDER BY total_rating desc ) as rk FROM ct1
)
SELECT * FROM ct2
where rk=3







        
        
             SELECT max(total_rating) from (
            SELECT COUNT(*) as total_rating FROM netflix1
            GROUP BY rating
            )as x
    
                  where total_rating<( SELECT max(total_rating) from (
                    SELECT COUNT(*) as total_rating FROM netflix1
                    GROUP BY rating
                    )as x
        
            
            where total_rating <(

                SELECT max(total_rating) from (
                SELECT COUNT(*) as total_rating FROM netflix1
                GROUP BY rating
                )as x
            )    )  


            

SELECT rating ,count(*) as total_Rating FROM netflix1
GROUP BY rating
ORDER BY count(*)  DESC
        
         
        


-- Q58. Find directors who have directed both Movies and TV Shows.

SELECT director,[type] INTO  #temp_netflic_1 FROM netflix1
WHERE [type]='movie'


SELECT director,[type] INTO #temp_netflix FROM netflix1
WHERE [type]='TV Show'

SELECT n1.director,n1.type,n2.director,n2.[type] FROM #temp_netflic_1 as n1
JOIN #temp_netflix as n2
on n1.director=n2.director


SELECT n1.director,n1.[type],n2.[type] FROM netflix1 as n1
JOIN netflix1 as n2
on n1.director=n2.director




-- Q59. Find countries that have at least one Movie and one TV Show.


SELECT country,[type] ,count(show_id) as total_movie from netflix1
GROUP BY country,[type]
HAVING count(*)=1




-- Q60. Find shows added in the same year as their release year.

SELECT n1.[type],n1.date_added,n1.release_year from netflix1 as n1
JOIN netflix1 as n2
on n1.show_id=n2.show_id
where year(n1.date_added)=n2.release_year


SELECT * FROM netflix1
WHERE  YEAR(date_added)=release_year





-- Q61. Rank countries by the number of shows they have.

WITH  ct1 as(

            SELECT country, count(*) as total_Shows FROM netflix1
            where type='TV Show'
            GROUP BY country
            
),
ct2 as(
            SELECT * ,
            row_number() OVER( ORDER BY total_shows desc) as rk FROM ct1
)
SELECT * FROM ct2





-- Q62. Rank directors by the number of titles directed.

SELECT 
    n1.director,
    COUNT(DISTINCT n1.title) AS total_title,
    ROW_NUMBER() OVER (
        ORDER BY COUNT(DISTINCT n1.title) DESC
    ) AS rk
FROM netflix1 AS n1
WHERE NOT EXISTS (
    SELECT 1
    FROM netflix1 AS n2
    WHERE n2.director = n1.director
      AND n2.director = 'Not Given'
)
AND n1.director IS NOT NULL
GROUP BY n1.director;

 
-- Q63. Find the top three countries by show count within each type.
WITH ct1 as (

        SELECT country,[type],count(DISTINCT show_id) as total_shows FROM netflix1
        GROUP BY country,[type]
        
),
ct2 as (

        SELECT *,
        ROW_NUMBER() OVER(PARTITION BY [type] ORDER BY total_shows DESC) as rk
        FROM  ct1
)

SELECT * FROM ct2
where rk<=3


--Q64. Find the most recent show added in each year
    SELECT [type],max(date_added) as  recent_added_show FROM netflix1
        GROUP BY type

--- Q65. Calculate the running total of shows added by year.

WITH ct1 as (

        SELECT date_added,COUNT(DISTINCT show_id) as total_show FROM netflix1
        GROUP BY date_added
),
ct2 as (

        SELECT date_added,total_show,
        SUM(total_show) OVER( ORDER BY total_show ASC ROWS  BETWEEN UNBOUNDED PRECEDING and CURRENT  ROW) as running_sum_shows
        FROM ct1

)
SELECT * FROM  ct2

SELECT COUNT(DISTINCT show_id) as total_shows FROM netflix1

-- Q66. Compare the yearly number of additions with the previous year.

WITH ct1 as (

        SELECT YEAR(date_added) as added_date ,COUNT(DISTINCT show_id) as total_shows FROM  netflix1
            GROUP BY YEAR(date_added)
),
ct2 as (

        SELECT *,
        LAG(total_shows) OVER(ORDER BY added_date asc) as prevye_total_shows FROM ct1

)
SELECT *,total_shows-prevye_total_shows as change_over_year FROM ct2



-- Q67. Calculate the percentage change in yearly additions.



WITH ct1 AS (
    SELECT
        YEAR(date_added) AS added_date,
        COUNT(DISTINCT show_id) AS total_shows
    FROM netflix1
    GROUP BY YEAR(date_added)
),
ct2 AS (
    SELECT *,
        LAG(total_shows) OVER (
            ORDER BY added_date ASC
        ) AS prevye_total_shows
    FROM ct1
)
SELECT *,
    CONCAT(
        ROUND(
            (total_shows - prevye_total_shows) * 100.0 /
            NULLIF(prevye_total_shows, 0),
            2
        ),
        '%'
    ) AS YOY_change
FROM ct2;



-- Q68. Find each country's percentage contribution to all Netflix titles.

with ct1 as (

        SELECT country,count(DISTINCT title) as total_titles FROM netflix1
        GROUP BY country
),
ct2 as (

        SELECT sum(total_titles) as overall_total_titles FROM ct1

)
,
ct3 as (

        SELECT n1.country,n1.total_titles,n2.overall_total_titles,round(n1.total_titles*100.0/n2.overall_total_titles,2) as contribution FROM ct1 as n1
        CROSS JOIN ct2 as n2

)
SELECT country,total_titles,contribution FROM ct3
ORDER BY contribution ASC



-- Q69. Rank Movies by duration within each rating.

WITH ct1 as (

        SELECT  rating,type,
        try_Cast(
            REPLACE(
                duration,'min','') as int
            )as duration
        FROM  netflix1
        where type='Movie'
        GROUP BY  rating,duration,type

),
ct2 as (

        SELECT *,
        row_number() OVER(PARTITION BY rating ORDER BY duration DESC) as rk
        FROM  ct1
)
SELECT * FROM ct2




-- Q70. Find the top five release years with the most titles using a ranking function.


with ct1 as (

        SELECT release_year,count(DISTINCT title) as total_titles FROM netflix1
        GROUP BY release_year
),
ct2 as (

        SELECT *,
        row_number() OVER(ORDER BY total_titles DESC) as rk FROM ct1

)
SELECT * FROM ct2
WHERE rk<=5


-- Q71. Find the percentage contribution of Movies and TV Shows to the total catalogue.


SELECT type,count(DISTINCT show_id) as total_shows,
count(DISTINCT show_id)*100.0/(
    SELECT count(DISTINCT show_id) FROM netflix1
) as contribution
FROM  netflix1
GROUP BY type



 
-- Q72. Find the year with the largest increase in Netflix additions.

SELECT top 1
year,
total_shows,
prevYear_shows,
total_shows-prevYear_shows as increase_year_shows
FROM 
(SELECT year(date_added) as year ,count(DISTINCT show_id) as total_shows,
lag(count(DISTINCT show_id)) OVER( ORDER BY year(date_added) ASC ) as prevYear_shows
FROM netflix1
GROUP BY year(date_added)
)as x
where prevYear_shows is not NULL
ORDER BY increase_year_shows DESC


-- Q73. Find countries whose share of TV Shows is greater than their share of Movies.

-- Q73. Find countries whose share of TV Shows is greater than their share of Movies.


SELECT
    country,
    type,
    COUNT(DISTINCT show_id) AS total_shows,
    COUNT(DISTINCT show_id) * 100.0 /
    SUM(COUNT(DISTINCT show_id)) OVER(PARTITION BY country) AS cont
INTO #temp_netflix_cont
FROM netflix1
WHERE country IS NOT NULL
GROUP BY type, country;


SELECT
    t1.country,
    t1.type,
    t1.cont AS type1_contribution,
    t2.type,
    t2.cont AS type2_contribution
FROM #temp_netflix_cont AS t1
JOIN #temp_netflix_cont AS t2
    ON t1.country = t2.country
    and t1.type='Movie'
    and t2.type='TV Show'
    AND t1.cont < t2.cont;

-- Q74. Find directors whose titles span at least three different release years.

SELECT director,count(DISTINCT release_year) as year FROM  netflix1
GROUP BY director
HAVING count(DISTINCT release_year)>=3



-- Q75. Find the most common combination of ratings and content types.

SELECT top 1 type, rating,count(DISTINCT show_id) as total_show FROM netflix1
GROUP BY rating,type
ORDER BY count(*) DESC



-- Q76. Find countries whose number of titles increased for two consecutive addition years.

WITH ct1 AS (
    SELECT
        country,
        YEAR(date_added) AS added_year,
        COUNT(DISTINCT show_id) AS total_titles
    FROM netflix1
    WHERE country IS NOT NULL
      AND date_added IS NOT NULL
    GROUP BY country, YEAR(date_added)
),
ct2 AS (
    SELECT *,
        LAG(total_titles, 1) OVER(
            PARTITION BY country
            ORDER BY added_year
        ) AS prevyear_title,

        LAG(total_titles, 2) OVER(
            PARTITION BY country
            ORDER BY added_year
        ) AS prevyear_title2
    FROM ct1
)
SELECT *
FROM ct2
WHERE total_titles > prevyear_title
  AND prevyear_title > prevyear_title2;



-- Q77. Find the average number of seasons for TV Shows by country.

SELECT
    country,
    AVG(
        CAST(REPLACE(
            REPLACE(duration, ' Seasons', ''),
            ' Season', ''
        ) AS FLOAT)
    ) AS avg_seasons
FROM netflix1
WHERE type = 'TV Show'
  AND duration IS NOT NULL
  AND country IS NOT NULL
GROUP BY country
ORDER BY avg_seasons DESC;
 



-- Q78. Compare the average Movie duration across ratings.


SELECT rating,
avg(
    try_cast(
        REPLACE(
            duration,'min','') as float
            )
    ) as avg_movie
FROM netflix1
where duration is not null
GROUP BY rating
ORDER BY avg_movie DESC



-- Q79. Find the top five genres for Movies and TV Shows separately.

WITH ct1 as(

        SELECT type,listed_in, count( listed_in) as total_genre FROM netflix1
        GROUP by type,listed_in


),
ct2 as (

        SELECT *,row_number() OVER(PARTITION BY type ORDER BY total_genre desc) as rk FROM ct1
)

SELECT * FROM ct2
where rk<=5


-- Q80. Identify the most common genre for each type of content.
WITH ct1 as(

        SELECT type,listed_in, count( listed_in) as total_genre FROM netflix1
        GROUP by type,listed_in


),
ct2 as (

        SELECT *,row_number() OVER(PARTITION BY type ORDER BY total_genre desc) as rk FROM ct1
)

SELECT * FROM ct2
WHERE rk=1




-- Q81. Calculate the percentage of records with missing director information.
SELECT (
    SELECT count(*) as total_missing_director FROM netflix1
    where director = 'Not Given'
)*100.0/count(*)
as contribtution FROM netflix1 


---- both way are good to go

SELECT * FROM netflix1
-- Q81. Calculate the percentage of records with missing director information.

SELECT
    COUNT(*) AS total_records,
    COUNT(CASE WHEN  director ='Not Given' THEN 1 END) AS missing_directors,

    CAST(
        COUNT(CASE WHEN  director ='Not Given' THEN 1 END) * 100.0
        / COUNT(*) AS DECIMAL(10,2)
    ) AS missing_percentage

FROM netflix1;




-- Q82. Calculate the percentage of records with missing country information.

SELECT  count(*)as total_country,(
    SELECT count(*) as total_missing_country
FROM netflix1
WHERE country='Not Given'
)as missing_country,(
    SELECT count(*) as total_missing_country
FROM netflix1
WHERE country='Not Given'
)*100.0/count(*) as missing_country_cont
FROM netflix1


-- Q83. Find the difference between release year and Netflix addition year
-- for each show.

with ct1 as (SELECT type,year(date_added) as added_Date,release_year,year(date_added)-release_year as differecn FROM netflix1
GROUP BY type,year(date_added),release_year
)
SELECT *,
CASE 
    WHEN differecn<0 THEN  concat(abs(differecn),' Delay')
    WHEN differecn=0 THEN concat(differecn,' Same Year')
    else concat(differecn,' Year')
END
FROM ct1
ORDER BY differecn ASC



 

-- Q84. Identify countries with a high number of titles but a low number of TV Shows.

WITH ct1 AS (
    SELECT
        country,
        COUNT(DISTINCT title) AS total_titles,
        COUNT(DISTINCT CASE
            WHEN type = 'TV Show' THEN show_id
        END) AS total_tv_shows
    FROM netflix1
    WHERE country IS NOT NULL
    GROUP BY country
),
ct2 AS (
    SELECT *,
        DENSE_RANK() OVER (ORDER BY total_titles DESC) AS title_rk,
        DENSE_RANK() OVER (ORDER BY total_tv_shows ASC) AS shows_rk
    FROM ct1
)
SELECT
    country,
    total_titles,
    total_tv_shows,
    title_rk,
    shows_rk
FROM ct2
WHERE title_rk  <5
  AND shows_rk  <5
  ORDER BY title_rk, shows_rk;



-- Q85. Find the top five countries by catalogue growth in each year.

WITH ct1 as (
    SELECT year(date_added) as year,country,count(DISTINCT show_id) as total_shows_ FROM netflix1 
    GROUP BY country,year(date_added)
    
),
ct3 as (
    SELECT count(total_shows_) as total_shows FROM ct1
    
),

ct2 as (
    SELECT c1.country,c1.year,c1.total_shows_ ,c3.total_shows , c1.total_shows_*100.0/c3.total_shows as cont FROM ct1 as c1
    CROSS JOIN ct3 as c3
     
),
ct5 as (

        SELECT *,dense_rank() OVER
        (PARTITION BY country ORDER BY cont ASC) as rk FROM ct2
)
SELECT * FROM ct5
WHERE rk<=5





-- Q85. Find the top five countries by catalogue growth in each year.

WITH ct1 AS (
    SELECT
        country,
        YEAR(date_added) AS year,
        COUNT(DISTINCT show_id) AS total_shows
    FROM netflix1
    WHERE country IS NOT NULL
      AND date_added IS NOT NULL
    GROUP BY country, YEAR(date_added)
),
ct2 AS (
    SELECT *,
        DENSE_RANK() OVER (
            PARTITION BY year
            ORDER BY total_shows DESC
        ) AS rk
    FROM ct1
)
SELECT
    country,
    year,
    total_shows,
    rk
FROM ct2
WHERE rk <= 5
ORDER BY country,year, rk ASC



