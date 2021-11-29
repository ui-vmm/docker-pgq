# uivmm/docker-pgq

The `uivmm/docker-pgq` image provides tags for running Postgres with [PgQ](https://github.com/pgq) extensions installed and daemon pgqd. This image is based on the official [`postgres`](https://registry.hub.docker.com/_/postgres/) image and provides debian.

This image ensures that the default database created by the parent `postgres` image will have the following extensions installed:

* `pgq`
* `pgq_coop`

## Usage

In order to run a basic container capable of serving a pgq-enabled database, start a container as follows:

    docker run --name some-pgq -e POSTGRES_PASSWORD=mysecretpassword -d uivmm/docker-pgq:3.4.2

For more detailed instructions about how to start and control your Postgres container, see the documentation for the `postgres` image [here](https://registry.hub.docker.com/_/postgres/).

Once you have started a database container, you can then connect to the database either directly on the running container:

    docker exec -ti some-pgq psql -U postgres
    
... or starting a new container to run as a client. In this case you can use a user-defined network to link both containers:

    docker network create some-network
    
    # Server container
    docker run --name some-pgq --network some-network -e POSTGRES_PASSWORD=mysecretpassword -d uivmm/docker-pgq:3.4.2
    
    # Client container
    docker run -it --rm --network some-network uivmm/docker-pgq:3.4.2 psql -h some-pgq -U postgres
    
Check the documentation on the [`postgres` image](https://registry.hub.docker.com/_/postgres/) and [Docker networking](https://docs.docker.com/network/) for more details and alternatives on connecting different containers.

See [the pgq documentation](http://pgq.net/docs/pgq_installation.html#create_new_db_extensions) for more details on your options for creating and using a spatially-enabled database.
