gem 'ember-rails'
gem 'bootstrap'
gem 'rabl'
gem 'oj'
gem 'figaro'
gem 'devise'
gem 'activeadmin', github: 'activeadmin'

Dir[File.join(__dir__, 'files/**/*')].select { |f| File.file?(f) }.map { |f| f.gsub(File.join(__dir__, 'files/'), '') }.each do |path|
  file path, File.read(File.join(__dir__, "files/#{path}"))
end

inject_into_file 'app/controllers/application_controller.rb', after: "protect_from_forgery with: :exception\n" do <<-'RUBY'
  before_action :authenticate_user!
RUBY
end

inject_into_file 'app/views/layouts/application.html.erb', before: "<%= yield %>" do <<-HTML
<div class="container devise">
HTML
end

inject_into_file 'app/views/layouts/application.html.erb', after: "<%= yield %>\n" do <<-HTML
</div>
HTML
end

run 'rm app/assets/stylesheets/application.css'

route "root to: 'assets#index'"

after_bundle do
  generate 'devise:install'
  generate 'devise User'
  generate 'ember:bootstrap'

  git :init
  git add: '.'
  git commit: "-a -m 'Initial commit'"
end
