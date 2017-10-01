require 'pg'
require('sinatra')
require('sinatra/reloader')
also_reload('lib/**/*.rb')
require('./lib/volunteer')
require('./lib/project')


 DB = PG.connect({:dbname => 'volunteer_tracker'})

get('/') do
  @projects = Project.all
  erb(:index)
end

post('/') do
  project = Project.new({name: params.fetch("name"), id: nil})
  project.save
  @projects = Project.all
  erb(:index)
end

get ('/projects/:id') do
  @project = Project.find(params["id"].to_i)
  @volunteers = @project.volunteers
  erb(:project)
end

get ('/volunteers/:id') do

  @volunteer = Volunteer.find(params.fetch("id").to_i())
  @project = Project.find(@volunteer.project_id)
  erb(:volunteer)
end

post('/projects/:id') do
  project_id = params.fetch("id").to_i()
  volunteer = Volunteer.new({name: params.fetch("name"), id: nil, project_id: project_id})
  volunteer.save
  @project = Project.find(project_id)
  @volunteers = @project.volunteers
  erb(:project)
end

get ('/projects/:id/update') do
  @project = Project.find(params["id"].to_i)
  erb(:project_update)
end

patch ('/projects/:id') do
  id = params["id"].to_i
  @project = Project.find(id)
  @project.update({name: params.fetch("name"), id: id})
  @volunteers = @project.volunteers
  erb(:project)
end

delete("/:id") do
  @project = Project.find(params.fetch("id").to_i())
  @project.delete()
  @projects = Project.all()
  erb(:index)
end

patch ('/volunteers/:id') do
  id = params.fetch("id").to_i()
  new_name = params.fetch("name")
  @volunteer = Volunteer.find(id)
  @volunteer.update({id: id, name: new_name, project_id: @volunteer.project_id})
  @project = Project.find(@volunteer.project_id)
  erb(:volunteer)
end

delete("/projects/:id") do
  volunteer = Volunteer.find(params.fetch("delete_id").to_i())
  volunteer.delete
  @project = Project.find(params["id"].to_i)
  @volunteers = @project.volunteers
  erb(:project)
end
