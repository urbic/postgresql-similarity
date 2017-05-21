# postgres-fstrcmp

calculate the similarity of two strings



```sql
postgres=# SELECT fstrcmp('Георгий', 'Григорий');
```
```
      fstrcmp      
-------------------
 0.666666666666667
(1 row)

```








SYNOPSIS

fstrcmp(text string1, text string2, double limit)
fstrcmp(text string1, text string2)

Inputs

	string1, string2 — strings to compare
	limit — minimum similarity of two strings
