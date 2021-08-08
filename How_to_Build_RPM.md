## Author = Dushan Wijesinghe
Original post = https://devopslinux.wordpress.com/2016/04/24/rpm-build/
```
yum install rpm-build rpmdevtools tree

cd ~/

rpmdev-setuptree

#create directory in your source folder according to the destination here we copy document root contents & vhost

cd ~/rpmbuild/SOURCES/
mkdir -p  wwwroot-1/var/www/html/dushan.example.com (wwwroot-1 is package name and the version)
mkdir -p  vhost-conf-1/etc/httpd/conf.d

#Copy your source files to wwwroot
#==================================
cp index.html ~/rpmbuild/SOURCES/wwwroot-1/var/www/html/dushan.example.com
cp dushan.example.com.conf ~/rpmbuild/SOURCES/vhostconf-1/etc/httpd/conf.d

cd ~/rpmbuild/SOURCES
tar -czvf wwwroot-1.tar.gz wwwroot-1
tar -czvf vhostconf-1.tar.gz vhost-conf1

#Now Create the specs file
#=========================
cd ~/rpmbuild/SPECS
rpmdev-newspec vhostconf.spec

# vim vhostconf.spec

Name:           vhostconf
Version:        1
Release:        0
Summary:        Vhost File
Group:          System Environment/Base
License:        GPL
URL:            http://ons247.wordpress.com
Source0:        vhostconf-1.tar.gz
BuildArch:      noarch
BuildRoot:      %{_tmppath}/%{name}-buildroot

%description
This will remove all contents in DocumentRoot and copy vhost

%prep
%setup -q
rm -rf /etc/httpd/conf.d/dushan.example.com.conf

%install
mkdir -p $RPM_BUILD_ROOT
cp -R * "$RPM_BUILD_ROOT"

%clean
rm -rf $RPM_BUILD_ROOT

%files
%defattr(-,root,root,-)
%doc /etc/httpd/conf.d/dushan.example.com.conf


# vim wwwroot.spec
Name:           wwwroot
Version:        1
Release:        0
Summary:        Document root contects
Group:          System Environment/Base
License:        GPL
URL:            http://ons247.wordpress.com
Source0:        wwwroot-1.tar.gz
BuildArch:      noarch
BuildRoot:      %{_tmppath}/%{name}-buildroot

%description
This will remove all contents in DocumentRoot and copy vhost

%prep
%setup -q
rm -rf /var/www/html/dushan.example.com
mkdir -p /var/www/html/dushan.example.com

%install
mkdir -p $RPM_BUILD_ROOT
cp -R  * "$RPM_BUILD_ROOT"


%clean
rm -rf $RPM_BUILD_ROOT

%files
%defattr(-,root,root,-)
%doc /var/www/html/dushan.example.com/*.html
============================================================================

rpmbuild -v -bb ~/rpmbuild/SPECS/{filename}.spec (to build new rpm)
rpm -qpl rpmbuild/RPMS/noarch/{filename}.rpm (to check content inside rpm)
rpm -i rpmbuild/RPMS/noarch/{filename}.rpm ( to install)
```
