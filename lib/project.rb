
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


  def volunteers
    volunteers = []
    list = DB.exec("SELECT * FROM volunteers WHERE project_id = '#{@id}'")
    list.each do |volunteer|
      id = volunteer.fetch("id").to_i
      project_id = volunteer.fetch("project_id").to_i
      name = volunteer.fetch("name")
      volunteers.push(Volunteer.new({id: id, project_id: project_id, name: name}))
    end
    volunteers
  end

  def update(attributes)
    @id = self.id
    @name = attributes.fetch(:name)
    DB.exec("UPDATE projects SET name = '#{@name}' WHERE id = #{@id};")
  end

  def delete
    DB.exec("DELETE FROM projects WHERE id = #{@id};")
  end

end
