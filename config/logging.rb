Logging::Rails.configure do |config|

  # Configure the Logging framework with the default log levels
#  Logging.init %w[debug info warn error fatal]

  # Objects will be converted to strings using the :inspect method.
  if Rails.env.test?
    Logging.format_as :inspect
  end
  # The default layout used by the appenders.
#  layout = Logging.layouts.pattern(:pattern => '[%d] %-5l %c : %m\n')

  layout = Logging.layouts.pattern(:pattern => '%m\n')

  #Este controla la salida de las ordenes logger manuales, las que uno escribe intercalándola en código

  %w(
    Rails
    ActiveRecord::Base
    ActionView::Base
    ActionController::Base
    ApplicationController
    AuthenticationController

  ).each{ |clase| Logging.logger[clase].level = :warn}

  %w(
    Rails
    ActiveRecord::Base
    ActionView::Base
    ActionController::Base
    ApplicationController
    AuthenticationController
   ).each{ |clase| Logging.logger[clase].level = :info}



  %w(
   Api::V1::Electrico::CircuitosController
   AgregaCargaACircuito
   GetCargas
   ).each{ |clase| Logging.logger[clase].level = :info}




  Logging.color_scheme('dark',
    :levels => {
      :debug => :cyan,
      :info  => :bright_green,
      :warn  => :bright_yellow,
      :error => :bright_red,
      :fatal => [:white, :on_red]
    },
    :date => :bright_white,
    :logger => :bright_white,
    :message => :white
  )




  # Setup a color scheme called 'bright' than can be used to add color codes
  # to the pattern layout. Color schemes should only be used with appenders
  # that write to STDOUT or STDERR; inserting terminal color codes into a file
  # is generally considered bad form.
  Logging.color_scheme( 'bright',
    :levels => {
      :info  => :green,
      :warn  => :yellow,
      :error => :red,
      :fatal => [:white, :on_red]
    },
    :date => :blue,
    :logger => :cyan,
    :message => :magenta
  )

  # Configure an appender that will write log events to STDOUT. A colorized
  # pattern layout is used to format the log events into strings before
  # writing.
  if Rails.env.test?
    Logging.appenders.stdout( 'stdout',
      :auto_flushing => true,
      :layout => Logging.layouts.pattern(
	:pattern => '%l %c °|°  %m\n',
	:color_scheme => 'dark'
      )
    ) if config.log_to.include? 'stdout'
  else
    Logging.appenders.stdout( 'stdout',
      :auto_flushing => true,
      :layout => Logging.layouts.pattern(
	:pattern => '%l %c °|°  %m\n',
      )
    ) if config.log_to.include? 'stdout'
  end


  #:pattern => '[%d] %-5l %c : %m\n', valor original

  # Configure an appender that will write log events to a file. The file will
  # be rolled on a daily basis, and the past 7 rolled files will be kept.
  # Older files will be deleted. The default pattern layout is used when
  # formatting log events into strings.
  Logging.appenders.rolling_file( 'file',
    :filename => config.paths['log'].first,
    :keep => 7,
    :age => 'daily',
    :truncate => false,
    :auto_flushing => true,
    :layout => layout
  ) if config.log_to.include? 'file'

  # NOTE: You will need to install the `logging-email` gem to use this appender
  # with loggging-2.0. The email appender was extracted into a plugin gem. That
  # is the reason this code is commented out.
  #
  # Configure an appender that will send an email for "error" and "fatal" log
  # events. All other log events will be ignored. Furthermore, log events will
  # be buffered for one minute (or 200 events) before an email is sent. This
  # is done to prevent a flood of messages.
=begin
ActionMailer::Base.smtp_settings={
    :address => 'mail.privateemail.com',
    :port => 587,
    :authentication => :plain,
    :user_name => ENV['SENDER'],
    :password => ENV['SMTP']
}
=end

  Logging.appenders.email( 'email',
    :from     => "server@alectrico.cl",
    :to       => "developers@alectrico.cl",
    :subject  => "Rails Error [#{%x(uname -n).strip}]",
    :server   => 'mail.privateemail.com',
    :acct     => ENV['SENDER'],
    :passwd   => ENV['SMTP'],
    :authtype => :plain,
    :port     => 587,
    :auto_flushing => 200,     # send an email after 200 messages have been buffered
    :flush_period  => 60,      # send an email after one minute
    :level         => :info,  # only process log events that are "error" or "fatal"
    :layout        => layout
  ) if config.log_to.include? 'email'

  # Setup the root logger with the Rails log level and the desired set of
  # appenders. The list of appenders to use should be set in the environment
  # specific configuration file.
  #
  # For example, in a production application you would not want to log to
  # STDOUT, but you would want to send an email for "error" and "fatal"
  # messages:
  #
  # => config/environments/production.rb
  #
  #     config.log_to = %w[file email]
  #
  # In development you would want to log to STDOUT and possibly to a file:
  #
  # => config/environments/development.rb
  #     config.log_to = %w[stdout file]
  #
  Logging.logger.root.level = config.log_level
  Logging.logger.root.appenders = config.log_to unless config.log_to.empty?

  # Under Phusion Passenger smart spawning, we need to reopen all IO streams
  # after workers have forked.
  #
  # The rolling file appender uses shared file locks to ensure that only one
  # process will roll the log file. Each process writing to the file must have
  # its own open file descriptor for `flock` to function properly. Reopening
  # the file descriptors after forking ensures that each worker has a unique
  # file descriptor.
  if defined? PhusionPassenger
    PhusionPassenger.on_event(:starting_worker_process) do |forked|
      Logging.reopen if forked
    end
  end
end
