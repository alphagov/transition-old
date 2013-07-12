class AuditLogger < Logger

  def initialize(logdev, error_class, shift_age = 0, shift_size = 1048576)
    super(logdev, shift_age, shift_size)
    @level = INFO
    @error_class = error_class
  end

  def format_message(severity, timestamp, progname, msg)
    puts msg unless defined?(params) # use puts if not a request ie call from a rake file
    "#{timestamp.to_formatted_s(:db)} #{severity} #{msg}\n"
  end
end
