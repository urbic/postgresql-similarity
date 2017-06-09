-- complain if script is sourced in psql, rather than via CREATE EXTENSION
\echo Use "CREATE EXTENSION similarity" to load this file. \quit

CREATE OR REPLACE FUNCTION similarity(text, text, float)
RETURNS float
AS 'MODULE_PATHNAME', 'similarity_pg'
LANGUAGE C STRICT IMMUTABLE;

COMMENT ON FUNCTION similarity(text, text, float) IS
$$Calculate the similarity of two strings $1 and $2. A value of 0 means that
the strings are entirely different. A value of 1 means that the strings are
identical. Everything else lies between 0 and 1 and describes the amount of
similarity between the strings. Argument $3 that gives the minimum similarity
the two strings must satisfy. "similarity" stops analyzing the string as soon as
the result drops below the given limit, in which case the result will be
invalid but lower than the given $3. You can use this to speed up the common
case of searching for the most similar string from a set by specifing the
maximum similarity found so far.$$;

CREATE OR REPLACE FUNCTION similarity(text, text)
RETURNS float
AS $$SELECT similarity($1, $2, 0)$$
LANGUAGE SQL IMMUTABLE;

COMMENT ON FUNCTION similarity(text, text) IS
$$The same as similarity($1, $2, 0).$$;
