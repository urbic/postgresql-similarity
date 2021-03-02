# postgresql-similarity

This is the PostgreSQL extension package which provides functions that
calculate similarity between two strings.

[![License](https://img.shields.io/badge/license-GPL--2.0-blue.svg)](LICENSE)
[![Build Status](https://secure.travis-ci.org/urbic/postgresql-similarity.png)](http://travis-ci.org/urbic/postgresql-similarity)

## Synopsis

### `similarity(text string1, text string2, float limit)`

* _`string1`_, _`string2`_ — strings to compare
* _`limit`_ — minimum similarity of two strings

Calculate similarity of two strings _`string1`_ and _`string2`_. A value of
0 means that the strings are entirely different. A value of 1 means that the
strings are identical. Everything else lies between 0 and 1 and describes the
amount of similarity between the strings. Argument _`limit`_ that gives the
minimum similarity the two strings must satisfy. `similarity` stops analyzing
the string as soon as the result drops below the given limit, in which case the
result will be invalid but lower than the given _`limit`_. You can use this to
speed up the common case of searching for the most similar string from a set by
specifing the maximum similarity found so far.

### `similarity(text string1, text string2)`

* _`string1`_, _`string2`_ — strings to compare

The same as `similarity(string1, string2, 0)`.

## Installation

### Build and install the extension package from source tarball

To install **postgresql-similarity** extension type the following commands as
root (assuming that X.X is the version of a package):
```bash
tar -xvf postgresql-similarity-X.X.tar.xz
cd postgresql-similarity-X.X
make && make install
```

### Install pre-built binary packages

Pre-built binary packages for **openSUSE**, **Fedora**, **Mageia**, **RHEL**,
**CentOS**, **Debian** and **Ubuntu** are available at [openSUSE Build
Service](https://software.opensuse.org/download.html?project=home%3Aurbic&package=postgresql-similarity).

### Install the extension into database

To install the extension into database _`dbname`_ type the following commans as
root:
```bash
su postgres -c 'psql dbname -c "CREATE EXTENSION similarity"'
```

Test the extension:
```bash
psql dbname -c "SELECT similarity('similarity', 'distinction')"
```
```
    similarity     
-------------------
 0.285714285714286
(1 row)
```

To uninstall the extension type:
```bash
su postgres -c 'psql dbname -c "DROP EXTENSION similarity"'
```

## See also

The basic algorithm is described in: [“An O(ND) Difference Algorithm and its
Variations”](http://www.xmailserver.org/diff2.pdf), Eugene Myers, Algorithmica
Vol. 1 No. 2, 1986, pp. 251—266; see especially section 4.2, which describes
the variation used below.

The basic algorithm was independently discovered as described in: [“Algorithms
for Approximate String
Matching”](http://www.sciencedirect.com/science/article/pii/S0019995885800462/pdf?md5=c7adddbc9e64e67d7c4d47973b2bda8f&pid=1-s2.0-S0019995885800462-main.pdf),
E. Ukkonen, Information and Control Vol. 64, 1985, pp. 100—118.

## License

This software and documentation are released under the [GPL-2.0
license](https://spdx.org/licenses/GPL-2.0.html).

## Author
[Anton Shvetz](mailto:tz@sectorb.msk.ru?subject=postgresql-similarity)

(the underlying fstrcmp function was taken from gnu diffutils and modified by
[Peter Miller](mailto:pmiller@agso.gov.au) and [Marc Lehmann](mailto:schmorp@schmorp.de)).
