require_relative '../models/payment_task'
require 'logger'

log = Logger.new('task.log')

namespace 'tasks' do
  desc 'Listen events. Run delayed jobs/enqueued task. '
  task subscribe: :environment do
    loop do
      if task = PaymentTask.next
        begin
          log.debug '_'
          task.perform!(log)
        rescue => e
          task.update!(
            processing: false,
            next_try_at: 1.seconds.from_now,
            error: <<~ERROR
            #{e.class.name} :: #{e.message}
            #{e.backtrace.join("\n")}
            ERROR
          )
        end

        if task.error.blank?
          log.debug 'completed!'
          task.destroy
        end
      else
        sleep 1
      end
    end
  end
end

