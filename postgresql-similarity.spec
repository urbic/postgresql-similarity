%define extension similarity
%define version 1.0

%define _pg_libdir %(pg_config --libdir)
%define _pg_sharedir %(pg_config --sharedir)
%define _pg_docdir %(pg_config --docdir)

Name:			postgresql-%{extension}
Summary:		Function similarity to make fuzzy comparisons between strings
Version:		%{version}
Release:		0
Source:			%{name}-%{version}.tar.xz
URL:			https://github.com/urbic/%{name}
Group:			Productivity/Databases/Tools
BuildRoot:		%{_tmppath}/%{name}-%{version}
BuildRequires: 	gcc make postgresql-devel libicu-devel
Requires:		postgresql postgresql-server
License:		Zlib

%description
Function similarity to make fuzzy comparisons between strings.

%prep
%setup -c

%build
%{__make} -C %{name}

%install
%makeinstall -C %{name} DESTDIR=%{buildroot}

%clean
%{__rm} -rf %{buildroot}

%files
%defattr(-,root,root,0644)
%{_pg_docdir}/../%{name}/README.md
%{_pg_libdir}/%{extension}.so
%{_pg_sharedir}/extension/%{extension}--%{version}.sql
%{_pg_sharedir}/extension/%{extension}.control

%changelog
