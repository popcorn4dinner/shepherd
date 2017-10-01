Team.create!([
  {name: "Wolf Team", slug: "wolf-team"},
  {name: "Team II", slug: "team-ii"}
])
ExternalResource.create!([
  {name: "Legacy DB", slug: "legacy-db"},
  {name: "StepStone CF Application", slug: "stepstone-cf-application"},
  {name: "Selligent", slug: "selligent"},
  {name: "JobFeed", slug: "jobfeed"},
  {name: "Notification Queue", slug: "notification-queue"},
  {name: "Parsing Queue", slug: "parsing-queue"},
  {name: "Textkernel CV Parser", slug: "textkernel-cv-parser"}
])
Project.create!([
  {name: "Pay Per X", team_id: 1, slug: "pay-per-x"},
  {name: "Notifications", team_id: 2, slug: "notifications"}
])
Service.create!([
  {name: "Application Storage", health_endpoint: "http://service1/ping", project_id: 1, is_user_entry_point: false, slug: "application-storage"},
  {name: "Job Offer Publisher", health_endpoint: "http://service2/ping", project_id: 1, is_user_entry_point: false, slug: "job-offer-publisher"},
  {name: "User Gateway", health_endpoint: "http://service3/ping", project_id: 1, is_user_entry_point: true, slug: "user-gateway"},
  {name: "Pay Per X User Interface Provider", health_endpoint: "http://service4/ping", project_id: 1, is_user_entry_point: false, slug: "pay-per-x-user-interface-provider"},
  {name: "Mail Service", health_endpoint: "http://service5/ping", project_id: 1, is_user_entry_point: false, slug: "mail-service"},
  {name: "Job Offer Storage", health_endpoint: "http://service6/ping", project_id: 1, is_user_entry_point: nil, slug: "job-offer-storage"},
  {name: "Backoffice", health_endpoint: "http://service7/ping", project_id: 1, is_user_entry_point: true, slug: "backoffice"},
  {name: "Notification Trigger", health_endpoint: "", project_id: 2, is_user_entry_point: false, slug: "notification-trigger"},
  {name: "Parsing Worker", health_endpoint: "", project_id: 1, is_user_entry_point: false, slug: "parsing-worker"},
  {name: "Parsing Trigger", health_endpoint: "", project_id: 1, is_user_entry_point: false, slug: "parsing-trigger"}
])

ExternalResources_Services.create!([
  {external_resource_id: 3, service_id: 8},
  {external_resource_id: 5, service_id: 8},
  {external_resource_id: 5, service_id: 5},
  {external_resource_id: 6, service_id: 9},
  {external_resource_id: 6, service_id: 10},
  {external_resource_id: 2, service_id: 1},
  {external_resource_id: 7, service_id: 9},
  {external_resource_id: 4, service_id: 2}
])

Dependency.create!([
  {type: nil, service_id: 2, dependency_id: 6},
  {type: nil, service_id: 4, dependency_id: 1},
  {type: nil, service_id: 4, dependency_id: 6},
  {type: nil, service_id: 4, dependency_id: 3},
  {type: nil, service_id: 7, dependency_id: 1},
  {type: nil, service_id: 7, dependency_id: 6},
  {type: nil, service_id: 7, dependency_id: 2},
  {type: nil, service_id: 7, dependency_id: 3},
  {type: nil, service_id: 4, dependency_id: 5},
  {type: nil, service_id: 1, dependency_id: 10},
  {type: nil, service_id: 9, dependency_id: 1}
])
