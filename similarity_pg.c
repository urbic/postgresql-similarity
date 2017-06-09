#include <postgres.h>
#include <string.h>
#include <fmgr.h>

#include "fstrcmp.h"

#ifdef PG_MODULE_MAGIC
PG_MODULE_MAGIC;
#endif

PG_FUNCTION_INFO_V1(similarity_pg);

Datum similarity_pg(PG_FUNCTION_ARGS)
{
	text *text1=PG_GETARG_TEXT_P(0);
	text *text2=PG_GETARG_TEXT_P(1);
	float8 min=PG_GETARG_FLOAT8(2);

	UErrorCode ecode;
	CHAR *wc1, *wc2;
	double ret;

	char *s1=VARDATA(text1);
	char *s2=VARDATA(text2);
	int l1=VARSIZE(text1)-VARHDRSZ;
	int l2=VARSIZE(text2)-VARHDRSZ;
	int32_t wcl1, wcl2;

	ecode=U_ZERO_ERROR;
	u_strFromUTF8(NULL, 0, &wcl1, s1, l1, &ecode);
	wc1=(CHAR *)palloc((++wcl1)*sizeof(CHAR));
	ecode=U_ZERO_ERROR;
	u_strFromUTF8(wc1, wcl1, NULL, s1, l1, &ecode);

	ecode=U_ZERO_ERROR;
	u_strFromUTF8(NULL, 0, &wcl2, s2, l2, &ecode);
	wc2=(CHAR *)palloc((++wcl2)*sizeof(CHAR));
	ecode=U_ZERO_ERROR;
	u_strFromUTF8(wc2, wcl2, NULL, s2, l2, &ecode);

	ret=fstrcmp(wc1, wcl1-1, wc2, wcl2-1, min);

	pfree(wc1);
	pfree(wc2);

	PG_RETURN_FLOAT8(ret);
}


