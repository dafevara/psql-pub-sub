require_relative '../models/payment_task'

namespace 'tasks' do
  desc 'Listen events. Run delayed jobs/enqueued task. '
  task subscribe: :environment do
    loop do
      if task = PaymentTask.next
        begin
          task.perform!
        rescue => e
          p 'updating'
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
          task.destroy
        end
      else
        sleep 1
      end
    end
  end
end

