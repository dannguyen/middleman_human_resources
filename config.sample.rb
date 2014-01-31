# only the s3_sync needs to be anonymized out of the repo but I'm too lazy to do it yet

require 'slim'
require 'lib/human_resources/job'

set :encoding, "utf-8"

I18n.enforce_available_locales = true
#Markdown
set :markdown_engine, :kramdown

#Livereload
activate :livereload

activate :syntax, :line_numbers => false
activate :directory_indexes


activate :s3_sync do |s3_sync|
  s3_sync.bucket                     = 'beta.newsnerdjobs.com' # The name of the S3 bucket you are targetting. This is globally unique.
  s3_sync.region                     = 'us-east-1'     # The AWS region for your bucket.
  s3_sync.aws_access_key_id          = 'NONONONONO'
  s3_sync.aws_secret_access_key      = 'passw0rdz'
  s3_sync.delete                     = false # We delete stray files by default.
  s3_sync.after_build                = false # We do not chain after the build step by default. 
  s3_sync.prefer_gzip                = true
  s3_sync.path_style                 = true
  s3_sync.reduced_redundancy_storage = false
  s3_sync.acl                        = 'public-read'
  s3_sync.encryption                 = false
end



###
# Page options, layouts, aliases and proxies
###


set :jobs, data.processed.jobs.map{|slug, job| HumanResources::Job.new(job, slug: slug) }

set :layout, :page
page "/", :layout => :home do 
  @hide_nav = true
end

jobs.each do |job|
  proxy "/jobs/#{job.slug}", 
        "/templates/job.html",
        locals: { job: job, title: "#{job.title} #{job.employer_name}" }
end



###
# Compass
###

# Change Compass configuration
# compass_config do |config|
#   config.output_style = :compact
# end


# Per-page layout changes:
#
# With no layout
# page "/path/to/file.html", :layout => false
#
# With alternative layout
# page "/path/to/file.html", :layout => :otherlayout
#
# A path which all have the same layout
# with_layout :admin do
#   page "/admin/*"
# end

# Proxy (fake) files
# page "/this-page-has-no-template.html", :proxy => "/template-file.html" do
#   @which_fake_page = "Rendering a fake page with a variable"
# end

# Site Settings
@analytics_account = false
@typekit_account = false

# Asset Settings
set :css_dir, 'assets/css'
set :js_dir, 'assets/js'
set :images_dir, 'assets/img'

# Add bower's directory to sprockets asset path
after_configuration do
  @bower_config = JSON.parse(IO.read("#{root}/.bowerrc"))
  sprockets.append_path File.join "#{root}", @bower_config["directory"]
end

# Build-specific configuration
configure :build do
  # For example, change the Compass output style for deployment
  activate :minify_css

  # Minify Javascript on build
  activate :minify_javascript

  # Create favicon/touch icon set from source/favicon_base.png
  # activate :favicon_maker

  # Enable cache buster
  # activate :cache_buster

  # alternative to cache buster
  # activate :asset_hash

  # compress all the things
  activate :gzip

  # Use relative URLs
  # activate :relative_assets

  # Compress PNGs after build
  # First: gem install middleman-smusher
  # require "middleman-smusher"
  # activate :smusher

  # Or use a different image path
  # set :http_path, "/Content/images/"
end

# ftp deployment configuration. 
# activate :deploy do |deploy|
#   deploy.method = :ftp
#   deploy.host = "ftp-host"
#   deploy.user = "ftp-user"
#   deploy.password = "ftp-password"
#   deploy.path = "ftp-path"
# end
