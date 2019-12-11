root_dir = File.dirname(File.expand_path(__FILE__))

#4.times do |t|
God.watch do |w|
  w.name = "tasks watcher/listener ##{t rescue 1}"
  w.start = 'bundle exec rake tasks:subscribe --trace'
  w.keepalive(memory_max: 1.megabytes)
  w.dir = root_dir
  w.log = "#{root_dir}/task.log"
end
#end
