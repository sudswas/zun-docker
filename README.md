# zun-docker
Bootstrap to zun development

This is a rather bulky way of doing things at the moment. Hence the README will get updated when I move to docker-compose.

At the moment though if you want to play around.

1. Clone the code.
2. Go to each folder and build the docker image via:

  docker build -t <your-tag> .

3. At the end of this process, you should have 3 docker images:
  - For mysql
  - For keystone + Rabbit
  - For Zun + docker

4. Run the services in sequence using:
  
  - docker run -itd --name mysql --hostname mysql <mysql-image-name>
  - docker run -itd --name keystone --link mysql:mysql --hostname controller <keystone-image-name>
  - docker run -itd --privileged --name zun_service --hostname zun --link mysql:mysql --link keystone:controller <zun-image-name>

This should create 3 containers that are inter-networked and you will have the zun service ready to go for development.

FINALLY, this is strictly for development and I have a bunch of improvements to make this, that i will do in the process!
