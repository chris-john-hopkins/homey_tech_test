# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
User.find_or_create_by!(email: 'user@example.com') do |u|
  u.password = 'password123'
  u.password_confirmation = 'password123'
end

user = User.first || User.create!(email: "test@example.com", password: "password")

# Define the number of projects to create
NUM_PROJECTS = 3

# Clear existing projects (WARNING: This deletes all projects and transitions)
ProjectTransition.destroy_all
Project.destroy_all

# Sample project titles
TITLES = [
  "Apollo Expansion", "Neptune Initiative", "Titan Overhaul",
  "Orion Development", "Mars Colonization", "Venus Terraforming"
]

# Rich HTML descriptions
DESCRIPTIONS = [
  "<h2>Project Overview</h2><p><strong>Apollo Expansion</strong> focuses on <em>scaling infrastructure</em> and ensuring future growth.</p>
  <ul>
    <li>Optimize logistics</li>
    <li>Expand data storage</li>
    <li>Enhance security protocols</li>
  </ul>
  <p>Read more: <a href='https://example.com'>Apollo Project</a></p>",

  "<h2>AI Research</h2><p>The <strong>Neptune Initiative</strong> is dedicated to <em>cutting-edge AI research</em> for automation.</p>
  <ul>
    <li>Develop deep learning models</li>
    <li>Enhance NLP processing</li>
    <li>Optimize computer vision</li>
  </ul>
  <p>Read more: <a href='https://example.com'>Neptune Research</a></p>",

  "<h2>Performance Upgrade</h2><p><strong>Titan Overhaul</strong> is about reworking our <em>backend systems</em> for better performance.</p>
  <ul>
    <li>Improve database indexing</li>
    <li>Refactor API endpoints</li>
    <li>Reduce response times</li>
  </ul>
  <p>Read more: <a href='https://example.com'>Titan Upgrade</a></p>"
]

STATUSES = [ "draft", "planning", "in_progress", "completed", "archived" ]

# Create projects with rich text descriptions
NUM_PROJECTS.times do
  project = Project.create!(
    title: TITLES.sample + " #{rand(100..999)}",
    description: ActionText::RichText.new(body: DESCRIPTIONS.sample),
    deadline: Time.now + rand(10..100).days,
    creator: user
  )

  puts "✅ Created Project: #{project.title} (State: #{project.state_machine.current_state})"
end

puts "✅ Seeded #{NUM_PROJECTS} projects with HTML-rich descriptions!"
