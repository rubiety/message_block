Then /^The file "([^"]*)" should exist in the application$/ do |path|
  assert File.exists?(File.join(PROJECT_ROOT, path))
end
