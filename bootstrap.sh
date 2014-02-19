#base
locale-gen en_US.UTF-6
ntpdate us.pool.ntp.org
apt-get install -y language-pack-en-base
apt-get update
apt-get install -y make
apt-get install -y daemontools-run
apt-get install -y git
apt-get install -y nmap
ln -s /etc/services /services


# graphite web
export GRAPHITE_ROOT=/opt/graphite
export PYTHONPATH=$PYTHONPATH:$GRAPHITE_ROOT/webapp


#dependencies
git clone https://github.com/graphite-project/graphite-web.git
git clone https://github.com/graphite-project/carbon.git
git clone https://github.com/graphite-project/whisper.git
git clone https://github.com/pyr/cyanite.git

apt-get install -y apache2
apt-get install -y libapache2-mod-wsgi
apt-get install -y python-pip
apt-get install -y python-cairo-dev
apt-get install -y python-django
apt-get install -y python-django-tagging
apt-get install -y python-rrdtool
pip install pytz

#install whisper
pushd whisper
python setup.py install
popd

#install carbon
pushd carbon
python setup.py install
popd

#install graphite-web and configure apache
pushd graphite-web
python setup.py install
cp /vagrant/default /etc/apache2/sites-available/default
popd

#configure carbon/whisper
pushd /opt/graphite/conf
cp carbon.conf.example carbon.conf
cp storage-schemas.conf.example storage-schemas.conf
cp graphite.wsgi.example graphite.wsgi
sudo chown -R www-data:www-data /opt/graphite/storage
sudo mkdir -p /etc/httpd/wsgi
popd


#start apache 
service apache2 restart

#setup MOTD
cat >>/etc/motd <<EOF
You need to manually init the graphite database by doing the following: 

cd graphite-web
export PYTHONPATH=$PYTHONPATH:$GRAPHITE_ROOT/webapp
django-admin. syncdb --settings=graphite.settings

EOF
