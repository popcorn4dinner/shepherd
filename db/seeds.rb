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
  {name: "Application Storage", health_endpoint: "http://application_storage:4000/ping", project_id: 1}
])
Team.create!([
  {name: "Wolf Team"},
  {name: "Team II"}
])
