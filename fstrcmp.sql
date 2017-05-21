BEGIN;

SET search_path=public;

CREATE OR REPLACE FUNCTION fstrcmp(text, text, float)
RETURNS float
AS '$libdir/fstrcmp', 'fstrcmp_pg'
LANGUAGE C STRICT IMMUTABLE;

COMMENT ON FUNCTION fstrcmp(text, text, float) IS
$$Calculate the similarity of two strings $1 and $2. A value of 0 means that
the strings are entirely different. A value of 1 means that the strings are
identical. Everything else lies between 0 and 1 and describes the amount of
similarity between the strings. Argument $3 that gives the minimum similarity
the two strings must satisfy. "fstrcmp" stops analyzing the string as soon as
the result drops below the given limit, in which case the result will be
invalid but lower than the given $3. You can use this to speed up the common
case of searching for the most similar string from a set by specifing the
maximum similarity found so far.$$;

CREATE OR REPLACE FUNCTION fstrcmp(text, text)
RETURNS float
AS
$$
SELECT fstrcmp($1, $2, 0)
$$
LANGUAGE SQL IMMUTABLE;

COMMENT ON FUNCTION fstrcmp(text, text) IS
$$The same as fstrcmp($1, $2, 0).$$;

COMMIT;
