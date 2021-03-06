module ExtRake
  class UpdateApplication < ExtRake.config.parent_task.constantize
    GEMFILE_LOCK = /Gemfile\.lock$/

    def self.steps
      %i(
        check_remote
        update
      )
    end

    protected

    def check_remote
      sh 'git fetch origin master'

      current_commit, remote_commit = `git rev-parse master origin/master`.split("\n")

      @updated = (current_commit == remote_commit)
    end

    def update
      return if @updated

      changes = `git status --porcelain`.split("\n")
      if changes.size > 1 || (changes.size == 1 && !changes.first.match(GEMFILE_LOCK))
        raise 'Files other than the Gemfile.lock would be overwritten.'
      end

      sh 'git reset --hard HEAD'
      sh 'git pull origin master'
      sh 'bundle install'
      sh 'rake db:migrate RAILS_ENV=production'
    end
  end
end
