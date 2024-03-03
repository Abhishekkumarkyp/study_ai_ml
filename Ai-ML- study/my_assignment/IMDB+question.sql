USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:
--Ans1. 
	SELECT table_name, table_rows
	FROM information_schema.tables
	WHERE table_schema = 'imdb';

	-- table_name			table_rows
	-- director_mapping	    3867
	-- genre	            14662
	-- movie	            7493
	-- names	            30191
	-- ratings          	8230
	-- role_mapping	        15258








-- Q2. Which columns in the movie table have null values?
-- Type your code below:
---Ans2. country,worlwide_gross_income,languages,production_company
		USE imdb;

		SELECT
		SUM(CASE WHEN title IS NULL THEN 1 ELSE 0 END) AS title_null_count,
		SUM(CASE WHEN year IS NULL THEN 1 ELSE 0 END) AS year_null_count,
		SUM(CASE WHEN date_published IS NULL THEN 1 ELSE 0 END) AS date_published_null_count,
		SUM(CASE WHEN duration IS NULL THEN 1 ELSE 0 END) AS duration_null_count,
		SUM(CASE WHEN country IS NULL THEN 1 ELSE 0 END) AS country_null_count,
		SUM(CASE WHEN worlwide_gross_income IS NULL THEN 1 ELSE 0 END) AS worlwide_gross_income_null_count,
		SUM(CASE WHEN languages IS NULL THEN 1 ELSE 0 END) AS languages_null_count,
		SUM(CASE WHEN production_company IS NULL THEN 1 ELSE 0 END) AS production_company_null_count,
		SUM(CASE WHEN id IS NULL THEN 1 ELSE 0 END) AS id_null_count
		FROM movie;

		-- title                  0
		-- year                   0
		-- date_published         0
		-- duration               0
		-- country 				  20
		-- worlwide_gross_income  3724
		-- languages              194
		-- production_company     528
		









-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	3052			|
|	2018		|	2944			|
|	2019		|	2001			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

--Ans3:
	USE imdb;

	-- Total number of movies released each year
	SELECT
		YEAR(date_published) AS release_year,
		COUNT(*) AS total_movies
	FROM
		movie
	WHERE
		date_published IS NOT NULL
	GROUP BY
		release_year
	ORDER BY
		release_year;

	-- release_year    total_movies
	-- 2017	        3052
	-- 2018	        2944
	-- 2019	        2001

	-- the second part of the question:
	-- Trend month-wise
	SELECT
		MONTH(date_published) AS release_month,
		COUNT(*) AS total_movies
	FROM
		movie
	WHERE
		date_published IS NOT NULL
	GROUP BY
	release_month
	ORDER BY
		release_month;
	-- release_month   total_movies
	-- 1				804
	-- 2				640
	-- 3				824
	-- 4				680
	-- 5				625
	-- 6				580
	-- 7				493
	-- 8				678
	-- 9				809
	-- 10				801
	-- 11				625
	-- 12				438












/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:
-- Ans4:
		SELECT count(*) As total_movies
		FROM imdb.movie
		WHERE YEAR(date_published) = 2019
		AND (country LIKE '%India%' OR country LIKE '%USA%');

		-- total_movies :1059







/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

	SELECT distinct genre FROM imdb.genre;
-- ----genre-----
	-- Drama
	-- Fantasy
	-- Thriller
	-- Comedy
	-- Horror
	-- Family
	-- Romance
	-- Adventure
	-- Action
	-- Sci-Fi
	-- Crime
	-- Mystery
	-- Others








/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:
--Ans6.
	SELECT genre, COUNT(*) AS total_genre
	FROM genre
	GROUP BY genre
	ORDER BY total_genre DESC;

	-- Drama	4285---HIGEST
	-- Comedy	2412
	-- Thriller	1484
	-- Action	1289
	-- Horror	1208
	-- Romance	906
	-- Crime	813
	-- Adventure	591
	-- Mystery	555
	-- Sci-Fi	375
	-- Fantasy	342
	-- Family	302
	-- Others	100










/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:
--Ans7.
	SELECT COUNT(*) AS movies_with_single_genre
	FROM (
		SELECT movie_id
		FROM movie_genre
		GROUP BY movie_id
		HAVING COUNT(*) = 1
	) AS single_genre_movies;











/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)

/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Ans8.
	SELECT 
	g.genre,
	AVG(m.duration) AS duration_avg
	FROM movie AS m
	JOIN genre AS g ON m.id = g.movie_id
	GROUP BY g.genre;

	-- Horror	92.7243
	-- Family	100.9669
	-- Romance	109.5342
	-- Adventure	101.8714
	-- Action	112.8829
	-- Sci-Fi	97.9413
	-- Crime	107.0517
	-- Mystery	101.8000
	-- Others	100.1600


/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
SELECT
    g.genre,
    COUNT(*) AS movie_count,
    RANK() OVER (ORDER BY COUNT(*) DESC) AS genre_rank
FROM
    movie AS m
JOIN
    genre AS g ON m.id = g.movie_id
GROUP BY
    g.genre
;
-- genre	movie_count    genre_rank
	-- Drama	    4285	1
	-- Comedy	    2412	2
	-- Thriller	    1484	3 --- ans rank 3
	-- Action	    1289	4
	-- Horror	    1208	5
	-- Romance	    906  	6
	-- Crime	    813	   	7
	-- Adventure	591		8
	-- Mystery	    555     9
	-- Sci-Fi	    375     10
	-- Fantasy	    342     11
	-- Family	    302     12
	-- Others	    100     13






/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/




-- Segment 2:




-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:

-- Ans:
	SELECT
	MIN(avg_rating) AS min_avg_rating,
	MAX(avg_rating) AS max_avg_rating,
	MIN(total_votes) AS min_total_votes,
	MAX(total_votes) AS max_total_votes,
	MIN(median_rating) AS min_median_rating,
	MAX(median_rating) AS max_median_rating
	FROM
	ratings;
	
-- +---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
-- | min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
-- +---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
-- |		1.o		|		10.0		|	       177		  |	   2000	    		 |		0	       |	8			 |
-- +---------------+-------------------+---------------------+----------------------+-----------------+-----------------+



    

/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too
--Ans:
    SELECT
    movie.title,
    ratings.avg_rating,
    RANK() OVER (ORDER BY ratings.avg_rating DESC) AS movie_rank
    FROM
    ratings
    JOIN
    movie ON ratings.movie_id = movie.id
    ORDER BY
    ratings.avg_rating DESC
    LIMIT 10;


-- Kirket	                          10.0	                        1
-- Love in Kilnerry	                  10.0	                        1
-- Gini Helida Kathe	              9.8	                        3
-- Runam	                          9.7	                        4
-- Fan	                              9.6	                        5
-- Android Kunjappan Version 5.25	  9.6	                        5
-- Yeh Suhaagraat Impossible	      9.5	                        7
-- Safe	                              9.5	                        7
-- The Brighton Miracle	              9.5	                        7
-- Shibu	                          9.4	                       10







/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have
--Ans:
    SELECT
    median_rating,
    count(*) as movie_count
    FROM
    ratings
    group by median_rating
    order by median_rating desc;

-- median_rating       movie_count
    -- 1	                94
    -- 2	                119
    -- 3	                283
    -- 4	                479
    -- 5	                985
    -- 6	                1975
    -- 7	                2257
    -- 8	                1030
    -- 9	                429
    -- 10	                346











/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:
-- Ans
    SELECT
        production_company,
        COUNT(*) AS movie_count,
        RANK() OVER (ORDER BY COUNT(*) DESC) AS prod_company_rank
    FROM
        movie
    WHERE
        id IN (SELECT movie_id FROM ratings WHERE avg_rating > 8) And production_company is not null
    GROUP BY
        production_company
    ORDER BY
        movie_count DESC
    LIMIT 1;

-- production_company    movie_count  prod_company_rank
--   Dream Warrior Pictures	  3	            1








-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Ans:

    SELECT
        g.genre,
        COUNT(*) AS movie_count
    FROM
        movie AS m
    JOIN
        genre AS g ON m.id = g.movie_id
    JOIN
        ratings AS r ON m.id = r.movie_id
    WHERE
        m.country LIKE '%USA%'
        AND YEAR(m.date_published) = 2017
        AND MONTH(m.date_published) = 3
        AND r.total_votes > 1000
    GROUP BY
        g.genre
    order by movie_count desc;



        -- Drama	    24
        -- Comedy	    9
        -- Action	    8
        -- Thriller	    8
        -- Sci-Fi	    7
        -- Crime	    6
        -- Horror	    6
        -- Mystery	    4
        -- Romance	    4
        -- Fantasy	    3
        -- Adventure	3
        -- Family	    1









-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

-- Ans
    SELECT
        m.title,
        r.avg_rating,
        g.genre
    FROM
        movie AS m
    JOIN
        ratings AS r ON m.id = r.movie_id
    JOIN
        genre AS g ON m.id = g.movie_id
    WHERE
        m.title LIKE 'The%'
        AND r.avg_rating > 8
    GROUP BY
        m.title, r.avg_rating, g.genre;

-- The Blue Elephant 2	8.8	Drama
-- The Blue Elephant 2	8.8	Horror
-- The Blue Elephant 2	8.8	Mystery
-- The Brighton Miracle	9.5	Drama
-- The Irishman	8.7	Crime
-- The Irishman	8.7	Drama
-- The Colour of Darkness	9.1	Drama
-- Theeran Adhigaaram Ondru	8.3	Action
-- Theeran Adhigaaram Ondru	8.3	Crime
-- Theeran Adhigaaram Ondru	8.3	Thriller
-- The Mystery of Godliness: The Sequel	8.5	Drama
-- The Gambinos	8.4	Crime
-- The Gambinos	8.4	Drama
-- The King and I	8.2	Drama
-- The King and I	8.2	Romance









-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

-- Ans:- total 361 movies were released between 1 April 2018 and 1 April 2019 that were given a median rating of 8.
    SELECT
    COUNT(*) AS median_8_count
FROM
    movie AS m
JOIN
    ratings AS r ON m.id = r.movie_id
WHERE
    m.date_published BETWEEN '2018-04-01' AND '2019-04-01'
    AND r.median_rating = 8;







-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:


-- Ans yes Germany got more votes, In order to compare Germany and Italy not include country including both Italy and Germany
        SELECT
        country,
        SUM(total_votes) AS total_votes
        FROM (
        SELECT
            CASE
                WHEN m.country LIKE '%Germany%' THEN 'Germany'
                WHEN m.country LIKE '%Italy%' THEN 'Italy'
            END AS country,
            r.total_votes
        FROM
            movie AS m
        JOIN
            ratings AS r ON m.id = r.movie_id
        WHERE
            (m.country LIKE '%Germany%' OR m.country LIKE '%Italy%')
            AND NOT (m.country LIKE '%Germany%' AND m.country LIKE '%Italy%')
        ) AS subquery
        GROUP BY
        country;

-- Germany	1936734
-- Italy	613535    (In order to compare Germany and Italy not include country including both Italy and Germany)








-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/




-- Segment 3:



-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

-- Ans:

    SELECT
    COUNT(*) - COUNT(name) AS name_nulls,
    COUNT(*) - COUNT(height) AS height_nulls,
    COUNT(*) - COUNT(date_of_birth) AS date_of_birth_nulls,
    COUNT(*) - COUNT(known_for_movies) AS known_for_movies_nulls
    FROM
    names;

    -- name_nulls  height_nulls    date_of_birth_nulls  known_for_movies_nulls
    --     0	    17335	       13431	             15226






/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
SELECT
    director_name,
    genre,
    movie_count
FROM (
    SELECT
        d.name AS director_name,
        g.genre,
        COUNT(DISTINCT m.id) AS movie_count,
        ROW_NUMBER() OVER (PARTITION BY g.genre ORDER BY COUNT(DISTINCT m.id) DESC) AS row_num
    FROM
        director_mapping AS dm
    JOIN
        movie AS m ON dm.movie_id = m.id
    JOIN
        names AS d ON dm.name_id = d.id
    JOIN
        ratings AS r ON m.id = r.movie_id
    JOIN
        genre AS g ON m.id = g.movie_id
    WHERE
        r.avg_rating > 8
        AND g.genre IN ('Drama', 'Comedy', 'Action')
    GROUP BY
        d.name, g.genre
    ORDER BY
        g.genre, movie_count DESC
) AS subquery
WHERE row_num <= 3
order by genre desc
;


	-- director_name	genre	movie_count
	-- James Mangold	Drama	2
	-- Marianne Elliott	Drama	2
	-- Ginatri S. Noer	Drama	1
	-- Aaron K. Carter	Comedy	1
	-- Abhinav Thakur	Comedy	1
	-- Clarence Williams IV	Comedy	1
	-- Anthony Russo	Action	2
	-- Joe Russo	Action	2
	-- James Mangold	Action	2









/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Ans:
-- Mammootty	8
-- Mohanlal	5








/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:
-- ans21
SELECT
    production_company,
    SUM(total_votes) AS vote_count,
    ROW_NUMBER() OVER (ORDER BY SUM(total_votes) DESC) AS prod_comp_rank
FROM (
    SELECT
        production_company,
        m.id AS movie_id,
        r.total_votes
    FROM
        movie AS m
    JOIN
        ratings AS r ON m.id = r.movie_id
    WHERE
        production_company IS NOT NULL
) AS subquery
GROUP BY
    production_company
ORDER BY
    vote_count DESC
LIMIT 3;
-- Marvel Studios	        2656967	            1
-- Twentieth Century Fox	2411163	            2
-- Warner Bros.	            2396057	            3









/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Ans

SELECT
    am.name AS actor_name,
    SUM(r.total_votes) AS total_votes,
    COUNT(DISTINCT m.id) AS movie_count,
    SUM(r.avg_rating * r.total_votes) / SUM(r.total_votes) AS actor_avg_rating
FROM
    role_mapping AS a
JOIN
    names AS am ON a.name_id = am.id
JOIN
    movie AS m ON m.id = a.movie_id
JOIN
    ratings AS r ON m.id = r.movie_id
WHERE
    m.country LIKE '%India%' AND
    a.category = 'actor'  -- Adjust the category value based on your schema
GROUP BY
    actor_name
HAVING
    movie_count >= 5
ORDER BY
    actor_avg_rating DESC, total_votes DESC
LIMIT 1;
-- Vijay Sethupathi	23114	5	8.41673






-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
-- Ans

SELECT
    am.name AS actor_name,
    SUM(r.total_votes) AS total_votes,
    COUNT(DISTINCT m.id) AS movie_count,
    SUM(r.avg_rating * r.total_votes) / SUM(r.total_votes) AS actor_avg_rating
FROM
    role_mapping AS a
JOIN
    names AS am ON a.name_id = am.id
JOIN
    movie AS m ON m.id = a.movie_id
JOIN
    ratings AS r ON m.id = r.movie_id
WHERE
    m.country LIKE '%India%' AND
    m.languages LIKE '%Hindi%' AND 
    a.category = 'actress'  -- Adjust the category value based on your schema
GROUP BY
    actor_name
HAVING
    movie_count >= 3
ORDER BY
    actor_avg_rating DESC, total_votes DESC
LIMIT 5;

Taapsee Pannu	18061	3	7.73692
Kriti Sanon	21967	3	7.04911
Divya Dutta	8579	3	6.88440
Shraddha Kapoor	26779	3	6.63024
Kriti Kharbanda	2549	3	4.80314







/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:
-- Ans

SELECT
    m.title,
    AVG(r.avg_rating) AS avg_rating,
    CASE
        WHEN AVG(r.avg_rating) > 8 THEN 'Superhit movies'
        WHEN AVG(r.avg_rating) BETWEEN 7 AND 8 THEN 'Hit movies'
        WHEN AVG(r.avg_rating) BETWEEN 5 AND 7 THEN 'One-time-watch movies'
        WHEN AVG(r.avg_rating) < 5 THEN 'Flop movies'
        ELSE 'Unknown'
    END AS movie_category
FROM
    movie AS m
JOIN
    genre AS g ON m.id = g.movie_id
JOIN
    ratings AS r ON m.id = r.movie_id
WHERE
    g.genre = 'Thriller'
GROUP BY
    m.title
ORDER BY
    AVG(r.avg_rating) DESC;












/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:
-- Ans

SELECT 
    g.genre,
    round(AVG(m.duration),2) AS avg_duration,
    round(SUM(m.duration),2)  AS running_total_duration,
    round(AVG(AVG(m.duration)) OVER (PARTITION BY g.genre ORDER BY MIN(m.id)),2) AS moving_avg_duration
FROM movie m
JOIN genre g ON g.movie_id = m.id
GROUP BY g.genre
ORDER BY g.genre;


-- Action	112.88	145506	112.88
-- Adventure	101.87	60206	101.87
-- Comedy	102.62	247526	102.62
-- Crime	107.05	87033	107.05
-- Drama	106.77	457529	106.77
-- Family	100.97	30492	100.97
-- Fantasy	105.14	35958	105.14
-- Horror	92.72	112011	92.72
-- Mystery	101.80	56499	101.80
-- Others	100.16	10016	100.16
-- Romance	109.53	99238	109.53
-- Sci-Fi	97.94	36728	97.94
-- Thriller	101.58	150739	101.58







-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies
-- Ans

USE imdb;

WITH RankedMovies AS (
    SELECT
        g.genre,
        m.year,
        m.title,
        m.worlwide_gross_income,
        r.avg_rating,
        ROW_NUMBER() OVER (PARTITION BY g.genre, m.year ORDER BY m.worlwide_gross_income DESC) AS row_num
    FROM genre g
    JOIN movie m ON g.movie_id = m.id
    JOIN ratings r ON m.id = r.movie_id
    WHERE g.genre IN ('Drama', 'Comedy', 'Action')
)
SELECT
    genre,
    year,
    title,
    worlwide_gross_income,
    avg_rating
FROM RankedMovies
WHERE row_num <= 5
ORDER BY genre, year, row_num;











-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:
-- Ans
WITH HitMovies AS (
    SELECT
        m.production_company,
        COUNT(*) AS movie_count
    FROM movie m
    JOIN ratings r ON m.id = r.movie_id
    WHERE r.median_rating >= 8 and production_company is not null
    GROUP BY m.production_company
),
RankedProductionHouses AS (
    SELECT
        production_company,
        movie_count,
        ROW_NUMBER() OVER (ORDER BY movie_count DESC) AS prod_comp_rank
    FROM HitMovies
)
SELECT
    production_company,
    movie_count,
    prod_comp_rank
FROM RankedProductionHouses
WHERE prod_comp_rank <= 2 ;


-- Star Cinema	7	1
-- A24	7	2





-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
-- Ans
WITH DramaActresses AS (
   SELECT
       nm.name,
        COUNT(*) AS movie_count,
        sum(r.total_votes) as total_votes,
        AVG(r.avg_rating) AS actress_avg_rating,
        ROW_NUMBER() OVER (ORDER BY COUNT(*) DESC) AS actress_rank
    FROM movie m
    JOIN role_mapping a ON m.id = a.movie_id
    JOIN ratings r ON m.id = r.movie_id
	JOIN names nm ON nm.id = a.name_id
    JOIN genre gn ON gn.movie_id= m.id
    WHERE gn.genre = 'Drama' AND r.avg_rating > 8
    GROUP BY nm.name 
)
SELECT
    name,
     total_votes,
    movie_count,
    ROUND(actress_avg_rating, 2) AS actress_avg_rating,
    actress_rank
FROM DramaActresses
GROUP BY name
ORDER BY actress_rank
LIMIT 3;


-- Andrew Garfield	384661	3	8.67	1
-- Vijay Raaz	22708	2	8.60	2
-- Shane Nigam	6749	2	8.40	3






/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:
-- Ans

WITH DirectorDetails AS (
   SELECT
    d.name_id AS director_id,
    nm.name AS director_name,
    COUNT(*) AS number_of_movies,
	AVG(m.duration) AS avg_inter_movie_days,
    AVG(r.avg_rating) AS avg_rating,
    SUM(r.total_votes) AS total_votes,
    MIN(r.avg_rating) AS min_rating,
    MAX(r.avg_rating) AS max_rating,
    SUM(m.duration) AS total_duration
FROM director_mapping d
JOIN movie m ON d.movie_id = m.id
JOIN ratings r ON m.id = r.movie_id
JOIN names nm ON nm.id = d.name_id
GROUP BY d.name_id
)
SELECT
    director_id,
    director_name,
    number_of_movies,
    ROUND(avg_inter_movie_days, 2) AS avg_inter_movie_days,
    ROUND(avg_rating, 2) AS avg_rating,
    total_votes,
    min_rating,
    max_rating,
    total_duration
FROM DirectorDetails
ORDER BY number_of_movies DESC
LIMIT 9;


-- nm2096009	Andrew Jones	5	86.40	3.02	1989	2.7	3.2	432
-- nm1777967	A.L. Vijay	5	122.60	5.42	1754	3.7	6.9	613
-- nm2691863	Justin Price	4	86.50	4.50	5343	3.0	5.8	346
-- nm0001752	Steven Soderbergh	4	100.25	6.48	171684	6.2	7.0	401
-- nm6356309	Özgür Bakar	4	93.50	3.75	1092	3.1	4.9	374
-- nm0831321	Chris Stokes	4	88.00	4.33	3664	4.0	4.6	352
-- nm0425364	Jesse V. Johnson	4	95.75	5.45	14778	4.2	6.5	383
-- nm0814469	Sion Sono	4	125.50	6.03	2972	5.4	6.4	502
-- nm0515005	Sam Liu	4	78.00	6.23	28557	5.8	6.7	312





