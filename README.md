##here are the commmands to build the docker image with docker file
##listing the docker images commands
##listing the docker running containers
##docker images tagging by local image to the docker hub repo name
##pushing the docker images to the docker hub repo


#install the docker in linux by following the command
sudo yum install docker -y

#start the service
sudo service docker start

#check the service of docker is active or inactive
sudo service docker status

#list the docker images 
sudo docker images

#create a dockerfile
sudo vim Dockerfile

#after creating dockerfile build the image by follwing command
sudo docker build -t initutive-cloud-image:1.0 .

#now list the docker images
sudo docker images

#to list the running containers
sudo docker ps

#run or start the container from the image follwing is the command
sudo docker run -it --name init-cloud-test initutive-cloud-image:1.0

#tag the local docker image to newly created docker repo image
sudo docker tag initutive-cloud-image:1.0 vishwaprince/intuitive-cloud-docker-image:inticloud-vishwa-2023-09-1

#and push the docker image to the newrepo in docker hub registery
docker pull vishwaprince/intuitive-cloud-docker-image:inticloud-vishwa-2023-09-1


#and the repo is public you can pull the follwing command
docker pull vishwaprince/intuitive-cloud-docker-image:inticloud-vishwa-2023-09-1



Thank you,
vishwanath




