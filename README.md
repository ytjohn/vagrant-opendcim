openDCIM Vagrant
----------------

This is a quick setup to pull down a recent version of [openDCIM](http://www.opendcim.org/) and
get it running. As of this commit, it runs openDCIM 4.3.1 on Ubuntu Xenial 16.04.

You need:

 * [vagrant](https://www.vagrantup.com/)
 * [virtualbox](https://www.virtualbox.org/)

Assuming you have the above installed, simply run:

    vagrant up
    
This will fire up a vagrant instance, and openDCIM will be running on http://localhost:8085/
Username is `admin`, password is `admin`.

Once you go through the web-based install steps, be sure to `rm dcim/install.php` to proceed.

Take a look at [vagrant/provision.bash](vagrant/provision.bash) to see how installation works.

You can log into the vm by running:

    vagrant ssh
    
If you need to mess with the database, username root, password root will work. For example, to 
backup the dcim database, you can run:

    mysqldump -uroot -proot dcim > /vagrant/dcim.sql
    
To restore a mysql database:

    mysql -uroot -proot dcim < /vagrant/dcim.sql
    
To shut down the vagrant virtual machine:

    vagrant halt
    
To destroy the vagrant vm (all opendcim data will be lost, unless backed up)

    vagrant destroy

   