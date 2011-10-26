require "logstash/agent"
require 'rubygems'   
require 'net/ssh/gateway'

class LogStash::Fetch < LogStash::Agent
  public
  def initialize
    super()
    @server = nil
    @user = nil
  end # def initialize

  alias :super_options :options
  alias :super_run_with_config :run_with_config

  private
  def options(opts)
    opts.on("-s SERVER", "--ssh-server SERVER", "Server for SSH tunnel") do |arg|
      @server = arg
    end

    opts.on("-u USER", "--ssh-user USER", "Username for SSH tunnel") do |arg|
      @user = arg
    end
    
    super_options(opts)
  end # def options


  public
  def run_with_config(config)
    Process.spawn("ssh -N -L 5672:127.0.0.1:5672 #{@user}@#{@server}")
    
    super_run_with_config(config)
  end

end # class LogStash::Fetch

if __FILE__ == $0
  $: << "net"
  agent = LogStash::Fetch.new
  agent.argv = ARGV
  agent.run
end
