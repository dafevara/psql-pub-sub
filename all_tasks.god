root_dir = File.dirname(File.expand_path(__FILE__))

God.watch do |w|
  w.name = 'tasks'
  w.group = 'meetup'
  w.start = 'bundle exec rails tasks:subscribe --trace'
  w.keepalive(memory_max: 500.megabytes)
  w.dir = root_dir
end
