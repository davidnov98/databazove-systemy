
CREATE SCHEMA IF NOT EXISTS gold;

DROP TABLE IF EXISTS gold.fact_rating CASCADE;
DROP TABLE IF EXISTS gold.dim_user CASCADE;
DROP TABLE IF EXISTS gold.dim_movies CASCADE;
DROP TABLE IF EXISTS gold.dim_date CASCADE;
DROP TABLE IF EXISTS gold.dim_time CASCADE;

CREATE TABLE gold.dim_time (
    time_id INT PRIMARY KEY,
    hour INT NOT NULL,
    minute INT NOT NULL,
    second INT NOT NULL,
    time_of_day VARCHAR(20)
);

CREATE TABLE gold.dim_date (
    date_id INT PRIMARY KEY,
    full_date DATE NOT NULL,
    year INT NOT NULL,
    month INT NOT NULL,
    day INT NOT NULL,
    quarter INT NOT NULL,
    day_of_week INT NOT NULL,
    day_name VARCHAR(15),
    month_name VARCHAR(15)
);

CREATE TABLE gold.dim_user (
    user_id INT PRIMARY KEY,
    gender CHAR(1) NOT NULL CHECK (gender IN ('M', 'F')),
    zip_code VARCHAR(10),
    age_group VARCHAR(20) NOT NULL,
    occupation VARCHAR(50) NOT NULL
);

CREATE TABLE gold.dim_movies (
    movie_id INT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    release_year INT,
    genres TEXT
);

CREATE TABLE gold.fact_rating (
    rating_id INT PRIMARY KEY,
    user_id INT REFERENCES gold.dim_user(user_id),
    movie_id INT REFERENCES gold.dim_movies(movie_id),
    date_id INT REFERENCES gold.dim_date(date_id),
    time_id INT REFERENCES gold.dim_time(time_id),
    rating INT NOT NULL
);

CREATE INDEX ON gold.fact_rating(user_id);
CREATE INDEX ON gold.fact_rating(movie_id);
CREATE INDEX ON gold.fact_rating(date_id);
CREATE INDEX ON gold.fact_rating(time_id);

INSERT INTO gold.dim_user (
    user_id, gender, zip_code, age_group, occupation
)
SELECT
    u.user_id,
    u.gender,
    u.zip_code,
    COALESCE(a.name, 'unknown'),
    COALESCE(o.name, 'unknown')
FROM silver.stg_users u
LEFT JOIN silver.stg_age_group a
    ON a.age_group_id = u.age
LEFT JOIN silver.stg_occupations o
    ON o.occupation_id = u.occupation_id
ORDER BY u.user_id;

INSERT INTO gold.dim_movies (
    movie_id, title, release_year, genres
)
SELECT
    m.movie_id,
    m.title,
    m.release_year,
    COALESCE(
        STRING_AGG(DISTINCT g.name, ', ' ORDER BY g.name),
        'Unknown'
    )
FROM silver.stg_movies m
LEFT JOIN silver.stg_genre_movies gm
    ON gm.movie_id = m.movie_id
LEFT JOIN silver.stg_genres g
    ON g.genre_id = gm.genre_id
GROUP BY m.movie_id, m.title, m.release_year
ORDER BY m.movie_id;

INSERT INTO gold.dim_date (
    date_id, full_date, year, month, day,
    quarter, day_of_week, day_name, month_name
)
SELECT DISTINCT
    TO_CHAR(r.rated_at, 'YYYYMMDD')::INT,
    r.rated_at::DATE,
    EXTRACT(YEAR FROM r.rated_at)::INT,
    EXTRACT(MONTH FROM r.rated_at)::INT,
    EXTRACT(DAY FROM r.rated_at)::INT,
    EXTRACT(QUARTER FROM r.rated_at)::INT,
    EXTRACT(ISODOW FROM r.rated_at)::INT,
    TRIM(TO_CHAR(r.rated_at, 'Day')),
    TRIM(TO_CHAR(r.rated_at, 'Month'))
FROM silver.stg_ratings r
WHERE r.rated_at IS NOT NULL
ORDER BY 1;

INSERT INTO gold.dim_time (
    time_id, hour, minute, second, time_of_day
)
SELECT DISTINCT
    TO_CHAR(r.rated_at, 'HH24MISS')::INT,
    EXTRACT(HOUR FROM r.rated_at)::INT,
    EXTRACT(MINUTE FROM r.rated_at)::INT,
    EXTRACT(SECOND FROM r.rated_at)::INT,
    CASE
        WHEN EXTRACT(HOUR FROM r.rated_at) < 6 THEN 'Night'
        WHEN EXTRACT(HOUR FROM r.rated_at) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM r.rated_at) < 18 THEN 'Afternoon'
        ELSE 'Evening'
    END
FROM silver.stg_ratings r
WHERE r.rated_at IS NOT NULL
ORDER BY 1;

INSERT INTO gold.fact_rating (
    rating_id, user_id, movie_id, date_id, time_id, rating
)
SELECT
    r.rating_id,
    r.user_id,
    r.movie_id,
    TO_CHAR(r.rated_at, 'YYYYMMDD')::INT,
    TO_CHAR(r.rated_at, 'HH24MISS')::INT,
    r.rating
FROM silver.stg_ratings r
INNER JOIN gold.dim_user u
    ON u.user_id = r.user_id
INNER JOIN gold.dim_movies m
    ON m.movie_id = r.movie_id
INNER JOIN gold.dim_date d
    ON d.date_id = TO_CHAR(r.rated_at, 'YYYYMMDD')::INT
INNER JOIN gold.dim_time t
    ON t.time_id = TO_CHAR(r.rated_at, 'HH24MISS')::INT
WHERE r.rated_at IS NOT NULL
ORDER BY r.rating_id;
