Team.create!([
  {name: "Wolf Team"},
  {name: "Team II"}
])
ExternalResource.create!([
  {name: "Legacy DB"},
  {name: "StepStone CF Application"},
  {name: "Selligent"},
  {name: "JobFeed"}
])
Project.create!([
  {name: "Pay Per X", team_id: 1},
  {name: "Notifications", team_id: 2}
])
Service.create!([
  {name: "Application Storage", health_endpoint: "http://service1/ping", project_id: 1},
  {name: "Job Offer Publisher", health_endpoint: "http://service2/ping", project_id: 1},
  {name: "User Gateway", health_endpoint: "http://service3/ping", project_id: 1},
  {name: "Pay Per X User Interface Provider", health_endpoint: "http://service4/ping", project_id: 1},
  {name: "Mail Service", health_endpoint: "http://service5/ping", project_id: 1},
  {name: "Job Offer Storage", health_endpoint: "http://service6/ping", project_id: 1},
  {name: "Backoffice", health_endpoint: "http://service7/ping", project_id: 1}
])

Dependency.create!([
  {type: nil, service_id: 4, dependency_id: 1},
  {type: nil, service_id: 3, dependency_id: 4},
  {type: nil, service_id: 5, dependency_id: 1},
  {type: nil, service_id: 5, dependency_id: 3},
  {type: nil, service_id: 2, dependency_id: 6},
  {type: nil, service_id: 5, dependency_id: 6},
  {type: nil, service_id: 7, dependency_id: 1},
  {type: nil, service_id: 7, dependency_id: 3},
  {type: nil, service_id: 7, dependency_id: 2},
  {type: nil, service_id: 7, dependency_id: 6},
  {type: nil, service_id: 4, dependency_id: 5},
  {type: nil, service_id: 4, dependency_id: 6}
])
ExternalResource::HABTM_Services.create!([
  {external_resource_id: 1, service_id: 1},
  {external_resource_id: 4, service_id: 2},
  {external_resource_id: 3, service_id: 5}
])
