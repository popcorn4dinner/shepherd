# Shepherd - Service Catalogue

A tool to ease the pain of documenting microservices and their dependencies. As a side effect it provides a dashboard for monitoring the status of your running instances, as well as a rest API for release automation.

## Quickstart

```
docker compose up -d
docker-compose exec web rails db:setup

#for example data
docker-compose exec web rails db:seed

```

## Usage
### Freska Service Catalogue project files
You can import all information about your service from a `.shepherd.yaml` file in your project repository.
This allows you to let your dependency documentation evolve together with the features you add.
If you are using a Continuous integration / Continuous Delivery solution like GitlabCI, Bamboo or GoCD, you can call
the endpoint `POST /service/{service-name}/update` to reimport the `.shepherd.yaml` file automatically from your project
 repository.
#### Basic Information

```yaml
name: awesome-video-compressor
team: some team
project: Awesome Streaming
description: This microservice compresses video streams and stores them in a s3 bucket
documentaion_url: http://optional-url-to-your-docs
```

#### Health monitoring
You can use Freska Service Catalogue to monitor the health of your services in production.
In order to do so, you have to add either of the following lines to your `.shepherd.yaml` file.

##### Simple url
```yaml
health_endpoint: http://awesome-video-processor-url/ping
```

##### Serivce discovery
At the moment only `consul` service discovery is supported.
```yaml
health_endpoint: consul:awesome-video-comppressor

```
#### User entry point
This key is to document, if this service is being directly accessed by users of your system. Default is `false`.
```yaml
user_entry_point: true
```

#### Dependencies
This section of your `.shepherd.yaml` file lets you define what the critical dependencies you have on other (mirco)services in your system are.
```yaml
dependencies:
    - awesome-storage-service
    - awesome-video-encoding-service
```

#### External Resources
External resources are things like Databases, Filesystems, Queues, etc.
Basically everything you need to be in your dependency tree, but is not a microservice.
In your `.shepherd.yaml` file it looks something like this:
```yaml
external_resources:
  - MySQL Database
  - RabbitMQ
  - Legacy Appliction XYZ
```
### API
*/admin/projects/{project-slug}.json*

```
{
  "id":1,
  "name":"Project name",
  "slug":"project-name",
  "created_at":"2017-03-07T15:01:24.000Z",
  "updated_at":"2017-03-23T23:37:43.000Z",
  "team":"Team Name",
  "services":[
      {
        "id":1,
        "name":"Some Service",
        "slug":"some-service",
        "status":"up",
        "health_endpoint":"http://service1/ping"
      },
      {...}
      ]
}
```


*/admin/services/{service-slug}.json*
```
{
  "id":1,
  "name":"Some Storage Service",
  "status":"up",
  "health_endpoint":"http://service1/ping",
  "is_user_entry_point":false,
  "created_at":"2017-03-07T15:01:24.000Z",
  "updated_at":"2017-03-23T23:37:23.000Z",
  "project":"Pay Per X",
  "team":"Some Team",
  "internal_dependencies":[
      {
        "id":10,
        "name":"Parsing Service",
        "status":"no_status",
        "health_endpoint":""
      }
    ],
  "external_dependencies":[],
  "dependency_of":[
      {
        "id":4,
        "name":"Some Other Service",
        "status":"up",
        "health_endpoint":"http://service4/ping"
        },
        {...}
    ]
  }
  ```

## Installation
