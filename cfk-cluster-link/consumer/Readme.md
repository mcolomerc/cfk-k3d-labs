docker build -it go-consumer . 


docker tag go-consumer:latest localhost:5050/go-consumer:1.0.0

docker push localhost:5050/go-consumer:1.0.0


kubectl create deployment go-consumer --image=k3d-app-registry:5050/go-consumer:1.0.0

export APP_NAME=go-consumer

export DOCKER_REPO=localhost:5050

export K3D_REGISTRY=k3d-app-registry:5050