
class Project
  attr_reader :name, :id
  def initialize(attributes)
    @id = attributes.fetch(:id)
    @name = attributes.fetch(:name)
  end

  def == (another_project)
    self.name == another_project.name
  end


  def self.all
    returned_projects = DB.exec("SELECT * FROM projects;")
    projects = []
    returned_projects.each do |project|
      id = project.fetch("id")
      name = project.fetch("name")
      projects.push(Project.new({id: id.to_i, name: name}))
    end
    projects
  end

  def save
  result = DB.exec("INSERT INTO projects (name) VALUES ('#{@name}') RETURNING id;")
  @id = result.first.fetch("id").to_i
  end

  def self.find(id)
   found_project = nil
   Project.all.each do |project|
     if project.id == id
       found_project = project
     end
   end
   found_project
 end








end
