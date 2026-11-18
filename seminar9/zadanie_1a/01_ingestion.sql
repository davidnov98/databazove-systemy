-- Active: 1795004037386@@127.0.0.1@5432@movielens_elt
CREATE DATABASE movielens_elt;

CREATE SCHEMA IF NOT EXISTS bronze;

CREATE TABLE bronze.age_group (
    id TEXT,
    name TEXT,
    _source_file TEXT DEFAULT 'age_group.csv',
    _loaded_at TIMESTAMPTZ DEFAULT now()
);


CREATE TABLE bronze.genres (
    id TEXT,
    name TEXT,
    _source_file TEXT DEFAULT 'genres.csv',
    _loaded_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE bronze.genre_movies (
    id TEXT,
    movie_id TEXT,
    genre_id TEXT,
    _source_file TEXT DEFAULT 'genres_movies.csv',
    _loaded_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE bronze.movies (
    id TEXT,
    title TEXT,
    release_year TEXT,
    _source_file TEXT DEFAULT 'movies.csv',
    _loaded_at TIMESTAMPTZ DEFAULT now()
);
CREATE TABLE bronze.occupations (
    id TEXT,
    name TEXT,
    _source_file TEXT DEFAULT 'occupations.csv',
    _loaded_at TIMESTAMPTZ DEFAULT now()
);
CREATE TABLE bronze.ratings (
    id TEXT,
    user_id TEXT,
    movie_id TEXT,
    rating TEXT,
    rated_at TEXT,
    _source_file TEXT DEFAULT 'ratings.csv',
    _loaded_at TIMESTAMPTZ DEFAULT now()
);
CREATE TABLE bronze.users (
    id TEXT,
    age TEXT,
    gender TEXT,
    occupation_id TEXT,
    zip_code TEXT,
    _source_file TEXT DEFAULT 'users.csv',
    _loaded_at TIMESTAMPTZ DEFAULT now()
);