CREATE TYPE sys.DATETIME2;

CREATE OR REPLACE FUNCTION sys.datetime2in(cstring)
RETURNS sys.DATETIME2
AS 'babelfishpg_common', 'datetime2_in'
LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

CREATE OR REPLACE FUNCTION sys.datetime2out(sys.DATETIME2)
RETURNS cstring
AS 'timestamp_out'
LANGUAGE internal IMMUTABLE STRICT PARALLEL SAFE;

CREATE OR REPLACE FUNCTION sys.datetime2recv(internal)
RETURNS sys.DATETIME2
AS 'timestamp_recv'
LANGUAGE internal IMMUTABLE STRICT PARALLEL SAFE;

CREATE OR REPLACE FUNCTION sys.datetime2send(sys.DATETIME2)
RETURNS bytea
AS 'timestamp_send'
LANGUAGE internal IMMUTABLE STRICT PARALLEL SAFE;

CREATE OR REPLACE FUNCTION sys.datetime2typmodin(cstring[])
RETURNS integer
AS 'timestamptypmodin'
LANGUAGE internal IMMUTABLE STRICT PARALLEL SAFE;

CREATE OR REPLACE FUNCTION sys.datetime2typmodout(integer)
RETURNS cstring
AS 'timestamptypmodout'
LANGUAGE internal IMMUTABLE STRICT PARALLEL SAFE;

CREATE TYPE sys.DATETIME2 (
	INPUT          = sys.datetime2in,
	OUTPUT         = sys.datetime2out,
	RECEIVE        = sys.datetime2recv,
	SEND           = sys.datetime2send,
    TYPMOD_IN      = sys.datetime2typmodin,
    TYPMOD_OUT     = sys.datetime2typmodout,
	INTERNALLENGTH = 8,
	ALIGNMENT      = 'double',
	STORAGE        = 'plain',
	CATEGORY       = 'D',
	PREFERRED      = false,
	COLLATABLE     = false,
    DEFAULT        = '1900-01-01 00:00:00',
    PASSEDBYVALUE
);

CREATE FUNCTION sys.datetime2eq(sys.DATETIME2, sys.DATETIME2)
RETURNS bool
AS 'timestamp_eq'
LANGUAGE internal IMMUTABLE STRICT PARALLEL SAFE;

CREATE FUNCTION sys.datetime2ne(sys.DATETIME2, sys.DATETIME2)
RETURNS bool
AS 'timestamp_ne'
LANGUAGE internal IMMUTABLE STRICT PARALLEL SAFE;

CREATE FUNCTION sys.datetime2lt(sys.DATETIME2, sys.DATETIME2)
RETURNS bool
AS 'timestamp_lt'
LANGUAGE internal IMMUTABLE STRICT PARALLEL SAFE;

CREATE FUNCTION sys.datetime2le(sys.DATETIME2, sys.DATETIME2)
RETURNS bool
AS 'timestamp_le'
LANGUAGE internal IMMUTABLE STRICT PARALLEL SAFE;

CREATE FUNCTION sys.datetime2gt(sys.DATETIME2, sys.DATETIME2)
RETURNS bool
AS 'timestamp_gt'
LANGUAGE internal IMMUTABLE STRICT PARALLEL SAFE;

CREATE FUNCTION sys.datetime2ge(sys.DATETIME2, sys.DATETIME2)
RETURNS bool
AS 'timestamp_ge'
LANGUAGE internal IMMUTABLE STRICT PARALLEL SAFE;

CREATE OPERATOR sys.= (
    LEFTARG    = sys.DATETIME2,
    RIGHTARG   = sys.DATETIME2,
    COMMUTATOR = =,
    NEGATOR    = <>,
    PROCEDURE  = sys.datetime2eq,
    RESTRICT   = eqsel,
    JOIN       = eqjoinsel,
    MERGES
);

CREATE OPERATOR sys.<> (
    LEFTARG    = sys.DATETIME2,
    RIGHTARG   = sys.DATETIME2,
    NEGATOR    = =,
    COMMUTATOR = <>,
    PROCEDURE  = sys.datetime2ne,
    RESTRICT   = neqsel,
    JOIN       = neqjoinsel
);

CREATE OPERATOR sys.< (
    LEFTARG    = sys.DATETIME2,
    RIGHTARG   = sys.DATETIME2,
    NEGATOR    = >=,
    COMMUTATOR = >,
    PROCEDURE  = sys.datetime2lt,
    RESTRICT   = scalarltsel,
    JOIN       = scalarltjoinsel
);

CREATE OPERATOR sys.<= (
    LEFTARG    = sys.DATETIME2,
    RIGHTARG   = sys.DATETIME2,
    NEGATOR    = >,
    COMMUTATOR = >=,
    PROCEDURE  = sys.datetime2le,
    RESTRICT   = scalarlesel,
    JOIN       = scalarlejoinsel
);

CREATE OPERATOR sys.> (
    LEFTARG    = sys.DATETIME2,
    RIGHTARG   = sys.DATETIME2,
    NEGATOR    = <=,
    COMMUTATOR = <,
    PROCEDURE  = sys.datetime2gt,
    RESTRICT   = scalargtsel,
    JOIN       = scalargtjoinsel
);

CREATE OPERATOR sys.>= (
    LEFTARG    = sys.DATETIME2,
    RIGHTARG   = sys.DATETIME2,
    NEGATOR    = <,
    COMMUTATOR = <=,
    PROCEDURE  = sys.datetime2ge,
    RESTRICT   = scalargesel,
    JOIN       = scalargejoinsel
);

CREATE FUNCTION  datetime2_cmp(sys.DATETIME2, sys.DATETIME2)
RETURNS INT4
AS 'timestamp_cmp'
LANGUAGE internal IMMUTABLE STRICT PARALLEL SAFE;

CREATE FUNCTION  datetime2_hash(sys.DATETIME2)
RETURNS INT4
AS 'timestamp_hash'
LANGUAGE internal IMMUTABLE STRICT PARALLEL SAFE;

CREATE OPERATOR CLASS sys.datetime2_ops
DEFAULT FOR TYPE sys.DATETIME2 USING btree AS
    OPERATOR    1   <  (sys.DATETIME2, sys.DATETIME2),
    OPERATOR    2   <= (sys.DATETIME2, sys.DATETIME2),
    OPERATOR    3   =  (sys.DATETIME2, sys.DATETIME2),
    OPERATOR    4   >= (sys.DATETIME2, sys.DATETIME2),
    OPERATOR    5   >  (sys.DATETIME2, sys.DATETIME2),
    FUNCTION    1   datetime2_cmp(sys.DATETIME2, sys.DATETIME2);

CREATE OPERATOR CLASS sys.datetime2_ops
DEFAULT FOR TYPE sys.DATETIME2 USING hash AS
    OPERATOR    1   =  (sys.DATETIME2, sys.DATETIME2),
    FUNCTION    1   datetime2_hash(sys.DATETIME2);

-- cast TO datetime2
CREATE OR REPLACE FUNCTION sys.timestamp2datetime2(TIMESTAMP)
RETURNS DATETIME2
AS 'babelfishpg_common', 'timestamp_datetime2'
LANGUAGE C VOLATILE STRICT PARALLEL SAFE;

CREATE CAST (TIMESTAMP AS DATETIME2)
WITH FUNCTION sys.timestamp2datetime2(TIMESTAMP) AS ASSIGNMENT;
-- CREATE CAST (TIMESTAMP AS DATETIME2)
-- WITHOUT FUNCTION AS IMPLICIT;

CREATE OR REPLACE FUNCTION sys.timestamptz2datetime2(TIMESTAMPTZ)
RETURNS DATETIME2
AS 'babelfishpg_common', 'timestamptz_datetime2'
LANGUAGE C VOLATILE STRICT PARALLEL SAFE;

CREATE CAST (TIMESTAMPTZ AS DATETIME2)
WITH FUNCTION sys.timestamptz2datetime2 (TIMESTAMPTZ) AS ASSIGNMENT;


CREATE OR REPLACE FUNCTION sys.date2datetime2(DATE)
RETURNS DATETIME2
AS 'babelfishpg_common', 'date_datetime2'
LANGUAGE C VOLATILE STRICT PARALLEL SAFE;

CREATE CAST (DATE AS DATETIME2)
WITH FUNCTION sys.date2datetime2 (DATE) AS IMPLICIT;


CREATE OR REPLACE FUNCTION sys.time2datetime2(TIME)
RETURNS DATETIME2
AS 'babelfishpg_common', 'time_datetime2'
LANGUAGE C VOLATILE STRICT PARALLEL SAFE;

CREATE CAST (TIME AS DATETIME2)
WITH FUNCTION sys.time2datetime2 (TIME) AS IMPLICIT;


CREATE CAST (DATETIME AS DATETIME2)
WITHOUT FUNCTION AS IMPLICIT;


-- BABEL-1465 CAST from VARCHAR/NVARCHAR/CHAR/NCHAR to datetime2 is VOLATILE
CREATE OR REPLACE FUNCTION sys.varchar2datetime2(sys.VARCHAR)
RETURNS DATETIME2
AS 'babelfishpg_common', 'varchar_datetime2'
LANGUAGE C VOLATILE STRICT PARALLEL SAFE;

CREATE CAST (sys.VARCHAR AS DATETIME2)
WITH FUNCTION sys.varchar2datetime2 (sys.VARCHAR) AS ASSIGNMENT;

CREATE OR REPLACE FUNCTION sys.varchar2datetime2(pg_catalog.VARCHAR)
RETURNS DATETIME2
AS 'babelfishpg_common', 'varchar_datetime2'
LANGUAGE C VOLATILE STRICT PARALLEL SAFE;

CREATE CAST (pg_catalog.VARCHAR AS DATETIME2)
WITH FUNCTION sys.varchar2datetime2 (pg_catalog.VARCHAR) AS ASSIGNMENT;

CREATE OR REPLACE FUNCTION sys.char2datetime2(CHAR)
RETURNS DATETIME2
AS 'babelfishpg_common', 'char_datetime2'
LANGUAGE C VOLATILE STRICT PARALLEL SAFE;

CREATE CAST (CHAR AS DATETIME2)
WITH FUNCTION sys.char2datetime2 (CHAR) AS ASSIGNMENT;

CREATE OR REPLACE FUNCTION sys.bpchar2datetime2(sys.BPCHAR)
RETURNS sys.DATETIME2
AS 'babelfishpg_common', 'char_datetime2'
LANGUAGE C VOLATILE STRICT PARALLEL SAFE;

CREATE CAST (sys.BPCHAR AS sys.DATETIME2)
WITH FUNCTION sys.bpchar2datetime2 (sys.BPCHAR) AS ASSIGNMENT;

--  cast FROM datetime2
CREATE CAST (DATETIME2 AS TIMESTAMP)
WITHOUT FUNCTION AS IMPLICIT;


CREATE OR REPLACE FUNCTION sys.datetime22datetime(DATETIME2)
RETURNS DATETIME
AS 'babelfishpg_common', 'timestamp_datetime'
LANGUAGE C VOLATILE STRICT PARALLEL SAFE;

CREATE CAST (DATETIME2 AS DATETIME)
WITH FUNCTION sys.datetime22datetime(DATETIME2) AS ASSIGNMENT;


CREATE OR REPLACE FUNCTION sys.datetime22timestamptz(DATETIME2)
RETURNS TIMESTAMPTZ
AS 'timestamp_timestamptz'
LANGUAGE internal VOLATILE STRICT PARALLEL SAFE;

CREATE CAST (DATETIME2 AS TIMESTAMPTZ)
WITH FUNCTION sys.datetime22timestamptz (DATETIME2) AS IMPLICIT;


CREATE OR REPLACE FUNCTION sys.datetime22date(DATETIME2)
RETURNS DATE
AS 'timestamp_date'
LANGUAGE internal VOLATILE STRICT PARALLEL SAFE;

CREATE CAST (DATETIME2 AS DATE)
WITH FUNCTION sys.datetime22date (DATETIME2) AS ASSIGNMENT;


CREATE OR REPLACE FUNCTION sys.datetime22time(DATETIME2)
RETURNS TIME
AS 'timestamp_time'
LANGUAGE internal VOLATILE STRICT PARALLEL SAFE;

CREATE CAST (DATETIME2 AS TIME)
WITH FUNCTION sys.datetime22time (DATETIME2) AS ASSIGNMENT;


CREATE FUNCTION sys.datetime2scale(sys.DATETIME2, INT4)
RETURNS sys.DATETIME2
AS 'babelfishpg_common', 'datetime2_scale'
LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

CREATE CAST (sys.DATETIME2 AS sys.DATETIME2)
WITH FUNCTION datetime2scale (sys.DATETIME2, INT4) AS ASSIGNMENT;


-- BABEL-1465 CAST from datetime2 to VARCHAR/NVARCHAR/CHAR/NCHAR is VOLATILE
CREATE OR REPLACE FUNCTION sys.datetime22sysvarchar(DATETIME2)
RETURNS sys.VARCHAR
AS 'babelfishpg_common', 'datetime2_varchar'
LANGUAGE C VOLATILE STRICT PARALLEL SAFE;

CREATE CAST (DATETIME2 AS sys.VARCHAR)
WITH FUNCTION sys.datetime22sysvarchar (DATETIME2) AS ASSIGNMENT;

CREATE OR REPLACE FUNCTION sys.datetime22varchar(DATETIME2)
RETURNS pg_catalog.VARCHAR
AS 'babelfishpg_common', 'datetime2_varchar'
LANGUAGE C VOLATILE STRICT PARALLEL SAFE;

CREATE CAST (DATETIME2 AS pg_catalog.VARCHAR)
WITH FUNCTION sys.datetime22varchar (DATETIME2) AS ASSIGNMENT;

CREATE OR REPLACE FUNCTION sys.datetime22char(DATETIME2)
RETURNS CHAR
AS 'babelfishpg_common', 'datetime2_char'
LANGUAGE C VOLATILE STRICT PARALLEL SAFE;

CREATE CAST (DATETIME2 AS CHAR)
WITH FUNCTION sys.datetime22char (DATETIME2) AS ASSIGNMENT;

CREATE OR REPLACE FUNCTION sys.datetime22bpchar(sys.DATETIME2)
RETURNS sys.BPCHAR
AS 'babelfishpg_common', 'datetime2_char'
LANGUAGE C VOLATILE STRICT PARALLEL SAFE;

CREATE CAST (sys.DATETIME2 AS sys.BPCHAR)
WITH FUNCTION sys.datetime22bpchar (sys.DATETIME2) AS ASSIGNMENT;
