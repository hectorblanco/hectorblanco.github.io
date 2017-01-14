task :default => ["server"]

desc "Starts the jekyll server and watch for changes"
task :server, [:port] do |t, args|
  args.with_defaults(:port => "4000")
  pids = [
    spawn("bundle exec jekyll serve --watch --port #{args[:port]}"),
    spawn("sass --watch _assets/scss:assets/css"),
    spawn("coffee -w -o assets/js -c _assets/coffee/main.coffee")
  ]

  trap "INT" do
    Process.kill "INT", *pids
    exit 1
  end

  loop do
    sleep 1
  end
end

task :clean do
  rm_rf "_site"
end

desc "Compiles SCSS/COFFEE into assets"
task :build do
  sh "sass --update _assets/scss:assets/css"
  sh "coffee -o assets/js -c _assets/coffee/main.coffee"
end