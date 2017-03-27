# Shepherd

A tool to ease the pain of documenting microservices and their dependencies. As a side effect it provides a dashboard for monitoring the status of your running instances, as well as a rest API for release automation.

## Quickstart

```
docker compose up -d
docker-compose exec web rails db:setup

#for example data
docker-compose exec web rails db:seed

```

## Usage
### User interface
#### Project overview
![project overview](/app/assets/images/overview.png)

#### Project health dashboard
![project health](/app/assets/images/health.png)

#### Administrate using ActiveAdmin
![admin](/app/assets/images/admin.png)

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
  "name":"Application Storage",
  "status":"up",
  "health_endpoint":"http://service1/ping",
  "is_user_entry_point":false,
  "created_at":"2017-03-07T15:01:24.000Z",
  "updated_at":"2017-03-23T23:37:23.000Z",
  "project":"Pay Per X",
  "team":"Wolf Team",
  "internal_dependencies":[
      {
        "id":10,
        "name":"Parsing Trigger",
        "status":"no_status",
        "health_endpoint":""
      }
    ],
  "external_dependencies":[],
  "dependency_of":[
      {
        "id":4,
        "name":"Pay Per X User Interface Provider",
        "status":"up",
        "health_endpoint":"http://service4/ping"
        },
        {...}
    ]
  }
  ```
