require 'xcodeproj'

project_path = 'ios/Runner.xcodeproj'
project = Xcodeproj::Project.open(project_path)
target = project.targets.first

file_name = 'GoogleService-Info.plist'

unless project.files.any? { |f| f.path == file_name || f.path == "Runner/#{file_name}" }
  runner_group = project.main_group.find_subpath('Runner', true)
  file_ref = runner_group.new_reference(file_name)
  target.resources_build_phase.add_file_reference(file_ref)
  project.save
  puts "Added #{file_name} to Xcode project."
else
  puts "#{file_name} already exists in the project."
end
