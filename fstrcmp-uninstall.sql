--
-- $Id: uninstall_fstrcmp.sql 168 2008-10-26 12:13:14Z  $
--

BEGIN;

SET search_path=public;

DROP FUNCTION fstrcmp(text, text, float);

DROP FUNCTION fstrcmp(text, text);

COMMIT;
