class SampleJob < ApplicationJob
  queue_as :default

  def perform(*args)
    Sidekiq::Logging.logger.info "サンプルジョブを実行しました"
    # bundle exec sidekiq -q default -q mailers
    # mailersも処理されるようにする必要がある
  end
end
